//
//  XUILinkCell.m
//  XXTExplorer
//
//  Created by Zheng on 30/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUILinkCell.h"
#import "NSObject+XUIStringValue.h"

@interface XUILinkCell ()
@property (assign, nonatomic) BOOL shouldUpdateValue;

@end

@implementation XUILinkCell

@synthesize xui_value = _xui_value;

+ (BOOL)layoutNeedsTextLabel {
    return YES;
}

+ (BOOL)layoutNeedsImageView {
    return YES;
}

+ (BOOL)layoutRequiresDynamicRowHeight {
    return NO;
}

+ (NSDictionary <NSString *, Class> *)entryValueTypes {
    return
    @{
      @"url": [NSString class]
      };
}

- (void)setupCell {
    [super setupCell];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setXui_url:(NSString *)xui_url {
    _xui_url = xui_url;
}

- (void)setXui_value:(id)xui_value {
    _xui_value = xui_value;
    [self setNeedsUpdateValue];
    [self updateValueIfNeeded];
}

- (void)setNeedsUpdateValue {
    self.shouldUpdateValue = YES;
}

- (void)updateValueIfNeeded {
    if (self.shouldUpdateValue) {
        self.shouldUpdateValue = NO;
        self.detailTextLabel.text = [self.xui_value xui_stringValue];
    }
    [self setNeedsLayout];
}

@end
