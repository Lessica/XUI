//
//  XUIEditableListViewController.m
//  XUI
//
//  Created by Zheng on 15/10/2017.
//

#import "XUIEditableListViewController.h"
#import "XUIEditableListCell.h"

#import "XUIPrivate.h"
#import "XUITheme.h"
#import "XUIOptionModel.h"
#import "XUIBaseOptionCell.h"

#import "XUIEditableListItemViewController.h"

@interface XUIEditableListViewController () <UITableViewDelegate, UITableViewDataSource, XUIEditableListItemViewControllerDelegate>

@property (nonatomic, assign) BOOL needsUpdate;

@property (nonatomic, strong) XUIBaseOptionCell *addCell;
@property (nonatomic, strong) XUIBaseOptionCell *deleteCell;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <NSString *> *mutableContentList;
@property (nonatomic, assign) NSUInteger editingIndex;

@property (nonatomic, strong) NSRegularExpression *validationRegex;
@property (nonatomic, strong) NSError *regexError;

@end

@implementation XUIEditableListViewController {
    BOOL _firstLoaded;
}

- (instancetype)initWithCell:(XUIEditableListCell *)cell {
    if (self = [super init]) {
        _cell = cell;
        _mutableContentList = [[NSMutableArray alloc] init];
        _editingIndex = UINT_MAX;
        _firstLoaded = NO;
        
        if (cell.xui_validationRegex.length > 0)
        {
            NSError *regexError = nil;
            NSRegularExpression *validationRegex
            = [[NSRegularExpression alloc] initWithPattern:cell.xui_validationRegex options:0 error:&regexError];
            
            _validationRegex = validationRegex;
            _regexError = regexError;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray <NSString *> *originalList = self.cell.xui_value;
    for (NSString *item in originalList) {
        if ([item isKindOfClass:[NSString class]]) {
            [self.mutableContentList addObject:item];
        }
    }
    
    [self.navigationItem setRightBarButtonItem:self.editButtonItem];
    
    [self.tableView registerClass:[XUIBaseOptionCell class] forCellReuseIdentifier:XUIBaseOptionCellReuseIdentifier];
    
    XUITheme *theme = self.theme;
    self.tableView.backgroundColor = theme.backgroundColor;
    self.tableView.separatorColor = theme.separatorColor;
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_firstLoaded == NO) {
        if (self.regexError)
        {
            [self presentErrorMessageAlertController:[NSString stringWithFormat:[XUIStrings localizedStringForString:@"Field \"%@\" cannot be parsed into a regular expression: %@"], @"validationRegex", [self.regexError localizedDescription]]];
        }
        _firstLoaded = YES;
    }
}

- (BOOL)isEditing {
    return [self.tableView isEditing];
}

- (void)setEditing:(BOOL)editing {
    [super setEditing:editing];
    [self.tableView setEditing:editing];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    [self updateSelectionCount];
}

#pragma mark - Getters

- (NSArray <NSString *> *)contentList {
    return [self.mutableContentList copy];
}

#pragma mark - UIView Getters

- (XUIBaseOptionCell *)addCell {
    if (!_addCell) {
        XUIBaseOptionCell *cell = [[XUIBaseOptionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                           reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.factory = self.cellFactory;
        cell.xui_label = [XUIStrings localizedStringForString:@"Add Item..."];
        [cell setInternalTheme:self.theme];
        _addCell = cell;
    }
    return _addCell;
}

- (XUIBaseOptionCell *)deleteCell {
    if (!_deleteCell) {
        XUIBaseOptionCell *cell = [[XUIBaseOptionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                           reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.factory = self.cellFactory;
        cell.xui_label = [XUIStrings localizedStringForString:@"Manage Items"];
        [cell setInternalTheme:self.theme];
        _deleteCell = cell;
    }
    return _deleteCell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.theme.tableViewStyle];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.editing = NO;
        tableView.allowsSelection = YES;
        tableView.allowsMultipleSelection = NO;
        tableView.allowsSelectionDuringEditing = YES;
        tableView.allowsMultipleSelectionDuringEditing = YES;
        XUI_START_IGNORE_PARTIAL
        if (XUI_SYSTEM_9) {
            tableView.cellLayoutMarginsFollowReadableWidth = NO;
        }
        XUI_END_IGNORE_PARTIAL
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return self.mutableContentList.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont systemFontOfSize:14.0];
    header.textLabel.textColor = self.theme.sectionHeaderTextColor;
    header.backgroundColor = self.theme.sectionHeaderBackgroundColor;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(nonnull UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    footer.textLabel.font = [UIFont systemFontOfSize:12.0];
    footer.textLabel.textColor = self.theme.sectionFooterTextColor;
    footer.backgroundColor = self.theme.sectionFooterBackgroundColor;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (1 == section) {
        return [XUIStrings localizedStringForString:@"Item List"];;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (1 == section) {
        return [self.adapter localizedStringForKey:self.cell.xui_footerText value:self.cell.xui_footerText];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return self.addCell;
        }
        else if (indexPath.row == 1) {
            return self.deleteCell;
        }
    } else if (indexPath.section == 1) {
        XUIBaseOptionCell *cell =
        [tableView dequeueReusableCellWithIdentifier:XUIBaseOptionCellReuseIdentifier];
        if (nil == cell)
        {
            cell = [[XUIBaseOptionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:XUIBaseOptionCellReuseIdentifier];
        }
        cell.factory = self.cellFactory;
        NSUInteger idx = indexPath.row;
        if (idx < self.mutableContentList.count) {
            cell.xui_label = self.mutableContentList[idx];
        }
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        cell.showsReorderControl = YES;
        [cell setInternalTheme:self.theme];
        return cell;
    }
    return [XUIBaseCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.row == 0) {
            // Add Item
            id maxCountValue = self.cell.xui_maxCount;
            if (maxCountValue) {
                NSUInteger currentCount = self.mutableContentList.count;
                NSUInteger maxCount = [maxCountValue unsignedIntegerValue];
                if (currentCount >= maxCount) {
                    NSString *errorMessage = [NSString stringWithFormat:[XUIStrings localizedStringForString:@"The number of item exceeded the \"maxCount\" limit (%lu)."], maxCount];
                    [self presentErrorMessageAlertController:errorMessage];
                    return;
                }
            }
            [self presentItemViewControllerAtIndexPath:indexPath withItemContent:nil];
            return;
        } else if (indexPath.row == 1) {
            // Manage Items
            NSArray <NSIndexPath *> *selectedIndexPathes = [self.tableView indexPathsForSelectedRows];
            if (tableView.isEditing && selectedIndexPathes.count > 0) {
                NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
                for (NSIndexPath *indexPath in selectedIndexPathes) {
                    [indexSet addIndex:indexPath.row];
                }
                [self.mutableContentList removeObjectsAtIndexes:[indexSet copy]];
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:selectedIndexPathes withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView endUpdates];
                [self updateSelectionCount];
                [self notifyContentListUpdate];
            } else {
                [self setEditing:![self.tableView isEditing] animated:YES];
            }
            return;
        }
        return;
    }
    else if (indexPath.section == 1) {
        if (!tableView.isEditing) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        } else {
            [self updateSelectionCount];
        }
        return;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self updateSelectionCount];
}

- (void)updateSelectionCount {
    NSString *deleteLabel = nil;
    NSUInteger selectedCount = [self.tableView indexPathsForSelectedRows].count;
    if (self.tableView.isEditing && selectedCount > 0) {
        if (selectedCount == 1) {
            deleteLabel = [NSString stringWithFormat:[XUIStrings localizedStringForString:@"Delete selected %lu item"], selectedCount];
        } else {
            deleteLabel = [NSString stringWithFormat:[XUIStrings localizedStringForString:@"Delete selected %lu items"], selectedCount];
        }
    } else {
        deleteLabel = [XUIStrings localizedStringForString:@"Manage Items"];
    }
    self.deleteCell.xui_label = deleteLabel;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return YES;
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 1) {
            [self.mutableContentList removeObjectAtIndex:indexPath.row];
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView endUpdates];
            [self updateSelectionCount];
            [self notifyContentListUpdate];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return YES;
    }
    return NO;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (sourceIndexPath.section == 1 && proposedDestinationIndexPath.section == 1) {
        return proposedDestinationIndexPath;
    }
    return sourceIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.section == 1 && destinationIndexPath.section == 1) {
        [self.mutableContentList exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
        [self notifyContentListUpdate];
    }
}

XUI_START_IGNORE_PARTIAL
- (NSArray <UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        __weak typeof(self) weak_self = self;
        UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:[XUIStrings localizedStringForString:@"Delete"] handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                        {
                                            __strong typeof(weak_self) self = weak_self;
                                            [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
                                        }];
        button.backgroundColor = self.theme.dangerColor;
        return @[button];
    }
    return @[];
}
XUI_END_IGNORE_PARTIAL

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        XUIBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self presentItemViewControllerAtIndexPath:indexPath withItemContent:cell.xui_label];
    }
}

#pragma mark - Item

- (void)presentItemViewControllerAtIndexPath:(NSIndexPath *)indexPath withItemContent:(NSString *)content {
    if (indexPath.section == 1) {
        self.editingIndex = indexPath.row;
    } else {
        self.editingIndex = UINT_MAX;
    }
    XUIEditableListItemViewController *itemViewController = [[XUIEditableListItemViewController alloc] initWithContent:content];
    itemViewController.cellFactory.theme = self.cellFactory.theme;
    itemViewController.cellFactory.adapter = self.cellFactory.adapter;
    itemViewController.validationRegex = self.validationRegex;
    itemViewController.footerText = [self.adapter localizedStringForKey:self.cell.xui_itemFooterText value:self.cell.xui_itemFooterText];
    itemViewController.delegate = self;
    [self.navigationController pushViewController:itemViewController animated:YES];
}

#pragma mark - XUIEditableListItemViewControllerDelegate

- (void)editableListItemViewController:(XUIEditableListItemViewController *)controller contentUpdated:(NSString *)content {
    if (controller.isAddMode)
    {
        [self.mutableContentList insertObject:content atIndex:0];
    } else {
        if (self.editingIndex < self.mutableContentList.count) {
            // Update Value
            [self.mutableContentList replaceObjectAtIndex:self.editingIndex withObject:content];
        }
    }
    [self.navigationController popToViewController:self animated:YES];
    [self setNeedsUpdate];
    [self notifyContentListUpdate];
}

- (void)setNeedsUpdate {
    self.needsUpdate = YES;
}

- (void)updateIfNeeded {
    if (self.needsUpdate) {
        self.needsUpdate = NO;
        [self.tableView reloadData];
        [self updateSelectionCount];
    }
}

#pragma mark - Update

- (void)notifyContentListUpdate {
    self.cell.xui_value = self.contentList;
    if ([_delegate respondsToSelector:@selector(editableListViewControllerContentListChanged:)]) {
        [_delegate editableListViewControllerContentListChanged:self];
    }
}

#pragma mark - Alert

- (void)presentErrorMessageAlertController:(NSString *)errorMessage {
    __weak typeof(self) weak_self = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weak_self) self = weak_self;
        XUI_START_IGNORE_PARTIAL
        if (XUI_SYSTEM_8) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[XUIStrings localizedStringForString:@"XUI Error"] message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:[XUIStrings localizedStringForString:@"OK"] style:UIAlertActionStyleCancel handler:nil]];
            [self.navigationController presentViewController:alertController animated:YES completion:nil];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[XUIStrings localizedStringForString:@"XUI Error"] message:errorMessage delegate:nil cancelButtonTitle:[XUIStrings localizedStringForString:@"OK"] otherButtonTitles:nil];
            [alertView show];
        }
        XUI_END_IGNORE_PARTIAL
    });
}

#pragma mark - Memory

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"- [XUIEditableListViewController dealloc]");
#endif
}

@end
