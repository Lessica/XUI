//
//  XUIListViewController+XUIOrderedOptionCell.m
//  XXTExplorer
//
//  Created by Zheng Wu on 29/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIListViewController+XUIOrderedOptionCell.h"

#import "XUIAdapter.h"
#import "XUICellFactory.h"

@implementation XUIListViewController (XUIOrderedOptionCell)

- (void)tableView:(UITableView *)tableView XUIOrderedOptionCell:(UITableViewCell *)cell {
    XUIOrderedOptionCell *linkListCell = (XUIOrderedOptionCell *)cell;
    if (linkListCell.xui_options)
    {
        XUIOrderedOptionViewController *optionViewController = [[XUIOrderedOptionViewController alloc] initWithCell:linkListCell];
        optionViewController.adapter = self.adapter;
        optionViewController.delegate = self;
        optionViewController.title = linkListCell.xui_label;
        optionViewController.theme = self.theme;
        [self.navigationController pushViewController:optionViewController animated:YES];
    }
}

#pragma mark - XUIOrderedOptionViewControllerDelegate

- (void)orderedOptionViewController:(XUIOrderedOptionViewController *)controller didSelectOption:(NSArray<NSNumber *> *)optionIndexes {
    [self tableView:self.tableView configureXUIOrderedOptionCell:controller.cell];
    [self.adapter saveDefaultsFromCell:controller.cell];
}

- (void)tableView:(UITableView *)tableView configureXUIOrderedOptionCell:(XUIOrderedOptionCell *)cell {
    NSArray *optionValues = cell.xui_value;
    NSString *shortTitle = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"%lu Selected", nil, [NSBundle bundleForClass:[self class]], nil), optionValues.count];
    cell.detailTextLabel.text = shortTitle;
}

@end
