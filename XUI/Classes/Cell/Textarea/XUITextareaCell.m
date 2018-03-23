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

+ (BOOL)testEntry:(NSDictionary *)cellEntry withError:(NSError **)error {
    BOOL superResult = [super testEntry:cellEntry withError:error];
    if (superResult) {
        NSString *checkType = kXUICellFactoryErrorDomain;
        {
            NSString *alignmentString = cellEntry[@"alignment"];
            if (alignmentString) {
                NSArray <NSString *> *validAlignment = @[ @"Left", @"Right", @"Center", @"Natural", @"Justified" ];
                if (![validAlignment containsObject:alignmentString]) {
                    checkType = kXUICellFactoryErrorUnknownEnumDomain;
                    NSString *errorReason = [NSString stringWithFormat:[XUIStrings localizedStringForString:@"key \"%@\" (\"%@\") is invalid."], @"alignment", alignmentString];
                    NSError *exceptionError = [NSError errorWithDomain:checkType code:400 userInfo:@{ NSLocalizedDescriptionKey: errorReason }];
                    if (error) *error = exceptionError;
                    return NO;
                }
            }
        }
        {
            NSString *keyboardString = cellEntry[@"keyboard"];
            if (keyboardString) {
                NSArray <NSString *> *validKeyboard = @[ @"Default", @"ASCIICapable", @"NumbersAndPunctuation", @"URL", @"NumberPad", @"PhonePad", @"NamePhonePad", @"EmailAddress", @"DecimalPad", @"Alphabet" ];
                if (![validKeyboard containsObject:keyboardString]) {
                    checkType = kXUICellFactoryErrorUnknownEnumDomain;
                    NSString *errorReason = [NSString stringWithFormat:[XUIStrings localizedStringForString:@"key \"%@\" (\"%@\") is invalid."], @"keyboard", keyboardString];
                    NSError *exceptionError = [NSError errorWithDomain:checkType code:400 userInfo:@{ NSLocalizedDescriptionKey: errorReason }];
                    if (error) *error = exceptionError;
                    return NO;
                }
            }
        }
        {
            NSString *autoCapitalizationString = cellEntry[@"autoCapitalization"];
            if (autoCapitalizationString) {
                NSArray <NSString *> *validAutoCaps = @[ @"Sentences", @"Words", @"AllCharacters", @"None" ];
                if (![validAutoCaps containsObject:autoCapitalizationString]) {
                    checkType = kXUICellFactoryErrorUnknownEnumDomain;
                    NSString *errorReason = [NSString stringWithFormat:[XUIStrings localizedStringForString:@"key \"%@\" (\"%@\") is invalid."], @"autoCapitalization", autoCapitalizationString];
                    NSError *exceptionError = [NSError errorWithDomain:checkType code:400 userInfo:@{ NSLocalizedDescriptionKey: errorReason }];
                    if (error) *error = exceptionError;
                    return NO;
                }
            }
        }
        {
            NSString *autoCorrectionString = cellEntry[@"autoCorrection"];
            if (autoCorrectionString) {
                NSArray <NSString *> *validAutoCorrection = @[ @"Default", @"No", @"Yes" ];
                if (![validAutoCorrection containsObject:autoCorrectionString]) {
                    checkType = kXUICellFactoryErrorUnknownEnumDomain;
                    NSString *errorReason = [NSString stringWithFormat:[XUIStrings localizedStringForString:@"key \"%@\" (\"%@\") is invalid."], @"autoCorrection", autoCorrectionString];
                    NSError *exceptionError = [NSError errorWithDomain:checkType code:400 userInfo:@{ NSLocalizedDescriptionKey: errorReason }];
                    if (error) *error = exceptionError;
                    return NO;
                }
            }
        }
    }
    return superResult;
}

- (void)setupCell {
    [super setupCell];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
