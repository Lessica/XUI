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
        
        if ([themeDictionary[@"style"] isKindOfClass:[NSString class]]) {
            NSString *style = themeDictionary[@"style"];
            if ([style isEqualToString:@"Plain"]) {
                _tableViewStyle = UITableViewStylePlain;
            } else {
                _tableViewStyle = UITableViewStyleGrouped;
            }
        }
        
        if ([themeDictionary[@"tintColor"] isKindOfClass:[NSString class]])
            _foregroundColor = [UIColor xui_colorWithHex:themeDictionary[@"tintColor"]];
        if ([themeDictionary[@"foregroundColor"] isKindOfClass:[NSString class]])
            _foregroundColor = [UIColor xui_colorWithHex:themeDictionary[@"foregroundColor"]];
        
        if ([themeDictionary[@"backgroundColor"] isKindOfClass:[NSString class]])
            _backgroundColor = [UIColor xui_colorWithHex:themeDictionary[@"backgroundColor"]];
        if ([themeDictionary[@"separatorColor"] isKindOfClass:[NSString class]])
            _separatorColor = [UIColor xui_colorWithHex:themeDictionary[@"separatorColor"]];
        if ([themeDictionary[@"backgroundImage"] isKindOfClass:[NSString class]])
            _backgroundImagePath = themeDictionary[@"backgroundImage"];
        if ([themeDictionary[@"sectionHeaderTextColor"] isKindOfClass:[NSString class]])
            _sectionHeaderTextColor = [UIColor xui_colorWithHex:themeDictionary[@"sectionHeaderTextColor"]];
        if ([themeDictionary[@"sectionFooterTextColor"] isKindOfClass:[NSString class]])
            _sectionFooterTextColor = [UIColor xui_colorWithHex:themeDictionary[@"sectionFooterTextColor"]];
        
        if ([themeDictionary[@"dangerColor"] isKindOfClass:[NSString class]])
            _dangerColor = [UIColor xui_colorWithHex:themeDictionary[@"dangerColor"]];
        if ([themeDictionary[@"warningColor"] isKindOfClass:[NSString class]])
            _warningColor = [UIColor xui_colorWithHex:themeDictionary[@"warningColor"]];
        if ([themeDictionary[@"successColor"] isKindOfClass:[NSString class]])
            _successColor = [UIColor xui_colorWithHex:themeDictionary[@"successColor"]];
        
        if ([themeDictionary[@"selectedColor"] isKindOfClass:[NSString class]])
            _selectedColor = [UIColor xui_colorWithHex:themeDictionary[@"selectedColor"]];
        if ([themeDictionary[@"highlightedColor"] isKindOfClass:[NSString class]])
            _highlightedColor = [UIColor xui_colorWithHex:themeDictionary[@"highlightedColor"]];
        
        if ([themeDictionary[@"navigationBarColor"] isKindOfClass:[NSString class]])
            _navigationBarColor = [UIColor xui_colorWithHex:themeDictionary[@"navigationBarColor"]];
        if ([themeDictionary[@"navigationTitleColor"] isKindOfClass:[NSString class]])
            _navigationTitleColor = [UIColor xui_colorWithHex:themeDictionary[@"navigationTitleColor"]];
        
        if ([themeDictionary[@"headerTextColor"] isKindOfClass:[NSString class]])
            _headerTextColor = [UIColor xui_colorWithHex:themeDictionary[@"headerTextColor"]];
        if ([themeDictionary[@"subheaderTextColor"] isKindOfClass:[NSString class]])
            _subheaderTextColor = [UIColor xui_colorWithHex:themeDictionary[@"subheaderTextColor"]];
        if ([themeDictionary[@"footerTextColor"] isKindOfClass:[NSString class]])
            _footerTextColor = [UIColor xui_colorWithHex:themeDictionary[@"footerTextColor"]];
        
        if ([themeDictionary[@"labelColor"] isKindOfClass:[NSString class]])
            _labelColor = [UIColor xui_colorWithHex:themeDictionary[@"labelColor"]];
        if ([themeDictionary[@"valueColor"] isKindOfClass:[NSString class]])
            _valueColor = [UIColor xui_colorWithHex:themeDictionary[@"valueColor"]];
        
        if ([themeDictionary[@"caretColor"] isKindOfClass:[NSString class]])
            _caretColor = [UIColor xui_colorWithHex:themeDictionary[@"caretColor"]];
        if ([themeDictionary[@"textColor"] isKindOfClass:[NSString class]])
            _textColor = [UIColor xui_colorWithHex:themeDictionary[@"textColor"]];
        if ([themeDictionary[@"placeholderColor"] isKindOfClass:[NSString class]])
            _placeholderColor = [UIColor xui_colorWithHex:themeDictionary[@"placeholderColor"]];
        
        if ([themeDictionary[@"cellBackgroundColor"] isKindOfClass:[NSString class]])
            _cellBackgroundColor = [UIColor xui_colorWithHex:themeDictionary[@"cellBackgroundColor"]];
        if ([themeDictionary[@"disclosureIndicatorColor"] isKindOfClass:[NSString class]])
            _disclosureIndicatorColor = [UIColor xui_colorWithHex:themeDictionary[@"disclosureIndicatorColor"]];
        
        if ([themeDictionary[@"tagTextColor"] isKindOfClass:[NSString class]])
            _tagTextColor = [UIColor xui_colorWithHex:themeDictionary[@"tagTextColor"]];
        if ([themeDictionary[@"tagSelectedTextColor"] isKindOfClass:[NSString class]])
            _tagSelectedTextColor = [UIColor xui_colorWithHex:themeDictionary[@"tagSelectedTextColor"]];
        if ([themeDictionary[@"tagBorderColor"] isKindOfClass:[NSString class]])
            _tagBorderColor = [UIColor xui_colorWithHex:themeDictionary[@"tagBorderColor"]];
        if ([themeDictionary[@"tagSelectedBorderColor"] isKindOfClass:[NSString class]])
            _tagSelectedBorderColor = [UIColor xui_colorWithHex:themeDictionary[@"tagSelectedBorderColor"]];
        if ([themeDictionary[@"tagBackgroundColor"] isKindOfClass:[NSString class]])
            _tagBackgroundColor = [UIColor xui_colorWithHex:themeDictionary[@"tagBackgroundColor"]];
        if ([themeDictionary[@"tagSelectedBackgroundColor"] isKindOfClass:[NSString class]])
            _tagSelectedBackgroundColor = [UIColor xui_colorWithHex:themeDictionary[@"tagSelectedBackgroundColor"]];
        
        if ([themeDictionary[@"thumbColor"] isKindOfClass:[NSString class]])
            _thumbTintColor = [UIColor xui_colorWithHex:themeDictionary[@"thumbColor"]];
        if ([themeDictionary[@"thumbTintColor"] isKindOfClass:[NSString class]])
            _thumbTintColor = [UIColor xui_colorWithHex:themeDictionary[@"thumbTintColor"]];
        
        _rawTheme = themeDictionary;
    }
    return self;
}

- (void)setup {
    _tableViewStyle = UITableViewStyleGrouped;
    _foregroundColor = XUI_COLOR_HIGHLIGHTED;
    _backgroundColor = [UIColor groupTableViewBackgroundColor];
    _separatorColor = [UIColor lightGrayColor];
    _backgroundImagePath = nil;
    _sectionHeaderTextColor = [UIColor grayColor];
    _sectionFooterTextColor = [UIColor grayColor];
    
    _dangerColor = XUI_COLOR_DANGER;
    _warningColor = XUI_COLOR_WARNING;
    _successColor = XUI_COLOR_SUCCESS;
    
    _navigationBarColor = XUI_COLOR_HIGHLIGHTED;
    _navigationTitleColor = [UIColor whiteColor];
    
    _labelColor = [UIColor blackColor];
    _valueColor = [UIColor grayColor];
    _headerTextColor = [UIColor blackColor];
    _subheaderTextColor = [UIColor blackColor];
    _footerTextColor = [UIColor blackColor];
    
    _textColor = [UIColor blackColor];
    _caretColor = XUI_COLOR_HIGHLIGHTED;
    _placeholderColor = [UIColor lightGrayColor];
    
    _cellBackgroundColor = [UIColor whiteColor];
    _disclosureIndicatorColor = XUI_COLOR_DISCLOSURE;
    
    _selectedColor = [XUI_COLOR_HIGHLIGHTED colorWithAlphaComponent:0.1];
    _highlightedColor = XUI_COLOR_HIGHLIGHTED;
    
    _tagTextColor = XUI_COLOR_HIGHLIGHTED;
    _tagSelectedTextColor = [UIColor whiteColor];
    _tagBorderColor = XUI_COLOR_HIGHLIGHTED;
    _tagSelectedBorderColor = XUI_COLOR_HIGHLIGHTED;
    _tagBackgroundColor = [UIColor whiteColor];
    _tagSelectedBackgroundColor = XUI_COLOR_HIGHLIGHTED;
    
    _thumbTintColor = [UIColor whiteColor];
}

- (BOOL)isDarkMode {
    return [self.navigationBarColor xui_isDarkColor];
}

- (BOOL)isBackgroundDark {
    return [self.backgroundColor xui_isDarkColor];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    XUITheme *theme = [[XUITheme alloc] initWithDictionary:self.rawTheme];
    return theme;
}

@end
