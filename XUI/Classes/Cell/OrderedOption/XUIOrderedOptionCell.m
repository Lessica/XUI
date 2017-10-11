//
//  XUIOrderedOptionCell.m
//  XXTExplorer
//
//  Created by Zheng on 30/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIOrderedOptionCell.h"
#import "XUIPrivate.h"
#import "XUILogger.h"
#import "XUIOptionModel.h"

@implementation XUIOrderedOptionCell

@synthesize xui_value = _xui_value;

+ (BOOL)xibBasedLayout {
    return YES;
}

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
      @"minCount": [NSNumber class],
      @"maxCount": [NSNumber class],
      @"footerText": [NSString class],
      @"value": [NSArray class]
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

+ (BOOL)testEntry:(NSDictionary *)cellEntry withError:(NSError **)error {
    BOOL superResult = [super testEntry:cellEntry withError:error];
    NSString *checkType = kXUICellFactoryErrorDomain;
    @try {
        NSArray *validOptions = cellEntry[@"options"];
        NSUInteger maxCount = [cellEntry[@"maxCount"] unsignedIntegerValue];
        NSUInteger minCount = [cellEntry[@"minCount"] unsignedIntegerValue];
        if (maxCount > validOptions.count || minCount > maxCount) {
            superResult = NO;
            checkType = kXUICellFactoryErrorInvalidValueDomain;
            @throw [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"the value \"%@\" of key \"%@\" is invalid.", nil, FRAMEWORK_BUNDLE, nil), cellEntry[@"maxCount"], @"maxCount"];
        }
    } @catch (NSString *exceptionReason) {
        superResult = NO;
        NSError *exceptionError = [NSError errorWithDomain:checkType code:400 userInfo:@{ NSLocalizedDescriptionKey: exceptionReason }];
        if (error) {
            *error = exceptionError;
        }
    } @finally {
        
    }
    return superResult;
}

- (void)setupCell {
    [super setupCell];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
