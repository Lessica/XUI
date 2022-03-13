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

@interface XUIViewController () <XUICellFactoryDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, assign) BOOL shouldRenderBackgroundImage;

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
    if (@available(iOS 13.0, *)) {
        view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        view.backgroundColor = [UIColor whiteColor];
    }
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
    
    [self setNeedsRenderBackgroundImage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self renderBackgroundImageIfNeeded];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    if (parent == nil) {
        
    } else {
        [self setNeedsRenderBackgroundImage];
    }
    [super willMoveToParentViewController:parent];
}

#pragma mark - Navigation Bar Color

- (UIColor *)preferredNavigationBarColor {
    return self.theme.navigationBarColor;
}

- (UIColor *)preferredNavigationBarTintColor {
    return self.theme.navigationTitleColor;
}

- (void)renderBackgroundImageIfNeeded {
    if (!self.shouldRenderBackgroundImage) return;
    self.shouldRenderBackgroundImage = NO;
    
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
}

- (void)setNeedsRenderBackgroundImage {
    self.shouldRenderBackgroundImage = YES;
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

#pragma mark - Setters

- (void)updateAdapter:(id<XUIAdapter>)adapter {
    [self.cellFactory setAdapter:adapter];
    if ([self isViewLoaded]) {
#ifdef DEBUG
        NSLog(@"-[XUIListViewController setAdapter:] cannot be called after view is loaded.");
#endif
    }
}

- (void)updateLogger:(XUILogger *)logger {
    [self.cellFactory setLogger:logger];
    if ([self isViewLoaded]) {
#ifdef DEBUG
        NSLog(@"-[XUIListViewController setLogger:] cannot be called after view is loaded.");
#endif
    }
}

- (void)updateTheme:(XUITheme *)theme {
    [self.cellFactory setTheme:theme];
    if ([self isViewLoaded]) {
#ifdef DEBUG
        NSLog(@"-[XUIListViewController setTheme:] cannot be called after view is loaded.");
#endif
    }
}

#pragma mark - XUICellFactoryDelegate

- (void)cellFactory:(XUICellFactory *)parser didFailWithError:(NSError *)error {
    
}

- (void)cellFactoryDidFinishParsing:(XUICellFactory *)parser {
    
}

#pragma mark - Memory

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"- [%@ dealloc]", NSStringFromClass([self class]));
#endif
}

@end
