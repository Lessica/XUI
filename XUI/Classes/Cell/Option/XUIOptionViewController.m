//
//  XUIOptionViewController.m
//  XXTExplorer
//
//  Created by Zheng on 17/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIOptionViewController.h"

#import "XUIPrivate.h"
#import "XUITheme.h"
#import "XUIOptionCell.h"
#import "XUIOptionModel.h"
#import "XUIBaseOptionCell.h"

@interface XUIOptionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation XUIOptionViewController {
    
}

- (instancetype)initWithCell:(XUIOptionCell *)cell {
    if (self = [super init]) {
        _cell = cell;
        id rawValue = cell.xui_value;
        if (rawValue) {
            NSUInteger rawIndex = [self.cell.xui_options indexOfObjectPassingTest:^BOOL(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                id value = obj[XUIOptionValueKey];
                if ([rawValue isEqual:value]) {
                    return YES;
                }
                return NO;
            }];
            if ((rawIndex) != NSNotFound) {
                _selectedIndex = rawIndex;
            }
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[XUIBaseOptionCell class] forCellReuseIdentifier:XUIBaseOptionCellReuseIdentifier];
    
    XUITheme *theme = self.theme;
    self.tableView.backgroundColor = theme.backgroundColor;
    self.tableView.separatorColor = theme.separatorColor;
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        UITableView *tableView = object;
        self.preferredContentSize = tableView.contentSize;
    }
}

- (BOOL)popoverMode {
    return self.modalPresentationStyle == UIModalPresentationPopover;
}

#pragma mark - UIView Getters

- (UITableView *)tableView {
    if (!_tableView) {
        UITableViewStyle tableViewStyle;
        if ([self popoverMode])
        {
            tableViewStyle = UITableViewStylePlain;
        }
        else
        {
            tableViewStyle = self.theme.tableViewStyle;
        }
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:tableViewStyle];
        if ([self popoverMode]) {
            tableView.bounces = NO;
        }
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.editing = NO;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cell.xui_options.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (0 == section) {
        return [self.adapter localizedStringForKey:self.cell.xui_footerText value:self.cell.xui_footerText];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        XUIBaseOptionCell *cell =
        [tableView dequeueReusableCellWithIdentifier:XUIBaseOptionCellReuseIdentifier];
        if (nil == cell)
        {
            cell = [[XUIBaseOptionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:XUIBaseOptionCellReuseIdentifier];
        }
        cell.adapter = self.adapter;
        NSDictionary *optionDictionary = self.cell.xui_options[(NSUInteger) indexPath.row];
        cell.xui_icon = optionDictionary[XUIOptionIconKey];
        cell.xui_label = optionDictionary[XUIOptionTitleKey];
        if (self.selectedIndex == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        [cell setTheme:self.theme];
        return cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        self.selectedIndex = indexPath.row;
        for (UITableViewCell *cell in tableView.visibleCells) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
        selectCell.accessoryType = UITableViewCellAccessoryCheckmark;
        id selectedValue = self.cell.xui_options[self.selectedIndex][XUIOptionValueKey];
        if (selectedValue) {
            self.cell.xui_value = selectedValue;
        }
        if (_delegate && [_delegate respondsToSelector:@selector(optionViewController:didSelectOption:)]) {
            [_delegate optionViewController:self didSelectOption:self.selectedIndex];
        }
    }
}

#pragma mark - Memory

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"- [XUIOptionViewController dealloc]");
#endif
}

@end
