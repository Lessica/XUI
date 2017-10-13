//
//  XUIMultipleOptionViewController.m
//  XXTExplorer
//
//  Created by Zheng on 31/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIMultipleOptionViewController.h"

#import "XUIPrivate.h"
#import "XUITheme.h"
#import "XUIOptionModel.h"
#import "XUIBaseOptionCell.h"

@interface XUIMultipleOptionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *selectedIndexes;

@end

@implementation XUIMultipleOptionViewController

- (instancetype)initWithCell:(XUIMultipleOptionCell *)cell {
    if (self = [super init]) {
        _cell = cell;
        NSArray *rawValues = cell.xui_value;
        if (rawValues && [rawValues isKindOfClass:[NSArray class]]) {
            NSMutableArray <NSNumber *> *selectedIndexes = [[NSMutableArray alloc] initWithCapacity:rawValues.count];
            for (id rawValue in rawValues) {
                NSUInteger rawIndex = [cell.xui_options indexOfObjectPassingTest:^BOOL(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    id value = obj[XUIOptionValueKey];
                    if ([rawValue isEqual:value]) {
                        return YES;
                    }
                    return NO;
                }];
                if (rawIndex != NSNotFound) {
                    [selectedIndexes addObject:@(rawIndex)];
                }
            }
            _selectedIndexes = selectedIndexes;
        } else {
            _selectedIndexes = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UIView Getters

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
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
        [cell setTheme:self.theme];
        cell.adapter = self.adapter;
        NSDictionary *optionDictionary = self.cell.xui_options[(NSUInteger) indexPath.row];
        cell.xui_icon = optionDictionary[XUIOptionIconKey];
        cell.xui_label = optionDictionary[XUIOptionTitleKey];
        cell.tintColor = self.theme.tintColor;
        if ([self.selectedIndexes containsObject:@(indexPath.row)]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSNumber *selectedIndex = @(indexPath.row);
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([self.selectedIndexes containsObject:selectedIndex]) {
            [self.selectedIndexes removeObject:selectedIndex];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            NSNumber *maxCountObject = self.cell.xui_maxCount;
            if (maxCountObject != nil) {
                NSUInteger maxCount = [maxCountObject unsignedIntegerValue];
                if (self.selectedIndexes.count >= maxCount) {
                    return;
                }
            }
            [self.selectedIndexes addObject:selectedIndex];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        NSMutableArray *selectedValues = [[NSMutableArray alloc] initWithCapacity:self.selectedIndexes.count];
        for (NSNumber *selectedIndex in self.selectedIndexes) {
            NSUInteger selectedIndexValue = [selectedIndex unsignedIntegerValue];
            id selectedValue = self.cell.xui_options[selectedIndexValue][XUIOptionValueKey];
            [selectedValues addObject:selectedValue];
        }
        self.cell.xui_value = [[NSArray alloc] initWithArray:selectedValues];
        if (_delegate && [_delegate respondsToSelector:@selector(multipleOptionViewController:didSelectOption:)]) {
            [_delegate multipleOptionViewController:self didSelectOption:self.selectedIndexes];
        }
    }
}

#pragma mark - Memory

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"- [XUIMultipleOptionViewController dealloc]");
#endif
}

@end
