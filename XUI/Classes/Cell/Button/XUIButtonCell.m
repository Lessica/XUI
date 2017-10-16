//
//  XUIButtonCell.m
//  XXTExplorer
//
//  Created by Zheng on 29/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIButtonCell.h"
#import "XUITheme.h"
#import "XUIPrivate.h"
#import "XUILogger.h"

void const * XUIButtonCellStorageKey = &XUIButtonCellStorageKey;
NSString * const XUIButtonCellReuseIdentifier = @"XUIButtonCellReuseIdentifier";

@interface XUIButtonCell ()

@end

@implementation XUIButtonCell

+ (BOOL)xibBasedLayout {
    return NO;
}

+ (BOOL)layoutNeedsTextLabel {
    return YES;
}

+ (BOOL)layoutNeedsImageView {
    return YES;
}

+ (NSDictionary <NSString *, Class> *)entryValueTypes {
    return
    @{
      @"action": [NSString class],
      @"args": [NSDictionary class],
      @"alignment": [NSString class],
      };
}

+ (BOOL)testEntry:(NSDictionary *)cellEntry withError:(NSError **)error {
    BOOL superResult = [super testEntry:cellEntry withError:error];
    NSString *checkType = kXUICellFactoryErrorDomain;
    @try {
        {
            NSString *alignmentString = cellEntry[@"alignment"];
            if (alignmentString) {
                NSArray <NSString *> *validAlignment = @[ @"Left", @"Right", @"Center", @"Natural", @"Justified" ];
                if (![validAlignment containsObject:alignmentString]) {
                    superResult = NO;
                    checkType = kXUICellFactoryErrorUnknownEnumDomain;
                    @throw [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"key \"%@\" (\"%@\") is invalid.", nil, FRAMEWORK_BUNDLE, nil), @"alignment", alignmentString];
                }
            }
        }
    } @catch (NSString *exceptionReason) {
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
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

- (void)setTheme:(XUITheme *)theme {
    [super setTheme:theme];
    self.textLabel.textColor = theme.tintColor;
}

- (void)setXui_alignment:(NSString *)xui_alignment {
    _xui_alignment = xui_alignment;
    if ([xui_alignment isEqualToString:@"Left"]) {
        self.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    else if ([xui_alignment isEqualToString:@"Center"]) {
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    else if ([xui_alignment isEqualToString:@"Right"]) {
        self.textLabel.textAlignment = NSTextAlignmentRight;
    }
    else if ([xui_alignment isEqualToString:@"Natural"]) {
        self.textLabel.textAlignment = NSTextAlignmentNatural;
    }
    else if ([xui_alignment isEqualToString:@"Justified"]) {
        self.textLabel.textAlignment = NSTextAlignmentJustified;
    }
    else {
        self.textLabel.textAlignment = NSTextAlignmentNatural;
    }
}

@end
