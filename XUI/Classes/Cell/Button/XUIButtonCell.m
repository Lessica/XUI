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

+ (BOOL)testValue:(id)value forKey:(NSString *)key error:(NSError **)error {
    if ([key isEqualToString:@"alignment"]) {
        if (NO == [@[@"Left", @"Right", @"Center", @"Natural", @"Justified"] containsObject:value])
        {
            NSString *errorReason
            = [NSString stringWithFormat:[XUIStrings localizedStringForString:@"key \"%@\" (\"%@\") is invalid."], @"alignment", value];
            NSError *exceptionError
            = [NSError errorWithDomain:kXUICellFactoryErrorUnknownEnumDomain code:400 userInfo:@{ NSLocalizedDescriptionKey: errorReason }];
            if (error) *error = exceptionError;
            return NO;
        }
    }
    return [super testValue:value forKey:key error:error];
}

- (void)setupCell {
    [super setupCell];
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

- (void)setInternalTheme:(XUITheme *)theme {
    [super setInternalTheme:theme];
    self.textLabel.textColor = theme.foregroundColor;
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
