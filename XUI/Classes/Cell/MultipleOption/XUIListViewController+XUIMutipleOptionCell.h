//
//  XUIListViewController+XUIMutipleOptionCell.h
//  XXTExplorer
//
//  Created by Zheng Wu on 29/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIListViewController.h"
#import "XUIMultipleOptionCell.h"
#import "XUIMultipleOptionViewController.h"

@interface XUIListViewController (XUIMutipleOptionCell) <XUIMultipleOptionViewControllerDelegate>

- (void)tableView:(UITableView *)tableView XUIMultipleOptionCell:(UITableViewCell *)cell;

@end
