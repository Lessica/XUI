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
        optionViewController.title = linkListCell.xui_label;
        XUI_START_IGNORE_PARTIAL
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
        XUI_END_IGNORE_PARTIAL
        [self.navigationController pushViewController:optionViewController animated:YES];
    }
}

#pragma mark - XUIMultipleOptionViewControllerDelegate

- (void)multipleOptionViewController:(XUIMultipleOptionViewController *)controller didSelectOption:(NSArray <NSNumber *> *)optionIndexes {
    XUIMultipleOptionCell *cell = controller.cell;
    [self.adapter saveDefaultsFromCell:cell];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
}

@end
