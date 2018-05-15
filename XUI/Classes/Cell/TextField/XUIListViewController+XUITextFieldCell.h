//
//  XUIListViewController+XUITextFieldCell.h
//  Pods
//
//  Created by Zheng on 2018/5/15.
//

#import "XUIListViewController.h"
#import "XUITextFieldCell.h"

@interface XUIListViewController (XUITextFieldCell)

- (void)tableView:(UITableView *)tableView XUITextFieldCell:(UITableViewCell *)cell;

@end
