//
//  XUIListViewController+XUIMutipleOptionCell.m
//  XXTExplorer
//
//  Created by Zheng Wu on 29/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIListViewController+XUIMutipleOptionCell.h"
#import "XUIPrivate.h"
#import "XUICellFactory.h"

@implementation XUIListViewController (XUIMutipleOptionCell)

- (void)tableView:(UITableView *)tableView XUIMultipleOptionCell:(UITableViewCell *)cell {
    XUIMultipleOptionCell *linkListCell = (XUIMultipleOptionCell *)cell;
    if (linkListCell.xui_options)
    {
        XUIMultipleOptionViewController *optionViewController = [[XUIMultipleOptionViewController alloc] initWithCell:linkListCell];
        optionViewController.adapter = self.adapter;
        optionViewController.delegate = self;
        optionViewController.title = linkListCell.xui_label;
        optionViewController.theme = self.theme;
        [self.navigationController pushViewController:optionViewController animated:YES];
    }
}

#pragma mark - XUIMultipleOptionViewControllerDelegate

- (void)multipleOptionViewController:(XUIMultipleOptionViewController *)controller didSelectOption:(NSArray <NSNumber *> *)optionIndexes {
    [self tableView:self.tableView configureXUIMultipleOptionCell:controller.cell];
    [self.adapter saveDefaultsFromCell:controller.cell];
}

- (void)tableView:(UITableView *)tableView configureXUIMultipleOptionCell:(XUIMultipleOptionCell *)cell {
    NSArray *optionValues = cell.xui_value;
    NSString *shortTitle = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"%lu Selected", nil, FRAMEWORK_BUNDLE, nil), optionValues.count];
    cell.detailTextLabel.text = shortTitle;
}

@end
