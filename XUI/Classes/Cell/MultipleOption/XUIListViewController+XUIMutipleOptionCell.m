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
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    if (linkListCell.xui_options)
    {
        XUIMultipleOptionViewController *optionViewController = [[XUIMultipleOptionViewController alloc] initWithCell:linkListCell];
        optionViewController.cellFactory.theme = self.cellFactory.theme;
        optionViewController.cellFactory.adapter = self.cellFactory.adapter;
        optionViewController.delegate = self;
        if (@available(iOS 8.0, *)) {
            BOOL popoverMode = [linkListCell.xui_popoverMode boolValue];
            if (popoverMode) {
                optionViewController.modalPresentationStyle = UIModalPresentationPopover;
                UIPopoverPresentationController *popController = optionViewController.popoverPresentationController;
                popController.sourceView = self.tableView;
                popController.sourceRect = [self.tableView rectForRowAtIndexPath:indexPath];
                popController.backgroundColor = self.theme.backgroundColor;
                popController.delegate = self;
                [self.navigationController presentViewController:optionViewController animated:YES completion:nil];
                return;
            }
        }
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
