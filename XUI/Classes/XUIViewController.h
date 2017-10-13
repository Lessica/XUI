//
// Created by Zheng on 26/07/2017.
// Copyright (c) 2017 Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XUIAdapter.h"

@class XUITheme, XUILogger, XUICellFactory;

@interface XUIViewController : UIViewController

@property (nonatomic, strong, readonly, nonnull) XUICellFactory *cellFactory;

@property (nonatomic, strong, readonly, nullable) XUITheme *theme;
@property (nonatomic, strong, readonly, nullable) XUILogger *logger;
@property (nonatomic, strong, readonly, nullable) id <XUIAdapter> adapter;

@end
