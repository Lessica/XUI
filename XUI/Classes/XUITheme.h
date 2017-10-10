//
//  XUITheme.h
//  XXTExplorer
//
//  Created by Zheng Wu on 14/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XUI_COLOR ([UIColor colorWithRed:52.f/255.f green:152.f/255.f blue:219.f/255.f alpha:1.f]) // rgb(52, 152, 219)
#define XUI_COLOR_DANGER ([UIColor colorWithRed:231.f/255.f green:76.f/255.f blue:60.f/255.f alpha:1.f]) // rgb(231, 76, 60)
#define XUI_COLOR_WARNING ([UIColor colorWithRed:254.f/255.f green:239.f/255.f blue:179.f/255.f alpha:1.f]) // rgb(254, 239, 179)
#define XUI_COLOR_SUCCESS ([UIColor colorWithRed:26.f/255.f green:188.f/255.f blue:134.f/255.f alpha:1.f]) // rgb(26, 188, 134)
#define XUI_COLOR_HIGHLIGHTED ([UIColor colorWithRed:0.22 green:0.29 blue:0.36 alpha:1.00])

@interface XUITheme : NSObject

@property (nonatomic, strong, readonly) UIColor *tintColor;
@property (nonatomic, strong, readonly) UIColor *dangerColor;
@property (nonatomic, strong, readonly) UIColor *warningColor;
@property (nonatomic, strong, readonly) UIColor *successColor;
@property (nonatomic, strong, readonly) UIColor *highlightColor;

@property (nonatomic, strong, readonly) UIColor *navigationBarColor;
@property (nonatomic, strong, readonly) UIColor *navigationTitleColor;

@property (nonatomic, strong, readonly) UIColor *labelColor;
@property (nonatomic, strong, readonly) UIColor *valueColor;

@property (nonatomic, assign, readonly, getter=isDarkMode) BOOL darkMode;

- (instancetype)initWithDictionary:(NSDictionary *)themeDictionary;

@end
