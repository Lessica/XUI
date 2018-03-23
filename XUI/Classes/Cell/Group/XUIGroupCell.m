//
// Created by Zheng on 28/07/2017.
// Copyright (c) 2017 Zheng. All rights reserved.
//

#import "XUIGroupCell.h"


@implementation XUIGroupCell

+ (BOOL)layoutNeedsTextLabel {
    return NO;
}

+ (BOOL)layoutNeedsImageView {
    return NO;
}

+ (BOOL)layoutRequiresDynamicRowHeight {
    return NO;
}

+ (NSDictionary <NSString *, Class> *)entryValueTypes {
    return
    @{
      @"footerText": [NSString class]
      };
}

@end
