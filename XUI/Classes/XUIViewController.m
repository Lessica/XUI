//
// Created by Zheng on 26/07/2017.
// Copyright (c) 2017 Zheng. All rights reserved.
//

#import "XUIViewController.h"

#import "XUIPrivate.h"
#import "XUITheme.h"
#import "XUILogger.h"
#import "XUICellFactory.h"

#import "UIColor+XUIDarkColor.h"
#import "UIViewController+XUIPreviousViewController.h"

@interface XUIViewController () <XUICellFactoryDelegate>

@property (nonatomic, strong) UIColor *outsideForegroundColor;
@property (nonatomic, strong) UIColor *outsideBackgroundColor;
@property (nonatomic, assign) BOOL fromXUIViewController;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation XUIViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.theme) {
        if ([self.theme isDarkMode]) {
            return UIStatusBarStyleLightContent;
        } else {
            return UIStatusBarStyleDefault;
        }
    } else {
        return [super preferredStatusBarStyle];
    }
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupXUI];
    }
    return self;
}

- (void)setupXUI {
    {
        _outsideForegroundColor = [UIColor blackColor];
        _outsideBackgroundColor = [UIColor whiteColor];
        
        XUICellFactory *cellFactory = [[XUICellFactory alloc] init];
        cellFactory.delegate = self;
        _cellFactory = cellFactory;
    }
}

- (UINavigationBar *)navigationBar {
    return self.navigationController.navigationBar;
}

#pragma mark - Life Cycle

- (void)loadView {
    UIImageView *view = [[UIImageView alloc] init];
    view.contentMode = UIViewContentModeScaleAspectFill;
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    view.frame = [UIScreen mainScreen].bounds;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.userInteractionEnabled = YES;
    self.view = view;
    _backgroundImageView = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    XUI_START_IGNORE_PARTIAL
    if ([self.navigationItem respondsToSelector:@selector(largeTitleDisplayMode)]) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
    XUI_END_IGNORE_PARTIAL
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    if (NO == [[self xui_previousViewController] isKindOfClass:[XUIViewController class]]) {
        self.outsideBackgroundColor = [self navigationBar].barTintColor;
        self.outsideForegroundColor = [self navigationBar].tintColor;
    } else {
        self.fromXUIViewController = YES;
    }
    [self renderNavigationBarTheme:NO];
    NSString *backgroundImagePath = self.theme.backgroundImagePath;
    if (backgroundImagePath)
    { // Background Image
        NSBundle *bundle = nil;
        if (self.adapter) {
            bundle = self.adapter.bundle;
        } else {
            bundle = [NSBundle mainBundle];
        }
        UIImage *backgroundImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:backgroundImagePath ofType:nil]];
        [self.backgroundImageView setImage:backgroundImage];
    }
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    if (parent == nil) {
        if (self.fromXUIViewController == NO) {
            [self renderNavigationBarTheme:YES];
        }
    }
    [super willMoveToParentViewController:parent];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    if (parent != nil) {
        
    }
    [super didMoveToParentViewController:parent];
}

#pragma mark - Navigation Bar Color

- (void)renderNavigationBarTheme:(BOOL)restore {
    if (XUI_COLLAPSED) return;
    UIColor *backgroundColor = self.outsideBackgroundColor;
    UIColor *foregroundColor = self.outsideForegroundColor;
    if (restore) {
       
    } else {
        if (self.theme) {
            if (self.theme.navigationTitleColor)
                foregroundColor = self.theme.navigationTitleColor;
            if (self.theme.navigationBarColor)
                backgroundColor = self.theme.navigationBarColor;
        }
    }
    { // title color
        [self.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : foregroundColor }];
    }
    { // bar color
        [self.navigationBar setBackgroundImage:[backgroundColor xui_image] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.shadowImage = nil;
        self.navigationBar.translucent = YES;
        self.navigationBar.tintColor = foregroundColor;
        self.navigationBar.barTintColor = backgroundColor;
    }
    { // item color
        self.navigationItem.leftBarButtonItem.tintColor = foregroundColor;
        self.navigationItem.rightBarButtonItem.tintColor = foregroundColor;
        for (UIBarButtonItem *item in self.navigationItem.leftBarButtonItems) {
            item.tintColor = foregroundColor;
        }
        for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
            item.tintColor = foregroundColor;
        }
        self.navigationController.navigationItem.leftBarButtonItem.tintColor = foregroundColor;
        self.navigationController.navigationItem.rightBarButtonItem.tintColor = foregroundColor;
        for (UIBarButtonItem *item in self.navigationController.navigationItem.leftBarButtonItems) {
            item.tintColor = foregroundColor;
        }
        for (UIBarButtonItem *item in self.navigationController.navigationItem.rightBarButtonItems) {
            item.tintColor = foregroundColor;
        }
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - Getters

- (XUITheme *)theme {
    return self.cellFactory.theme;
}

- (XUILogger *)logger {
    return self.cellFactory.logger;
}

- (id <XUIAdapter>)adapter {
    return self.cellFactory.adapter;
}

- (NSString *)path {
    return self.cellFactory.adapter.path;
}

- (NSBundle *)bundle {
    return self.cellFactory.adapter.bundle;
}

#pragma mark - XUICellFactoryDelegate

- (void)cellFactory:(XUICellFactory *)parser didFailWithError:(NSError *)error {
    
}

- (void)cellFactoryDidFinishParsing:(XUICellFactory *)parser {
    
}

#pragma mark - Memory

- (void)dealloc {
    
}

@end
