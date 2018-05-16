//
//  XUITextareaCell.m
//  XXTExplorer
//
//  Created by Zheng on 10/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUITextareaCell.h"
#import "XUIPrivate.h"
#import "XUILogger.h"

@implementation XUITextareaCell

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
     @"alignment": [NSString class],
     @"keyboard": [NSString class],
     @"autoCapitalization": [NSString class],
     @"autoCorrection": [NSString class],
     @"maxLength": [NSNumber class],
      };
}

+ (BOOL)testValue:(id)value forKey:(NSString *)key error:(NSError **)error {
    if ([key isEqualToString:@"alignment"]) {
        if (NO == [@[ @"Left", @"Right", @"Center", @"Natural", @"Justified" ] containsObject:value]) {
            NSString *errorReason
            = [NSString stringWithFormat:[XUIStrings localizedStringForString:@"key \"%@\" (\"%@\") is invalid."], @"alignment", value];
            NSError *exceptionError
            = [NSError errorWithDomain:kXUICellFactoryErrorUnknownEnumDomain code:400 userInfo:@{ NSLocalizedDescriptionKey: errorReason }];
            if (error) *error = exceptionError;
            return NO;
        }
    }
    else if ([key isEqualToString:@"keyboard"]) {
        if (NO == [@[ @"Default", @"ASCIICapable", @"NumbersAndPunctuation", @"URL", @"NumberPad", @"PhonePad", @"NamePhonePad", @"EmailAddress", @"DecimalPad", @"Alphabet" ] containsObject:value]) {
            NSString *errorReason
            = [NSString stringWithFormat:[XUIStrings localizedStringForString:@"key \"%@\" (\"%@\") is invalid."], @"keyboard", value];
            NSError *exceptionError
            = [NSError errorWithDomain:kXUICellFactoryErrorUnknownEnumDomain code:400 userInfo:@{ NSLocalizedDescriptionKey: errorReason }];
            if (error) *error = exceptionError;
            return NO;
        }
    }
    else if ([key isEqualToString:@"autoCapitalization"]) {
        if (NO == [@[ @"Sentences", @"Words", @"AllCharacters", @"None" ] containsObject:value])
        {
            NSString *errorReason
            = [NSString stringWithFormat:[XUIStrings localizedStringForString:@"key \"%@\" (\"%@\") is invalid."], @"autoCapitalization", value];
            NSError *exceptionError
            = [NSError errorWithDomain:kXUICellFactoryErrorUnknownEnumDomain code:400 userInfo:@{ NSLocalizedDescriptionKey: errorReason }];
            if (error) *error = exceptionError;
            return NO;
        }
    }
    else if ([key isEqualToString:@"autoCorrection"]) {
        if (NO == [@[ @"Default", @"No", @"Yes" ] containsObject:value])
        {
            NSString *errorReason
            = [NSString stringWithFormat:[XUIStrings localizedStringForString:@"key \"%@\" (\"%@\") is invalid."], @"autoCorrection", value];
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
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
