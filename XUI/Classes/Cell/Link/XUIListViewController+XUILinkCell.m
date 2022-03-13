//
//  XUIListViewController+XUILinkCell.m
//  XXTExplorer
//
//  Created by Zheng Wu on 10/10/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIListViewController+XUILinkCell.h"
#import "XUILinkCell.h"
#import "XUICellFactory.h"
#import <SafariServices/SafariServices.h>

@implementation XUIListViewController (XUILinkCell)

- (void)tableView:(UITableView *)tableView XUILinkCell:(UITableViewCell *)cell {
    XUILinkCell *linkCell = (XUILinkCell *)cell;
    NSString *detailUrlString = linkCell.xui_url;
    NSURL *detailUrl = [NSURL URLWithString:detailUrlString];
    NSString *detailScheme = [[detailUrl scheme] lowercaseString];
    if (detailScheme)
    {
        BOOL hasSafariServices = NO;
        if (@available(iOS 9.0, *)) {
            hasSafariServices = YES;
        }
        if (!hasSafariServices ||
            [linkCell.xui_external boolValue] ||
            (![detailScheme isEqualToString:@"http"] && ![detailScheme isEqualToString:@"https"])
            ) {
            UIApplication *sharedApplication = [UIApplication sharedApplication];
            if ([sharedApplication canOpenURL:detailUrl])
            {
                [sharedApplication openURL:detailUrl];
            }
        } else {
            if (@available(iOS 9.0, *)) {
                SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:detailUrl];
                [self presentViewController:safariVC animated:YES completion:nil];
            }
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
    typeof(self) detailController = [[[self class] alloc] initWithPath:absolutePath withBundlePath:[self.bundle bundlePath]];
    if (detailController) {
        detailController.title = linkCell.textLabel.text;
        [detailController updateTheme:[self.theme copy]];
        [detailController updateLogger:self.logger];
        [self.navigationController pushViewController:detailController animated:YES];
    }
}

@end
