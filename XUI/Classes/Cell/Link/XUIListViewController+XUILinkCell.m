//
//  XUIListViewController+XUILinkCell.m
//  XXTExplorer
//
//  Created by Zheng Wu on 10/10/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIListViewController+XUILinkCell.h"
#import "XUILinkCell.h"

@implementation XUIListViewController (XUILinkCell)

- (void)tableView:(UITableView *)tableView XUILinkCell:(UITableViewCell *)cell {
    XUILinkCell *linkCell = (XUILinkCell *)cell;
    NSString *detailUrlString = linkCell.xui_url;
    NSURL *detailUrl = [NSURL URLWithString:detailUrlString];
    if ([detailUrl scheme])
    {
        UIApplication *sharedApplication = [UIApplication sharedApplication];
        if ([sharedApplication canOpenURL:detailUrl])
        {
            [sharedApplication openURL:detailUrl];
        }
        return;
    }
    NSString *absolutePath = nil;
    if ([detailUrlString isAbsolutePath]) {
        absolutePath = detailUrlString;
    } else {
        absolutePath = [self.bundle pathForResource:detailUrlString ofType:nil];
    }
    if (!absolutePath) {
        return;
    }
    UIViewController *detailController = [[[self class] alloc] initWithPath:absolutePath withBundlePath:[self.bundle bundlePath]];
    if (detailController) {
        detailController.title = linkCell.textLabel.text;
        [self.navigationController pushViewController:detailController animated:YES];
    }
}

@end
