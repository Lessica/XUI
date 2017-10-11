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

+ (BOOL)xibBasedLayout {
    return NO;
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
     @"alignment": [NSString class],
     @"keyboard": [NSString class],
     @"autoCapitalization": [NSString class],
     @"autoCorrection": [NSString class],
     @"maxLength": [NSNumber class],
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
        {
            NSString *keyboardString = cellEntry[@"keyboard"];
            if (keyboardString) {
                NSArray <NSString *> *validKeyboard = @[ @"Default", @"ASCIICapable", @"NumbersAndPunctuation", @"URL", @"NumberPad", @"PhonePad", @"NamePhonePad", @"EmailAddress", @"DecimalPad", @"Alphabet" ];
                if (![validKeyboard containsObject:keyboardString]) {
                    superResult = NO;
                    checkType = kXUICellFactoryErrorUnknownEnumDomain;
                    @throw [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"key \"%@\" (\"%@\") is invalid.", nil, FRAMEWORK_BUNDLE, nil), @"keyboard", keyboardString];
                }
            }
        }
        {
            NSString *autoCapitalizationString = cellEntry[@"autoCapitalization"];
            if (autoCapitalizationString) {
                NSArray <NSString *> *validAutoCaps = @[ @"Sentences", @"Words", @"AllCharacters", @"None" ];
                if (![validAutoCaps containsObject:autoCapitalizationString]) {
                    superResult = NO;
                    checkType = kXUICellFactoryErrorUnknownEnumDomain;
                    @throw [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"key \"%@\" (\"%@\") is invalid.", nil, FRAMEWORK_BUNDLE, nil), @"autoCapitalization", autoCapitalizationString];
                }
            }
        }
        {
            NSString *autoCorrectionString = cellEntry[@"autoCorrection"];
            if (autoCorrectionString) {
                NSArray <NSString *> *validAutoCorrection = @[ @"Default", @"No", @"Yes" ];
                if (![validAutoCorrection containsObject:autoCorrectionString]) {
                    superResult = NO;
                    checkType = kXUICellFactoryErrorUnknownEnumDomain;
                    @throw [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"key \"%@\" (\"%@\") is invalid.", nil, FRAMEWORK_BUNDLE, nil), @"autoCorrection", autoCorrectionString];
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
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
