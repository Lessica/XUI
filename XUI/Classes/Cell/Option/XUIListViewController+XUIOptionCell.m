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
#import "XUIPrivate.h"

@implementation XUIListViewController (XUIOptionCell)

#pragma mark - XUIOptionViewControllerDelegate

- (void)optionViewController:(XUIOptionViewController *)controller didSelectOption:(NSInteger)optionIndex {
    XUIOptionCell *cell = controller.cell;
    [self.adapter saveDefaultsFromCell:cell];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
}

- (void)tableView:(UITableView *)tableView XUIOptionCell:(UITableViewCell *)cell {
    XUIOptionCell *linkListCell = (XUIOptionCell *)cell;
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    if (indexPath && linkListCell.xui_options)
    {
        XUIOptionViewController *optionViewController = [[XUIOptionViewController alloc] initWithCell:linkListCell];
        [optionViewController updateTheme:[(linkListCell.theme ? linkListCell.theme : self.theme) copy]];
        [optionViewController updateAdapter:self.adapter];
        [optionViewController updateLogger:self.logger];
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

@end
