//
// Created by Zheng on 28/07/2017.
// Copyright (c) 2017 Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XUITheme.h"
#import "XUIAdapter.h"

extern NSString * XUIBaseCellReuseIdentifier;

@interface XUIBaseCell : UITableViewCell

@property (nonatomic, strong) NSString *xui_cell;
@property (nonatomic, strong) NSString *xui_label;
@property (nonatomic, strong) NSString *xui_defaults;
@property (nonatomic, strong) NSString *xui_key;
@property (nonatomic, strong) id xui_default;
@property (nonatomic, strong) NSString *xui_icon;
@property (nonatomic, strong) NSNumber *xui_readonly;
@property (nonatomic, strong) NSNumber *xui_height;
@property (nonatomic, strong) id xui_value;

@property (nonatomic, strong) id <XUIAdapter> adapter;

@property (nonatomic, assign) BOOL canDelete;

+ (BOOL)xibBasedLayout;
+ (BOOL)layoutNeedsTextLabel;
+ (BOOL)layoutNeedsImageView;
+ (BOOL)layoutRequiresDynamicRowHeight;
+ (BOOL)layoutUsesAutoResizing;
+ (NSDictionary <NSString *, Class> *)entryValueTypes;
+ (BOOL)testEntry:(NSDictionary *)cellEntry withError:(NSError **)error NS_REQUIRES_SUPER;

- (void)setupCell NS_REQUIRES_SUPER;
- (void)configureCellWithEntry:(NSDictionary *)entry NS_REQUIRES_SUPER;
- (void)setTheme:(XUITheme *)theme NS_REQUIRES_SUPER;

@end
