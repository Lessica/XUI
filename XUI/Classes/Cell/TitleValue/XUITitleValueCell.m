//
//  XUITitleValueCell.m
//  XXTExplorer
//
//  Created by Zheng on 30/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUITitleValueCell.h"
#import "XUIPrivate.h"
#import "NSObject+XUIStringValue.h"

@interface XUITitleValueCell ()
@property (assign, nonatomic) BOOL shouldUpdateValue;

@end

@implementation XUITitleValueCell

@synthesize xui_value = _xui_value;

+ (BOOL)layoutNeedsTextLabel {
    return YES;
}

+ (BOOL)layoutNeedsImageView {
    return YES;
}

+ (BOOL)layoutRequiresDynamicRowHeight {
    return YES;
}

- (void)setupCell {
    [super setupCell];
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

- (void)setXui_value:(id)xui_value {
    _xui_value = xui_value;
    [self setNeedsUpdateValue];
    [self updateValueIfNeeded];
}

- (void)setXui_snippet:(NSString *)xui_snippet {
    _xui_snippet = xui_snippet;
    [self updateValueIfNeeded];
}

- (void)setNeedsUpdateValue {
    self.shouldUpdateValue = YES;
}

- (void)updateValueIfNeeded {
    if (self.shouldUpdateValue) {
        self.shouldUpdateValue = NO;
        self.detailTextLabel.text = [self.xui_value xui_stringValue];
        BOOL isBaseType = NO;
        if (!self.xui_value) {
            isBaseType = YES;
        }
        NSArray <Class> *baseTypes = [NSObject xui_baseTypes];
        for (Class baseType in baseTypes) {
            if ([self.xui_value isKindOfClass:baseType]) {
                isBaseType = YES;
            }
        }
        if (self.xui_snippet) {
            if (isBaseType) {
                self.accessoryType = UITableViewCellAccessoryDetailButton;
            } else {
                self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            }
            self.selectionStyle = UITableViewCellSelectionStyleDefault;
        } else {
            if (isBaseType) {
                self.accessoryType = UITableViewCellAccessoryNone;
            } else {
                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            self.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    [self setNeedsLayout];
}

- (BOOL)canDelete {
    return YES;
}

@end
