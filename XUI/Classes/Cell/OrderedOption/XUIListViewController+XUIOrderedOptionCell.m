//
//  XUIListViewController+XUIOrderedOptionCell.m
//  XXTExplorer
//
//  Created by Zheng Wu on 29/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIListViewController+XUIOrderedOptionCell.h"
#import "XUIPrivate.h"
#import "XUIAdapter.h"
#import "XUICellFactory.h"

@implementation XUIListViewController (XUIOrderedOptionCell)

- (void)tableView:(UITableView *)tableView XUIOrderedOptionCell:(UITableViewCell *)cell {
    XUIOrderedOptionCell *linkListCell = (XUIOrderedOptionCell *)cell;
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    if (linkListCell.xui_options)
    {
        XUIOrderedOptionViewController *optionViewController = [[XUIOrderedOptionViewController alloc] initWithCell:linkListCell];
        optionViewController.cellFactory.theme = self.cellFactory.theme;
        optionViewController.cellFactory.adapter = self.cellFactory.adapter;
        optionViewController.delegate = self;
        if (XUI_SYSTEM_8) {
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

#pragma mark - XUIOrderedOptionViewControllerDelegate

- (void)orderedOptionViewController:(XUIOrderedOptionViewController *)controller didSelectOption:(NSArray<NSNumber *> *)optionIndexes {
    [self tableView:self.tableView configureXUIOrderedOptionCell:controller.cell];
    [self.adapter saveDefaultsFromCell:controller.cell];
}

- (void)tableView:(UITableView *)tableView configureXUIOrderedOptionCell:(XUIOrderedOptionCell *)cell {
    NSArray *optionValues = cell.xui_value;
    NSString *shortTitle = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"%lu Selected", nil, FRAMEWORK_BUNDLE, nil), optionValues.count];
    cell.detailTextLabel.text = shortTitle;
}

@end
