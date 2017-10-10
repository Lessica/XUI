//
//  XUIListViewController+XUIOptionCell.m
//  XXTExplorer
//
//  Created by Zheng Wu on 29/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIListViewController+XUIOptionCell.h"

#import "XUICellFactory.h"
#import "XUIOptionModel.h"
#import "XUIOptionViewController.h"

@implementation XUIListViewController (XUIOptionCell)

#pragma mark - XUIOptionViewControllerDelegate

- (void)optionViewController:(XUIOptionViewController *)controller didSelectOption:(NSInteger)optionIndex {
    [self tableView:self.tableView configureXUIOptionCell:controller.cell];
    [self.adapter saveDefaultsFromCell:controller.cell];
}

- (void)tableView:(UITableView *)tableView XUIOptionCell:(UITableViewCell *)cell {
    XUIOptionCell *linkListCell = (XUIOptionCell *)cell;
    if (linkListCell.xui_options)
    {
        XUIOptionViewController *optionViewController = [[XUIOptionViewController alloc] initWithCell:linkListCell];
        optionViewController.adapter = self.adapter;
        optionViewController.delegate = self;
        optionViewController.title = linkListCell.xui_label;
        optionViewController.theme = self.theme;
        [self.navigationController pushViewController:optionViewController animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView configureXUIOptionCell:(XUIOptionCell *)cell {
    NSUInteger optionIndex = 0;
    id rawValue = cell.xui_value;
    if (rawValue) {
        NSUInteger rawIndex = [cell.xui_options indexOfObjectPassingTest:^BOOL(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([rawValue isEqual:obj[XUIOptionValueKey]]) {
                return YES;
            }
            return NO;
        }];
        if ((rawIndex) != NSNotFound) {
            optionIndex = rawIndex;
        }
    }
    if (optionIndex < cell.xui_options.count) {
        NSString *shortTitle = cell.xui_options[optionIndex][XUIOptionShortTitleKey];
        cell.detailTextLabel.text = shortTitle;
    }
}

@end
