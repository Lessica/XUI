//
//  XUIOptionCell.m
//  XXTExplorer
//
//  Created by Zheng on 30/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIOptionCell.h"

#import "XUIPrivate.h"
#import "XUILogger.h"
#import "XUIOptionModel.h"

@interface XUIOptionCell ()

@property (assign, nonatomic) BOOL shouldUpdateValue;

@end

@implementation XUIOptionCell

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
      @"footerText": [NSString class],
      @"popoverMode": [NSNumber class],
      @"useChildIcon": [NSNumber class],
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

- (void)configureCellWithEntry:(NSDictionary *)entry {
    NSMutableDictionary *mutableEntry = [entry mutableCopy];
    if ([entry[@"useChildIcon"] boolValue]) {
        [mutableEntry removeObjectForKey:XUIOptionIconKey];
    }
    
//    NSString *pairIcon = nil;
//    id value = entry[XUIOptionValueKey];
//    if (value) {
//        NSArray <NSDictionary *> *options = entry[@"options"];
//        for (NSDictionary *pair in options) {
//            id pairValue = pair[XUIOptionValueKey];
//            if ([pairValue isEqual:value]) {
//                pairIcon = pair[XUIOptionIconKey];
//                break;
//            }
//        }
//    }
//
//    if ([pairIcon isKindOfClass:[NSString class]]) {
//        mutableEntry[XUIOptionIconKey] = pairIcon;
//    }
    
    [super configureCellWithEntry:[mutableEntry copy]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateValueIfNeeded];
}

#pragma mark - Setters

- (void)setXui_value:(id)xui_value {
    _xui_value = xui_value;
    [self setNeedsUpdateValue];
}

- (void)setXui_options:(NSArray <NSDictionary *> *)xui_options {
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
    [self setNeedsUpdateValue];
}

#pragma mark - Value Reload

- (void)setNeedsUpdateValue {
    self.shouldUpdateValue = YES;
}

- (void)updateValueIfNeeded {
    if (self.shouldUpdateValue) {
        self.shouldUpdateValue = NO;
        
        NSUInteger optionIndex = 0;
        id rawValue = self.xui_value;
        NSArray <NSDictionary *> *rawOptions = self.xui_options;
        if (rawValue && rawOptions) {
            NSUInteger rawIndex = [rawOptions indexOfObjectPassingTest:^BOOL(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([rawValue isEqual:obj[XUIOptionValueKey]]) {
                    return YES;
                }
                return NO;
            }];
            if ((rawIndex) != NSNotFound) {
                optionIndex = rawIndex;
            }
        }
        if (optionIndex < rawOptions.count) {
            NSDictionary *optionDict = rawOptions[optionIndex];
            
            NSString *shortTitle = optionDict[XUIOptionShortTitleKey] ?: optionDict[XUIOptionTitleKey];
            self.detailTextLabel.text = [self.adapter localizedStringForKey:shortTitle value:shortTitle];
            
            if ([self.xui_useChildIcon boolValue]) {
                NSString *iconValue = optionDict[XUIOptionIconKey];
                self.xui_icon = iconValue;
            }
        }
    }
}

@end
