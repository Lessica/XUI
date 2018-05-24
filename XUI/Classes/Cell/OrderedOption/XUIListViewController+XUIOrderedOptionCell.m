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
        optionViewController.cellFactory.theme = linkListCell.theme ? linkListCell.theme : self.cellFactory.theme;
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

#pragma mark - XUIOrderedOptionViewControllerDelegate

- (void)orderedOptionViewController:(XUIOrderedOptionViewController *)controller didSelectOption:(NSArray<NSNumber *> *)optionIndexes {
    XUIOrderedOptionCell *cell = controller.cell;
    [self.adapter saveDefaultsFromCell:cell];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
}

@end
