//
//  XUIListViewController+XUIButtonCell.m
//  XXTExplorer
//
//  Created by Zheng Wu on 29/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIListViewController+XUIButtonCell.h"

#import "XUILogger.h"
#import "XUICellFactory.h"

@implementation XUIListViewController (XUIButtonCell)

- (void)tableView:(UITableView *)tableView XUIButtonCell:(UITableViewCell *)cell {
    XUIButtonCell *buttonCell = (XUIButtonCell *)cell;
    BOOL readonly = [buttonCell.xui_readonly boolValue];
    if (readonly == NO && buttonCell.xui_action) {
        NSString *cellAction = buttonCell.xui_action;
        if (cellAction) {
            NSString *selectorName = [NSString stringWithFormat:@"xui_%@", cellAction];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            SEL actionSelector = NSSelectorFromString(selectorName);
            if (actionSelector && [self respondsToSelector:actionSelector]) {
                id performObject = [self performSelector:actionSelector withObject:cell];
                buttonCell.xui_value = performObject;
                [self.adapter saveDefaultsFromCell:buttonCell];
            } else {
                if (actionSelector) {
                    [self.logger logMessage:XUIParserErrorUndknownSelector(NSStringFromSelector(actionSelector))];
                }
            }
#pragma clang diagnostic pop
        }
    }
}

@end
