//
//  XUIOrderedOptionViewController.m
//  XXTExplorer
//
//  Created by Zheng on 17/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIOrderedOptionViewController.h"

#import "XUIPrivate.h"
#import "XUITheme.h"
#import "XUIOptionModel.h"
#import "XUIBaseOptionCell.h"

@interface XUIOrderedOptionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *selectedIndexes;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *unselectedIndexes;

@end

@implementation XUIOrderedOptionViewController

- (instancetype)initWithCell:(XUIOrderedOptionCell *)cell {
    if (self = [super init]) {
        _cell = cell;
        NSMutableArray *validValues = [[NSMutableArray alloc] init];
        [cell.xui_options enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id value = obj[XUIOptionValueKey];
            if (value) {
                [validValues addObject:value];
            }
        }];
        NSMutableArray *unselectedIndexes = [[NSMutableArray alloc] initWithCapacity:validValues.count];
        for (NSUInteger unselectedIndex = 0; unselectedIndex < validValues.count; unselectedIndex++) {
            [unselectedIndexes addObject:@(unselectedIndex)];
        }
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
                    NSNumber *rawIndexObject = @(rawIndex);
                    [selectedIndexes addObject:rawIndexObject];
                    [unselectedIndexes removeObject:rawIndexObject];
                }
            }
            _selectedIndexes = selectedIndexes;
        } else {
            _selectedIndexes = [[NSMutableArray alloc] init];
        }
        _unselectedIndexes = unselectedIndexes;
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
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.editing = YES;
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
        return self.selectedIndexes.count;
    } else if (section == 1) {
        return self.unselectedIndexes.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont systemFontOfSize:14.0];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return NSLocalizedStringFromTableInBundle(@"Selected", nil, FRAMEWORK_BUNDLE, nil);
    }
    else if (1 == section) {
        return NSLocalizedStringFromTableInBundle(@"Others", nil, FRAMEWORK_BUNDLE, nil);
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (0 == section) {
        return [self.adapter localizedStringForKey:self.cell.xui_footerText value:self.cell.xui_footerText];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XUIBaseOptionCell *cell =
    [tableView dequeueReusableCellWithIdentifier:XUIBaseOptionCellReuseIdentifier];
    if (nil == cell)
    {
        cell = [[XUIBaseOptionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:XUIBaseOptionCellReuseIdentifier];
    }
    cell.adapter = self.adapter;
    [cell setTheme:self.theme];
    cell.showsReorderControl = YES;
    cell.tintColor = self.theme.tintColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0)
    {
        NSUInteger selectedIndex = [self.selectedIndexes[(NSUInteger) indexPath.row] unsignedIntegerValue];
        NSDictionary *optionDictionary = self.cell.xui_options[selectedIndex];
        cell.xui_icon = optionDictionary[XUIOptionIconKey];
        cell.xui_label = optionDictionary[XUIOptionTitleKey];
    }
    else if (indexPath.section == 1)
    {
        NSUInteger unselectedIndex = [self.unselectedIndexes[(NSUInteger) indexPath.row] unsignedIntegerValue];
        NSDictionary *optionDictionary = self.cell.xui_options[unselectedIndex];
        cell.xui_icon = optionDictionary[XUIOptionIconKey];
        cell.xui_label = optionDictionary[XUIOptionTitleKey];
    }
    else {
        cell.xui_label = nil;
        cell.xui_icon = nil;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (sourceIndexPath.section == 1 && proposedDestinationIndexPath.section == 0) {
        // Move In
        NSNumber *maxCountObject = self.cell.xui_maxCount;
        if (maxCountObject != nil) {
            NSUInteger maxCount = [maxCountObject unsignedIntegerValue];
            if (self.selectedIndexes.count >= maxCount) {
                return sourceIndexPath;
            }
        }
    } else if (sourceIndexPath.section == 0 && proposedDestinationIndexPath.section == 1) {
        // Move Out
        NSNumber *minCountOnbject = self.cell.xui_minCount;
        if (minCountOnbject != nil) {
            NSUInteger minCount = [minCountOnbject unsignedIntegerValue];
            if (self.selectedIndexes.count <= minCount) {
                return sourceIndexPath;
            }
        }
    }
    return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.section == 0 && destinationIndexPath.section == 0) {
        [self.selectedIndexes exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    } else if (sourceIndexPath.section == 1 && destinationIndexPath.section == 1) {
        [self.unselectedIndexes exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    } else if (sourceIndexPath.section == 0 && destinationIndexPath.section == 1) {
        [self.unselectedIndexes insertObject:self.selectedIndexes[sourceIndexPath.row] atIndex:destinationIndexPath.row];
        [self.selectedIndexes removeObjectAtIndex:sourceIndexPath.row];
    } else if (sourceIndexPath.section == 1 && destinationIndexPath.section == 0) {
        [self.selectedIndexes insertObject:self.unselectedIndexes[sourceIndexPath.row] atIndex:destinationIndexPath.row];
        [self.unselectedIndexes removeObjectAtIndex:sourceIndexPath.row];
    }
    NSMutableArray *selectedValues = [[NSMutableArray alloc] initWithCapacity:self.selectedIndexes.count];
    for (NSNumber *selectedIndex in self.selectedIndexes) {
        NSUInteger selectedIndexValue = [selectedIndex unsignedIntegerValue];
        id selectedValue = self.cell.xui_options[selectedIndexValue][XUIOptionValueKey];
        [selectedValues addObject:selectedValue];
    }
    self.cell.xui_value = [[NSArray alloc] initWithArray:selectedValues];
    if (_delegate && [_delegate respondsToSelector:@selector(orderedOptionViewController:didSelectOption:)]) {
        [_delegate orderedOptionViewController:self didSelectOption:self.selectedIndexes];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Memory

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"- [XUIOrderedOptionViewController dealloc]");
#endif
}

@end
