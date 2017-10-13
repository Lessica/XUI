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
#define XUI_COLOR_DISCLOSURE ([UIColor colorWithRed:199.f/255.f green:199.f/255.f blue:204.f/255.f alpha:1.f]) // rgb(199, 199, 204)

@interface XUITheme : NSObject

@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, strong) UIColor *dangerColor;
@property (nonatomic, strong) UIColor *warningColor;
@property (nonatomic, strong) UIColor *successColor;

@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *highlightedColor;

@property (nonatomic, strong) UIColor *navigationBarColor;
@property (nonatomic, strong) UIColor *navigationTitleColor;

@property (nonatomic, strong) UIColor *labelColor;
@property (nonatomic, strong) UIColor *valueColor;

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *disclosureIndicatorColor;


@property (nonatomic, assign, readonly, getter=isDarkMode) BOOL darkMode;

- (instancetype)initWithDictionary:(NSDictionary *)themeDictionary;

@end
