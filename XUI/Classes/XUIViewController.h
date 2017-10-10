//
// Created by Zheng on 26/07/2017.
// Copyright (c) 2017 Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XUIAdapter.h"

@class XUITheme, XUILogger;

@interface XUIViewController : UIViewController

@property (nonatomic, strong) id <XUIAdapter> adapter;
@property (nonatomic, strong) XUITheme *theme;
@property (nonatomic, strong) XUILogger *logger;

@property (nonatomic, copy, readonly) NSString *entryPath;
- (instancetype)initWithPath:(NSString *)path;

@end
