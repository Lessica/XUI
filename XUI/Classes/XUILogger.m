//
//  XUILogger.m
//  XXTExplorer
//
//  Created by Zheng on 30/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUILogger.h"

NSString * const kXUICellFactoryErrorDomain = @"com.xxtouch.xui";
NSString * const kXUICellFactoryErrorMissingEntryDomain = @"com.xxtouch.xui.missing-entry";
NSString * const kXUICellFactoryErrorInvalidTypeDomain = @"com.xxtouch.xui.invalid-type";
NSString * const kXUICellFactoryErrorEmptyWarningDomain = @"com.xxtouch.xui.empty-warning";
NSString * const kXUICellFactoryErrorUnknownEnumDomain = @"com.xxtouch.xui.unknown-enum";
NSString * const kXUICellFactoryErrorUndefinedKeyDomain = @"com.xxtouch.xui.undefined-key";
NSString * const kXUICellFactoryErrorSizeDismatchDomain = @"com.xxtouch.xui.size-dismatch";
NSString * const kXUICellFactoryErrorUnknownSelectorDomain = @"com.xxtouch.xui.unknown-selector";
NSString * const kXUICellFactoryErrorInvalidValueDomain = @"com.xxtouch.xui.invalid-value";

@implementation XUILogger

- (void)logMessage:(NSString *)message {
    NSLog(@"[XUILogger] %@", message);
}

@end
