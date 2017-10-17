//
//  XUIListViewController+XUIEditableListCell.m
//  XUI
//
//  Created by Zheng on 15/10/2017.
//

#import "XUIListViewController+XUIEditableListCell.h"
#import "XUIEditableListViewController.h"
#import "XUIEditableListCell.h"

@implementation XUIListViewController (XUIEditableListCell)

- (void)tableView:(UITableView *)tableView XUIEditableListCell:(UITableViewCell *)cell {
    XUIEditableListCell *listCell = (XUIEditableListCell *)cell;
    XUIEditableListViewController *optionViewController = [[XUIEditableListViewController alloc] initWithCell:listCell];
    optionViewController.cellFactory.theme = self.cellFactory.theme;
    optionViewController.cellFactory.adapter = self.cellFactory.adapter;
    optionViewController.delegate = self;
    optionViewController.title = listCell.xui_label;
    [self.navigationController pushViewController:optionViewController animated:YES];
}

#pragma mark - XUIEditableListViewControllerDelegate

- (void)editableListViewControllerContentListChanged:(XUIEditableListViewController *)controller {
    [self tableView:self.tableView configureXUIEditableListCell:controller.cell];
    [self.adapter saveDefaultsFromCell:controller.cell];
}

- (void)tableView:(UITableView *)tableView configureXUIEditableListCell:(XUIEditableListCell *)cell {
    NSArray <NSString *> *listValues = cell.xui_value;
    NSUInteger count = listValues.count;
    NSString *shortTitle = nil;
    if (count == 0) {
        shortTitle = NSLocalizedStringFromTableInBundle(@"No Item", nil, FRAMEWORK_BUNDLE, nil);
    } else if (count <= 1) {
        shortTitle = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"%lu Item", nil, FRAMEWORK_BUNDLE, nil), (unsigned long)count];
    } else {
        shortTitle = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"%lu Items", nil, FRAMEWORK_BUNDLE, nil), (unsigned long)count];
    }
    cell.detailTextLabel.text = shortTitle;
}

@end
