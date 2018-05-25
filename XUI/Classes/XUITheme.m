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
        [self combineWithDictionary:themeDictionary];
        _rawTheme = themeDictionary;
    }
    return self;
}

- (instancetype)initWithTheme:(XUITheme *)theme {
    self = [super init];
    if (self) {
        [self setupWithTheme:theme];
    }
    return self;
}

- (void)setupWithTheme:(XUITheme *)theme {
    
    _dangerColor = theme.dangerColor;
    _warningColor = theme.warningColor;
    _successColor = theme.successColor;
    
    _navigationBarColor = theme.navigationBarColor;
    _navigationTitleColor = theme.navigationTitleColor;
    
    _headerTextColor = theme.headerTextColor;
    _subheaderTextColor = theme.subheaderTextColor;
    _footerTextColor = theme.footerTextColor;
    _headerBackgroundColor = theme.headerBackgroundColor;
    _footerBackgroundColor = theme.footerBackgroundColor;
    
    _tableViewStyle = theme.tableViewStyle;
    _foregroundColor = theme.foregroundColor;
    _backgroundColor = theme.backgroundColor;
    _separatorColor = theme.separatorColor;
    _backgroundImagePath = theme.backgroundImagePath;
    
    _groupHeaderTextColor = theme.groupHeaderTextColor;
    _groupFooterTextColor = theme.groupFooterTextColor;
    _groupHeaderBackgroundColor = theme.groupHeaderBackgroundColor;
    _groupFooterBackgroundColor = theme.groupFooterBackgroundColor;
    
    _cellBackgroundColor = theme.cellBackgroundColor;
    _selectedColor = theme.selectedColor;
    _highlightedColor = theme.highlightedColor;
    _disclosureIndicatorColor = theme.disclosureIndicatorColor;
    _labelColor = theme.labelColor;
    _valueColor = theme.valueColor;
    
    _textColor = theme.textColor;
    _caretColor = theme.caretColor;
    _placeholderColor = theme.placeholderColor;
    
    _tagTextColor = theme.tagTextColor;
    _tagSelectedTextColor = theme.tagSelectedTextColor;
    _tagBorderColor = theme.tagBorderColor;
    _tagSelectedBorderColor = theme.tagSelectedBorderColor;
    _tagBackgroundColor = theme.tagBackgroundColor;
    _tagSelectedBackgroundColor = theme.tagSelectedBackgroundColor;
    
    _offTintColor = theme.offTintColor;
    _onTintColor = theme.onTintColor;
    _thumbTintColor = theme.thumbTintColor;
    
    _rawTheme = theme.rawTheme;
    
}

- (void)setup {
    
    _dangerColor = XUI_COLOR_DANGER;
    _warningColor = XUI_COLOR_WARNING;
    _successColor = XUI_COLOR_SUCCESS;
    
    _navigationBarColor = XUI_COLOR_HIGHLIGHTED;
    _navigationTitleColor = [UIColor whiteColor];
    
    _headerTextColor = [UIColor blackColor];
    _subheaderTextColor = [UIColor blackColor];
    _footerTextColor = [UIColor blackColor];
    _headerBackgroundColor = [UIColor clearColor];
    _footerBackgroundColor = [UIColor clearColor];
    
    _tableViewStyle = UITableViewStyleGrouped;
    _foregroundColor = XUI_COLOR_HIGHLIGHTED;
    _backgroundColor = [UIColor groupTableViewBackgroundColor];
    _separatorColor = [UIColor lightGrayColor];
    _backgroundImagePath = nil;
    
    _groupHeaderTextColor = [UIColor grayColor];
    _groupFooterTextColor = [UIColor grayColor];
    _groupHeaderBackgroundColor = [UIColor clearColor];
    _groupFooterBackgroundColor = [UIColor clearColor];
    
    _cellBackgroundColor = [UIColor whiteColor];
    _selectedColor = [XUI_COLOR_HIGHLIGHTED colorWithAlphaComponent:0.1];
    _highlightedColor = XUI_COLOR_HIGHLIGHTED;
    _disclosureIndicatorColor = XUI_COLOR_DISCLOSURE;
    _labelColor = [UIColor blackColor];
    _valueColor = [UIColor grayColor];
    
    _textColor = [UIColor blackColor];
    _caretColor = XUI_COLOR_HIGHLIGHTED;
    _placeholderColor = [UIColor lightGrayColor];
    
    _tagTextColor = XUI_COLOR_HIGHLIGHTED;
    _tagSelectedTextColor = [UIColor whiteColor];
    _tagBorderColor = XUI_COLOR_HIGHLIGHTED;
    _tagSelectedBorderColor = XUI_COLOR_HIGHLIGHTED;
    _tagBackgroundColor = [UIColor whiteColor];
    _tagSelectedBackgroundColor = XUI_COLOR_HIGHLIGHTED;
    
    _offTintColor = [UIColor xui_colorWithHex:@"#E0E0E0"];
    _onTintColor = XUI_COLOR_SUCCESS;
    _thumbTintColor = [UIColor whiteColor];
    
    _rawTheme = nil;
    
}

- (void)combineWithDictionary:(NSDictionary *)additionalDictionary {
    if ([additionalDictionary[@"style"] isKindOfClass:[NSString class]]) {
        NSString *style = additionalDictionary[@"style"];
        if ([style isEqualToString:@"Plain"]) {
            _tableViewStyle = UITableViewStylePlain;
        } else if ([style isEqualToString:@"Grouped"]) {
            _tableViewStyle = UITableViewStyleGrouped;
        }
    }
    
    if ([additionalDictionary[@"tintColor"] isKindOfClass:[NSString class]])
        _foregroundColor = [UIColor xui_colorWithHex:additionalDictionary[@"tintColor"]];
    if ([additionalDictionary[@"foregroundColor"] isKindOfClass:[NSString class]])
        _foregroundColor = [UIColor xui_colorWithHex:additionalDictionary[@"foregroundColor"]];
    
    if ([additionalDictionary[@"backgroundColor"] isKindOfClass:[NSString class]])
        _backgroundColor = [UIColor xui_colorWithHex:additionalDictionary[@"backgroundColor"]];
    if ([additionalDictionary[@"separatorColor"] isKindOfClass:[NSString class]])
        _separatorColor = [UIColor xui_colorWithHex:additionalDictionary[@"separatorColor"]];
    if ([additionalDictionary[@"backgroundImage"] isKindOfClass:[NSString class]])
        _backgroundImagePath = additionalDictionary[@"backgroundImage"];
    
    if ([additionalDictionary[@"groupHeaderTextColor"] isKindOfClass:[NSString class]])
        _groupHeaderTextColor = [UIColor xui_colorWithHex:additionalDictionary[@"groupHeaderTextColor"]];
    if ([additionalDictionary[@"groupFooterTextColor"] isKindOfClass:[NSString class]])
        _groupFooterTextColor = [UIColor xui_colorWithHex:additionalDictionary[@"groupFooterTextColor"]];
    if ([additionalDictionary[@"groupHeaderBackgroundColor"] isKindOfClass:[NSString class]])
        _groupHeaderBackgroundColor = [UIColor xui_colorWithHex:additionalDictionary[@"groupHeaderBackgroundColor"]];
    if ([additionalDictionary[@"groupFooterBackgroundColor"] isKindOfClass:[NSString class]])
        _groupFooterBackgroundColor = [UIColor xui_colorWithHex:additionalDictionary[@"groupFooterBackgroundColor"]];
    
    if ([additionalDictionary[@"dangerColor"] isKindOfClass:[NSString class]])
        _dangerColor = [UIColor xui_colorWithHex:additionalDictionary[@"dangerColor"]];
    if ([additionalDictionary[@"warningColor"] isKindOfClass:[NSString class]])
        _warningColor = [UIColor xui_colorWithHex:additionalDictionary[@"warningColor"]];
    if ([additionalDictionary[@"successColor"] isKindOfClass:[NSString class]])
        _successColor = [UIColor xui_colorWithHex:additionalDictionary[@"successColor"]];
    
    if ([additionalDictionary[@"selectedColor"] isKindOfClass:[NSString class]])
        _selectedColor = [UIColor xui_colorWithHex:additionalDictionary[@"selectedColor"]];
    if ([additionalDictionary[@"highlightedColor"] isKindOfClass:[NSString class]])
        _highlightedColor = [UIColor xui_colorWithHex:additionalDictionary[@"highlightedColor"]];
    
    if ([additionalDictionary[@"navigationBarColor"] isKindOfClass:[NSString class]])
        _navigationBarColor = [UIColor xui_colorWithHex:additionalDictionary[@"navigationBarColor"]];
    if ([additionalDictionary[@"navigationTitleColor"] isKindOfClass:[NSString class]])
        _navigationTitleColor = [UIColor xui_colorWithHex:additionalDictionary[@"navigationTitleColor"]];
    
    if ([additionalDictionary[@"headerTextColor"] isKindOfClass:[NSString class]])
        _headerTextColor = [UIColor xui_colorWithHex:additionalDictionary[@"headerTextColor"]];
    if ([additionalDictionary[@"subheaderTextColor"] isKindOfClass:[NSString class]])
        _subheaderTextColor = [UIColor xui_colorWithHex:additionalDictionary[@"subheaderTextColor"]];
    if ([additionalDictionary[@"footerTextColor"] isKindOfClass:[NSString class]])
        _footerTextColor = [UIColor xui_colorWithHex:additionalDictionary[@"footerTextColor"]];
    if ([additionalDictionary[@"headerBackgroundColor"] isKindOfClass:[NSString class]])
        _headerBackgroundColor = [UIColor xui_colorWithHex:additionalDictionary[@"headerBackgroundColor"]];
    if ([additionalDictionary[@"footerBackgroundColor"] isKindOfClass:[NSString class]])
        _footerBackgroundColor = [UIColor xui_colorWithHex:additionalDictionary[@"footerBackgroundColor"]];
    
    if ([additionalDictionary[@"labelColor"] isKindOfClass:[NSString class]])
        _labelColor = [UIColor xui_colorWithHex:additionalDictionary[@"labelColor"]];
    if ([additionalDictionary[@"valueColor"] isKindOfClass:[NSString class]])
        _valueColor = [UIColor xui_colorWithHex:additionalDictionary[@"valueColor"]];
    
    if ([additionalDictionary[@"caretColor"] isKindOfClass:[NSString class]])
        _caretColor = [UIColor xui_colorWithHex:additionalDictionary[@"caretColor"]];
    if ([additionalDictionary[@"textColor"] isKindOfClass:[NSString class]])
        _textColor = [UIColor xui_colorWithHex:additionalDictionary[@"textColor"]];
    if ([additionalDictionary[@"placeholderColor"] isKindOfClass:[NSString class]])
        _placeholderColor = [UIColor xui_colorWithHex:additionalDictionary[@"placeholderColor"]];
    
    if ([additionalDictionary[@"cellBackgroundColor"] isKindOfClass:[NSString class]])
        _cellBackgroundColor = [UIColor xui_colorWithHex:additionalDictionary[@"cellBackgroundColor"]];
    if ([additionalDictionary[@"disclosureIndicatorColor"] isKindOfClass:[NSString class]])
        _disclosureIndicatorColor = [UIColor xui_colorWithHex:additionalDictionary[@"disclosureIndicatorColor"]];
    
    if ([additionalDictionary[@"tagTextColor"] isKindOfClass:[NSString class]])
        _tagTextColor = [UIColor xui_colorWithHex:additionalDictionary[@"tagTextColor"]];
    if ([additionalDictionary[@"tagSelectedTextColor"] isKindOfClass:[NSString class]])
        _tagSelectedTextColor = [UIColor xui_colorWithHex:additionalDictionary[@"tagSelectedTextColor"]];
    if ([additionalDictionary[@"tagBorderColor"] isKindOfClass:[NSString class]])
        _tagBorderColor = [UIColor xui_colorWithHex:additionalDictionary[@"tagBorderColor"]];
    if ([additionalDictionary[@"tagSelectedBorderColor"] isKindOfClass:[NSString class]])
        _tagSelectedBorderColor = [UIColor xui_colorWithHex:additionalDictionary[@"tagSelectedBorderColor"]];
    if ([additionalDictionary[@"tagBackgroundColor"] isKindOfClass:[NSString class]])
        _tagBackgroundColor = [UIColor xui_colorWithHex:additionalDictionary[@"tagBackgroundColor"]];
    if ([additionalDictionary[@"tagSelectedBackgroundColor"] isKindOfClass:[NSString class]])
        _tagSelectedBackgroundColor = [UIColor xui_colorWithHex:additionalDictionary[@"tagSelectedBackgroundColor"]];
    
    if ([additionalDictionary[@"offTintColor"] isKindOfClass:[NSString class]])
        _offTintColor = [UIColor xui_colorWithHex:additionalDictionary[@"offTintColor"]];
    if ([additionalDictionary[@"onTintColor"] isKindOfClass:[NSString class]])
        _onTintColor = [UIColor xui_colorWithHex:additionalDictionary[@"onTintColor"]];
    if ([additionalDictionary[@"thumbTintColor"] isKindOfClass:[NSString class]])
        _thumbTintColor = [UIColor xui_colorWithHex:additionalDictionary[@"thumbTintColor"]];
    
    NSMutableDictionary *themeDictionary = [self.rawTheme mutableCopy];
    if (!themeDictionary) {
        themeDictionary = [[NSMutableDictionary alloc] init];
    }
    [themeDictionary addEntriesFromDictionary:additionalDictionary];
    [self setRawTheme:themeDictionary];
}

- (BOOL)isDarkMode {
    return [self.navigationBarColor xui_isDarkColor];
}

- (BOOL)isBackgroundDark {
    return [self.backgroundColor xui_isDarkColor];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    XUITheme *theme = [[XUITheme alloc] initWithTheme:self];
    return theme;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    XUITheme *theme = [[XUITheme alloc] initWithDictionary:self.rawTheme];
    return theme;
}

@end
