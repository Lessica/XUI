//
//  XUIListViewController.h
//  XXTExplorer
//
//  Created by Zheng on 17/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIViewController.h"

@class XUIBaseCell, XUICellFactory, XUIListHeaderView, XUIListFooterView;

@interface XUIListViewController : XUIViewController <UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate>

#pragma mark - Views

@property (nonatomic, strong, readonly) XUIListHeaderView *headerView;
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) XUIListFooterView *footerView;

#pragma mark - Update Factory

- (void)updateAdapter:(id<XUIAdapter>)adapter;
- (void)updateLogger:(XUILogger *)logger;
- (void)updateTheme:(XUITheme *)theme;

#pragma mark - Convenience Helper

/* These helper methods will try their best to find the top most view controller and present XUI from it. */
+ (void)presentFromTopViewControllerWithPath:(NSString *)path;
+ (void)presentFromTopViewControllerWithBundlePath:(NSString *)bundlePath;
+ (void)presentFromTopViewControllerWithPath:(NSString *)path withBundlePath:(NSString *)bundlePath;

#pragma mark - Convenience Initializers

+ (instancetype)XUIWithPath:(NSString *)path;
+ (instancetype)XUIWithBundlePath:(NSString *)bundlePath;
+ (instancetype)XUIWithPath:(NSString *)path withBundlePath:(NSString *)bundlePath;

#pragma mark - Initializers

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithPath:(NSString *)path NS_REQUIRES_SUPER; // will use main bundle
- (instancetype)initWithBundlePath:(NSString *)bundlePath NS_REQUIRES_SUPER;
- (instancetype)initWithPath:(NSString *)path withBundlePath:(NSString *)bundlePath NS_REQUIRES_SUPER;

#pragma mark - Storage

- (void)storeCellWhenNeeded:(XUIBaseCell *)cell;
- (void)setNeedsStoreCells;
- (void)storeCellsIfNecessary;

#pragma mark - Error popups

- (void)presentErrorAlertController:(NSError *)error;

#pragma mark - Dismissal

- (void)dismissViewController:(id)dismissViewController NS_REQUIRES_SUPER;

@end

