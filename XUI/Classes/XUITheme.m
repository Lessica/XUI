//
//  XUITheme.m
//  XXTExplorer
//
//  Created by Zheng Wu on 14/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUITheme.h"
#import "UIColor+XUIDarkColor.h"

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
        
        
    }
    return self;
}

- (void)setup {
    _tintColor = XUI_COLOR_HIGHLIGHTED;
    _dangerColor = XUI_COLOR_DANGER;
    _warningColor = XUI_COLOR_WARNING;
    _successColor = XUI_COLOR_SUCCESS;
    _highlightedColor = XUI_COLOR_HIGHLIGHTED;
    
    _navigationBarColor = XUI_COLOR_HIGHLIGHTED;
    _navigationTitleColor = [UIColor whiteColor];
    
    _labelColor = [UIColor blackColor];
    _valueColor = [UIColor grayColor];
    
    _backgroundColor = [UIColor whiteColor];
    _disclosureIndicatorColor = XUI_COLOR_DISCLOSURE;
    
    _selectedColor = [XUI_COLOR_HIGHLIGHTED colorWithAlphaComponent:0.1];
}

- (BOOL)isDarkMode {
    return [self.navigationBarColor xui_isDarkColor];
}

@end
