//
//  XUIListViewController+XUIButtonCell.h
//  XXTExplorer
//
//  Created by Zheng Wu on 29/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIListViewController.h"
#import "XUIButtonCell.h"

@interface XUIListViewController (XUIButtonCell)

- (void)tableView:(UITableView *)tableView XUIButtonCell:(UITableViewCell *)cell;

@end
