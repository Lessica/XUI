//
//  XUIPrivate.h
//  XXTExplorer
//
//  Created by Zheng on 2017/7/21.
//  Copyright © 2017年 Zheng. All rights reserved.
//

#ifndef XUI_PRIVATE_h
#define XUI_PRIVATE_h

#import <Foundation/Foundation.h>

#define XUI_START_IGNORE_PARTIAL _Pragma("clang diagnostic push") _Pragma("clang diagnostic ignored \"-Wpartial-availability\"")
#define XUI_END_IGNORE_PARTIAL _Pragma("clang diagnostic pop")

#define XUI_SYSTEM_8 (NSFoundationVersionNumber >= 1140.11)
#define XUI_SYSTEM_8_2 (NSFoundationVersionNumber >= 1142.14)
#define XUI_SYSTEM_9 (NSFoundationVersionNumber >= 1240.1)

#define XUI_PAD ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone)
#define XUI_COLLAPSED \
XUI_START_IGNORE_PARTIAL \
(XUI_SYSTEM_8 && self.splitViewController && self.splitViewController.collapsed != YES) \
XUI_END_IGNORE_PARTIAL

#define FRAMEWORK_BUNDLE ([NSBundle bundleWithURL:[[[NSBundle bundleForClass:[self classForCoder]] resourceURL] URLByAppendingPathComponent:@"XUI.bundle"]])

static NSString * const XUINotificationEventValueChanged = @"XUINotificationEventValueChanged";

#endif /* XUI_PRIVATE_h */
