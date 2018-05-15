//
//  XUIEditableListCell.m
//  XUI
//
//  Created by Zheng on 15/10/2017.
//

#import "XUIEditableListCell.h"
#import "XUIPrivate.h"

@implementation XUIEditableListCell

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
      @"maxCount": [NSNumber class],
      @"footerText": [NSString class],
      @"value": [NSArray class],
      @"validationRegex": [NSString class],
      };
}

+ (BOOL)testEntry:(NSDictionary *)cellEntry withError:(NSError **)error {
    BOOL superResult = [super testEntry:cellEntry withError:error];
    if (superResult) {
        NSString *checkType = kXUICellFactoryErrorDomain;
        NSString *regexString = cellEntry[@"validationRegex"];
        if (regexString) {
            NSError *regexError = nil;
            NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:regexString options:0 error:&regexError];
            if (!regex) {
                checkType = kXUICellFactoryErrorInvalidValueDomain;
                NSString *errorReason = [NSString stringWithFormat:[XUIStrings localizedStringForString:@"key \"%@\" (\"%@\") is invalid."], @"validationRegex", regexString];
                NSError *exceptionError = [NSError errorWithDomain:checkType code:400 userInfo:@{ NSLocalizedDescriptionKey: errorReason }];
                if (error) *error = exceptionError;
                return NO;
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
