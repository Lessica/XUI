//
//  XUIListViewController.m
//  XXTExplorer
//
//  Created by Zheng on 17/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIPrivate.h"
#import "XUIListViewController.h"

#import "XUIListHeaderView.h"
#import "XUIListFooterView.h"

#import "XUIGroupCell.h"

#import "XUICellFactory.h"
#import "XUILogger.h"
#import "XUITheme.h"
#import "XUIAdapter.h"

@interface XUIListViewController () <XUICellFactoryDelegate>

@property (nonatomic, strong, readonly) XUICellFactory *cellFactory;
@property (nonatomic, strong) NSMutableArray <XUIBaseCell *> *cellsNeedStore;
@property (nonatomic, assign) BOOL shouldStoreCells;

@property (nonatomic, strong) UIBarButtonItem *closeButtonItem;
@property (nonatomic, strong) UIBarButtonItem *aboutButtonItem;
@property (nonatomic, assign) UIEdgeInsets defaultContentInsets;

@end

@implementation XUIListViewController

@synthesize theme = _theme, logger = _logger, adapter = _adapter;

#pragma mark - Initializers

- (instancetype)initWithPath:(NSString *)path {
    if (!path)
        return nil;
    _bundle = [NSBundle mainBundle];
    _path = path;
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithPath:(NSString *)path withBundlePath:(NSString *)bundlePath {
    if (!path || !bundlePath)
        return nil;
    NSString *absolutePath = nil;
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    if ([path isAbsolutePath]) {
        absolutePath = path;
    } else {
        absolutePath = [bundle pathForResource:path ofType:nil];
    }
    if (!absolutePath) {
        return nil;
    }
    _bundle = bundle;
    _path = absolutePath;
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    {
        _cellsNeedStore = [[NSMutableArray alloc] init];
        
        NSString *entryExtension = [self.path pathExtension];
        NSString *adapterName = [NSString stringWithFormat:@"XUIAdapter_%@", [entryExtension lowercaseString]];
        Class adapterClass = NSClassFromString(adapterName);
        if (!adapterClass) {
            return;
        }
        id <XUIAdapter> adapter = (id <XUIAdapter>) [[(id)adapterClass alloc] initWithXUIPath:self.path Bundle:self.bundle];
        if (!adapter) {
            return;
        }
        _adapter = adapter;
        
        NSError *xuiError = nil;
        XUICellFactory *cellFactory = [[XUICellFactory alloc] initWithAdapter:adapter Error:&xuiError];
        if (!xuiError) {
            cellFactory.delegate = self;
            _cellFactory = cellFactory;
        } else {
            [self presentErrorAlertController:xuiError];
        }
        
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Title
    if (self.title.length == 0) {
        NSString *entryPath = self.path;
        if (entryPath) {
            NSString *entryName = [entryPath lastPathComponent];
            self.title = entryName;
        }
    }
    
    [self initSubviews];
    
    // Configuration Title
    NSDictionary <NSString *, id> *rootEntry = self.cellFactory.rootEntry;
    NSString *listTitle = rootEntry[@"title"];
    if (listTitle) {
        self.title = [self.adapter localizedStringForKey:listTitle value:listTitle];
    }
    [self.cellFactory parse];
    
    // header
    NSString *listHeader = rootEntry[@"header"];
    NSString *listSubheader = rootEntry[@"subheader"];
    if ([listHeader isKindOfClass:[NSString class]] && [listSubheader isKindOfClass:[NSString class]]) {
        self.headerView.headerText = [self.adapter localizedStringForKey:listHeader value:listHeader];
        self.headerView.subheaderText = [self.adapter localizedStringForKey:listSubheader value:listSubheader];
    }
    
    // footer
#ifdef DEBUG
    NSString *listFooter = rootEntry[@"footer"];
    if ([listFooter isKindOfClass:[NSString class]]) {
        self.footerView.footerText = [self.adapter localizedStringForKey:listFooter value:listFooter];
    }
#else
    self.footerView.footerText = NSLocalizedString(@"This page is provided by the script producer.", nil);
#endif
    
    // setup frame
    [self setupSubviews];
    
    // navigation items
    if ([self.navigationController.viewControllers firstObject] == self) {
        XUI_START_IGNORE_PARTIAL
        if (XUI_COLLAPSED) {
            [self.navigationItem setLeftBarButtonItem:self.splitViewController.displayModeButtonItem];
        } else {
            [self.navigationItem setLeftBarButtonItem:self.closeButtonItem];
        }
        XUI_END_IGNORE_PARTIAL
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidAppear:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    [super viewWillAppear:animated];
    [self storeCellsIfNecessary];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)initSubviews {
    XUIListHeaderView *headerView = [[XUIListHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0.f)];
    _headerView = headerView;
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 44.f;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        XUI_START_IGNORE_PARTIAL
        if (@available(iOS 9.0, *)) {
            tableView.cellLayoutMarginsFollowReadableWidth = NO;
        }
        XUI_END_IGNORE_PARTIAL
        tableView;
    });
    
    XUIListFooterView *footerView = [[XUIListFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0.f)];
    _footerView = footerView;
}

- (void)setupSubviews {
    [self.view addSubview:self.tableView];
    
    self.tableView.contentInset =
    self.tableView.scrollIndicatorInsets = self.defaultContentInsets;
    [self.tableView setContentOffset:CGPointMake(0, -self.defaultContentInsets.top) animated:YES];
    
    if (@available(iOS 8.0, *)) {
        {
            CGFloat height = self.headerView.intrinsicContentSize.height;
            CGRect headerFrame = self.headerView.frame;
            headerFrame.size.height = height;
            self.headerView.frame = headerFrame;
            [self.tableView setTableHeaderView:self.headerView];
            self.headerView.theme = self.theme;
        }
        
        {
            CGFloat height = self.footerView.intrinsicContentSize.height;
            CGRect footerFrame = self.footerView.frame;
            footerFrame.size.height = height;
            self.footerView.frame = footerFrame;
            [self.tableView setTableFooterView:self.footerView];
            self.footerView.theme = self.theme;
        }
    } else {
        {
            [self.headerView setNeedsLayout];
            [self.headerView layoutIfNeeded];
            CGFloat height = [self.headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            CGRect headerFrame = self.headerView.frame;
            headerFrame.size.height = height;
            self.headerView.frame = headerFrame;
            [self.tableView setTableHeaderView:self.headerView];
            self.headerView.theme = self.theme;
        }
        
        {
            [self.footerView setNeedsLayout];
            [self.footerView layoutIfNeeded];
            CGFloat height = [self.footerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            CGRect footerFrame = self.footerView.frame;
            footerFrame.size.height = height;
            self.footerView.frame = footerFrame;
            [self.tableView setTableFooterView:self.footerView];
            self.footerView.theme = self.theme;
        }
    }
}

#pragma mark - Getters

- (XUITheme *)theme {
    return self.cellFactory.theme;
}

- (XUILogger *)logger {
    return self.cellFactory.logger;
}

#pragma mark - UIView Getters

- (UIBarButtonItem *)closeButtonItem {
    if (!_closeButtonItem) {
        UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonItemTapped:)];
        closeButtonItem.tintColor = [UIColor whiteColor];
        _closeButtonItem = closeButtonItem;
    }
    return _closeButtonItem;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return self.cellFactory.sectionCells.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.cellFactory.otherCells[(NSUInteger) section].count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (@available(iOS 8.0, *)) {
        return 44.f;
    } else {
        return [self tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        XUIBaseCell *cell = self.cellFactory.otherCells[(NSUInteger) indexPath.section][(NSUInteger) indexPath.row];
        CGFloat cellHeight = [cell.xui_height floatValue];
        if (cellHeight > 0) {
            return cellHeight;
        } else {
            if ([[cell class] layoutUsesAutoResizing]) {
                [cell setNeedsUpdateConstraints];
                [cell updateConstraintsIfNeeded];
                
                cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
                [cell setNeedsLayout];
                [cell layoutIfNeeded];
                
                CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                CGFloat fixedHeight = (height > 0) ? (height + 1.f) : 44.f;
                return fixedHeight;
            } else {
                return UITableViewAutomaticDimension;
            }
        }
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        NSString *title = self.cellFactory.sectionCells[(NSUInteger) section].xui_label;
        return [self.adapter localizedStringForKey:title value:title];
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        NSString *title = self.cellFactory.sectionCells[(NSUInteger) section].xui_footerText;
        return [self.adapter localizedStringForKey:title value:title];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XUIBaseCell *cell = self.cellFactory.otherCells[(NSUInteger) indexPath.section][(NSUInteger) indexPath.row];
    NSString *cellClassName = NSStringFromClass([cell class]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    SEL cellActionSelector = NSSelectorFromString([NSString stringWithFormat:@"tableView:configure%@:", cellClassName]);
    if ([self respondsToSelector:cellActionSelector]) {
        [self performSelector:cellActionSelector withObject:self withObject:cell];
    }
#pragma clang diagnostic pop
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableView) {
        XUIBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        BOOL readonly = [cell.xui_readonly boolValue];
        if (readonly) {
            return;
        }
        NSString *cellClassName = NSStringFromClass([cell class]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        SEL cellActionSelector = NSSelectorFromString([NSString stringWithFormat:@"tableView:%@:", cellClassName]);
        if ([self respondsToSelector:cellActionSelector]) {
            [self performSelector:cellActionSelector withObject:self withObject:cell];
        }
#pragma clang diagnostic pop
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    XUIBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    BOOL readonly = [cell.xui_readonly boolValue];
    if (readonly) {
        return;
    }
    NSString *cellClassName = NSStringFromClass([cell class]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    SEL cellActionSelector = NSSelectorFromString([NSString stringWithFormat:@"tableView:accessory%@:", cellClassName]);
    if ([self respondsToSelector:cellActionSelector]) {
        [self performSelector:cellActionSelector withObject:self withObject:cell];
    }
#pragma clang diagnostic pop
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    XUIBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    BOOL readonly = [cell.xui_readonly boolValue];
    if (readonly) {
        return NO;
    }
    if (cell.canDelete) {
        if (cell.xui_value) {
            return YES;
        }
    }
    return NO;
}

XUI_START_IGNORE_PARTIAL
- (NSArray <UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weak_self = self;
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"Delete", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        __strong typeof(weak_self) self = weak_self;
                                        [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
                                    }];
    button.backgroundColor = self.theme.dangerColor;
    return @[button];
}
XUI_END_IGNORE_PARTIAL

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    XUIBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.canDelete) {
        cell.xui_value = nil;
        [self.adapter saveDefaultsFromCell:cell];
    }
    [cell setEditing:NO animated:YES];
}

#pragma mark - XUICellFactoryDelegate

- (void)cellFactoryDidFinishParsing:(XUICellFactory *)cellFactory {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)cellFactory:(XUICellFactory *)cellFactory didFailWithError:(NSError *)error {
    [self presentErrorAlertController:error];
}

- (void)presentErrorAlertController:(NSError *)error {
    __weak typeof(self) weak_self = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weak_self) self = weak_self;
        NSString *entryName = [self.path lastPathComponent];
        XUI_START_IGNORE_PARTIAL
        if (@available(iOS 8.0, *)) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"XUI Error", nil) message:[NSString stringWithFormat:NSLocalizedString(@"%@\n%@: %@", nil), entryName, error.localizedDescription, error.localizedFailureReason] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil]];
            [self.navigationController presentViewController:alertController animated:YES completion:nil];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"XUI Error", nil) message:[NSString stringWithFormat:NSLocalizedString(@"%@\n%@: %@", nil), entryName, error.localizedDescription, error.localizedFailureReason] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            [alertView show];
        }
        XUI_END_IGNORE_PARTIAL
    });
}

#pragma mark - Store

- (void)storeCellWhenNeeded:(XUIBaseCell *)cell {
    if (![self.cellsNeedStore containsObject:cell]) {
        [self.cellsNeedStore addObject:cell];
    }
    [self setNeedsStoreCells];
}

- (void)setNeedsStoreCells {
    if (self.shouldStoreCells == NO) {
        self.shouldStoreCells = YES;
    }
}

- (void)storeCellsIfNecessary {
    if (self.shouldStoreCells) {
        self.shouldStoreCells = NO;
        for (XUIBaseCell *cell in self.cellsNeedStore) {
            [self.adapter saveDefaultsFromCell:cell];
        }
    }
}

#pragma mark - UIControl Actions

- (void)closeButtonItemTapped:(id)sender {
    [self setEditing:NO animated:YES];
    [self dismissViewController:sender];
}

- (void)dismissViewController:(id)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:^() {
        
    }];
}

#pragma mark - Keyboard

- (void)keyboardDidAppear:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = [self defaultContentInsets];
    contentInsets.bottom = kbSize.height;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillDisappear:(NSNotification *)aNotification
{
    UITableView *tableView = self.tableView;
    UIEdgeInsets contentInsets = [self defaultContentInsets];
    contentInsets.bottom = XUI_PAD ? 0.0 : self.tabBarController.tabBar.bounds.size.height;
    tableView.contentInset = contentInsets;
    tableView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - Banner

- (UIEdgeInsets)defaultContentInsets {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    return insets;
}

#pragma mark - Memory

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"- [XUIListViewController dealloc]");
#endif
}

@end

