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

+ (BOOL)testValue:(id)value forKey:(NSString *)key error:(NSError **)error {
    if ([key isEqualToString:@"validationRegex"]) {
        NSError *regexError = nil;
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:value options:0 error:&regexError];
        if (!regex)
        {
            NSString *errorReason
            = [NSString stringWithFormat:[XUIStrings localizedStringForString:@"key \"%@\" (\"%@\") is invalid."], @"validationRegex", value];
            NSError *exceptionError
            = [NSError errorWithDomain:kXUICellFactoryErrorInvalidValueDomain code:400 userInfo:@{ NSLocalizedDescriptionKey: errorReason }];
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
