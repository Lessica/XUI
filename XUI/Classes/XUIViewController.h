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
@interface XUIViewController : UIViewController

#pragma mark - Shortcuts
@property (nonatomic, strong, readonly, nonnull) XUICellFactory *cellFactory;
@property (nonatomic, strong, readonly, nullable) XUITheme *theme; // shortcut for factory.theme
@property (nonatomic, strong, readonly, nullable) XUILogger *logger; // shortcut for factory.logger
@property (nonatomic, strong, readonly, nullable) id <XUIAdapter> adapter; // shortcut for factory.adapter
@property (nonatomic, strong, readonly, nullable) NSString *path; // shortcut for factory.adapter.path
@property (nonatomic, strong, readonly, nullable) NSBundle *bundle; // shortcut for factory.adapter.bundle


#pragma mark - Update Factory
- (void)updateAdapter:(id<XUIAdapter>)adapter;
- (void)updateLogger:(XUILogger *)logger;
- (void)updateTheme:(XUITheme *)theme;


#pragma mark - Navigaion Bar Transition
- (UIColor *)preferredNavigationBarColor;
- (UIColor *)preferredNavigationBarTintColor;

@end
