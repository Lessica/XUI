//
//  XUITheme.m
//  XXTExplorer
//
//  Created by Zheng Wu on 14/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUITheme.h"
#import "UIColor+XUIDarkColor.h"

#define XUI_COLOR ([UIColor colorWithRed:52.f/255.f green:152.f/255.f blue:219.f/255.f alpha:1.f]) // rgb(52, 152, 219)
#define XUI_COLOR_DANGER ([UIColor colorWithRed:231.f/255.f green:76.f/255.f blue:60.f/255.f alpha:1.f]) // rgb(231, 76, 60)
#define XUI_COLOR_WARNING ([UIColor colorWithRed:254.f/255.f green:239.f/255.f blue:179.f/255.f alpha:1.f]) // rgb(254, 239, 179)
#define XUI_COLOR_SUCCESS ([UIColor colorWithRed:26.f/255.f green:188.f/255.f blue:134.f/255.f alpha:1.f]) // rgb(26, 188, 134)
#define XUI_COLOR_HIGHLIGHTED ([UIColor colorWithRed:0.22 green:0.29 blue:0.36 alpha:1.00])
#define XUI_COLOR_DISCLOSURE ([UIColor colorWithRed:199.f/255.f green:199.f/255.f blue:204.f/255.f alpha:1.f]) // rgb(199, 199, 204)

@implementation XUITheme

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)themeDictionary {
    self = [super init];
    if (self) {
        [self setup];
        
        if (themeDictionary[@"tintColor"])
            _tintColor = [UIColor xui_colorWithHex:themeDictionary[@"tintColor"]];
        
        if (themeDictionary[@"dangerColor"])
            _dangerColor = [UIColor xui_colorWithHex:themeDictionary[@"dangerColor"]];
        if (themeDictionary[@"warningColor"])
            _warningColor = [UIColor xui_colorWithHex:themeDictionary[@"warningColor"]];
        if (themeDictionary[@"successColor"])
            _successColor = [UIColor xui_colorWithHex:themeDictionary[@"successColor"]];
        
        if (themeDictionary[@"selectedColor"])
            _selectedColor = [UIColor xui_colorWithHex:themeDictionary[@"selectedColor"]];
        if (themeDictionary[@"highlightedColor"])
            _highlightedColor = [UIColor xui_colorWithHex:themeDictionary[@"highlightedColor"]];
        
        if (themeDictionary[@"navigationBarColor"])
            _navigationBarColor = [UIColor xui_colorWithHex:themeDictionary[@"navigationBarColor"]];
        if (themeDictionary[@"navigationTitleColor"])
            _navigationTitleColor = [UIColor xui_colorWithHex:themeDictionary[@"navigationTitleColor"]];
        
        if (themeDictionary[@"labelColor"])
            _labelColor = [UIColor xui_colorWithHex:themeDictionary[@"labelColor"]];
        if (themeDictionary[@"valueColor"])
            _valueColor = [UIColor xui_colorWithHex:themeDictionary[@"valueColor"]];
        
        if (themeDictionary[@"backgroundColor"])
            _backgroundColor = [UIColor xui_colorWithHex:themeDictionary[@"backgroundColor"]];
        if (themeDictionary[@"disclosureIndicatorColor"])
            _disclosureIndicatorColor = [UIColor xui_colorWithHex:themeDictionary[@"disclosureIndicatorColor"]];
        
        if (themeDictionary[@"tagTextColor"])
            _tagTextColor = [UIColor xui_colorWithHex:themeDictionary[@"tagTextColor"]];
        if (themeDictionary[@"tagSelectedTextColor"])
            _tagSelectedTextColor = [UIColor xui_colorWithHex:themeDictionary[@"tagSelectedTextColor"]];
        if (themeDictionary[@"tagBorderColor"])
            _tagBorderColor = [UIColor xui_colorWithHex:themeDictionary[@"tagBorderColor"]];
        if (themeDictionary[@"tagSelectedBorderColor"])
            _tagSelectedBorderColor = [UIColor xui_colorWithHex:themeDictionary[@"tagSelectedBorderColor"]];
        if (themeDictionary[@"tagBackgroundColor"])
            _tagBackgroundColor = [UIColor xui_colorWithHex:themeDictionary[@"tagBackgroundColor"]];
        if (themeDictionary[@"tagSelectedBackgroundColor"])
            _tagSelectedBackgroundColor = [UIColor xui_colorWithHex:themeDictionary[@"tagSelectedBackgroundColor"]];
        
        
    }
    return self;
}

- (void)setup {
    _dangerColor = XUI_COLOR_DANGER;
    _warningColor = XUI_COLOR_WARNING;
    _successColor = XUI_COLOR_SUCCESS;
    
    _navigationBarColor = XUI_COLOR_HIGHLIGHTED;
    _navigationTitleColor = [UIColor whiteColor];
    
    _labelColor = [UIColor blackColor];
    _valueColor = [UIColor grayColor];
    
     _tintColor = XUI_COLOR_HIGHLIGHTED;
    _backgroundColor = [UIColor whiteColor];
    _disclosureIndicatorColor = XUI_COLOR_DISCLOSURE;
    
    _selectedColor = [XUI_COLOR_HIGHLIGHTED colorWithAlphaComponent:0.1];
    _highlightedColor = XUI_COLOR_HIGHLIGHTED;
    
    _tagTextColor = XUI_COLOR_HIGHLIGHTED;
    _tagSelectedTextColor = [UIColor whiteColor];
    _tagBorderColor = XUI_COLOR_HIGHLIGHTED;
    _tagSelectedBorderColor = XUI_COLOR_HIGHLIGHTED;
    _tagBackgroundColor = [UIColor whiteColor];
    _tagSelectedBackgroundColor = XUI_COLOR_HIGHLIGHTED;
}

- (BOOL)isDarkMode {
    return [self.navigationBarColor xui_isDarkColor];
}

@end
