//
//  XUIMultipleOptionCell.m
//  XXTExplorer
//
//  Created by Zheng on 30/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIMultipleOptionCell.h"
#import "XUIPrivate.h"
#import "XUILogger.h"
#import "XUIOptionModel.h"

@implementation XUIMultipleOptionCell

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
      @"options": [NSArray class],
      @"maxCount": [NSNumber class],
      @"footerText": [NSString class],
      @"value": [NSArray class],
      @"popoverMode": [NSNumber class],
      };
}

+ (NSDictionary <NSString *, Class> *)optionValueTypes {
    return
    @{
      XUIOptionTitleKey: [NSString class],
      XUIOptionShortTitleKey: [NSString class],
      XUIOptionIconKey: [NSString class],
      };
}

- (void)setupCell {
    [super setupCell];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - Setters

- (void)setXui_value:(NSArray *)xui_value {
    _xui_value = xui_value;
    NSArray *optionValues = xui_value;
    NSString *shortTitle = [NSString stringWithFormat:[XUIStrings localizedStringForString:@"%lu Selected"], optionValues.count];
    self.detailTextLabel.text = shortTitle;
}

- (void)setXui_options:(NSArray<NSDictionary *> *)xui_options {
    for (NSDictionary *pair in xui_options) {
        for (NSString *pairKey in pair.allKeys) {
            Class pairClass = [[self class] optionValueTypes][pairKey];
            if (pairClass) {
                if (![pair[pairKey] isKindOfClass:pairClass]) {
                    return; // invalid option, ignore
                }
            }
        }
    }
    _xui_options = xui_options;
}

@end
