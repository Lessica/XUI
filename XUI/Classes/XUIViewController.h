//
// Created by Zheng on 26/07/2017.
// Copyright (c) 2017 Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XUIAdapter.h"

@class XUITheme, XUILogger, XUICellFactory;


// ----
// !!! Do not use this class directly !!!
// ----
@interface XUIViewController : UIViewController <UIScrollViewDelegate>

#pragma mark - Shortcuts
@property (nonatomic, strong, readonly) XUICellFactory *cellFactory;
@property (nonatomic, strong, readonly) XUITheme *theme; // shortcut for factory.theme
@property (nonatomic, strong, readonly) XUILogger *logger; // shortcut for factory.logger
@property (nonatomic, strong, readonly) id <XUIAdapter> adapter; // shortcut for factory.adapter
@property (nonatomic, strong, readonly) NSString *path; // shortcut for factory.adapter.path
@property (nonatomic, strong, readonly) NSBundle *bundle; // shortcut for factory.adapter.bundle


#pragma mark - Update Factory
- (void)updateAdapter:(id<XUIAdapter>)adapter;
- (void)updateLogger:(XUILogger *)logger;
- (void)updateTheme:(XUITheme *)theme;


#pragma mark - Navigaion Bar Transition
- (UIColor *)preferredNavigationBarColor;
- (UIColor *)preferredNavigationBarTintColor;

@end
