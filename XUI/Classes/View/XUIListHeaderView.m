//
//  XUIListHeaderView.m
//  XXTExplorer
//
//  Created by Zheng on 2017/7/21.
//  Copyright © 2017年 Zheng. All rights reserved.
//

#import "XUIListHeaderView.h"

#import "XUITheme.h"
#import "XUIPrivate.h"

static inline UIEdgeInsets XUIListHeaderViewEdgeInsets() {
    static UIEdgeInsets defaultEdgeInsets;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat headerPadding = SCREEN_MIN_LENGTH * 0.05;
        CGFloat headerMargin = SCREEN_MIN_LENGTH * 0.37 / 4.0;
        defaultEdgeInsets = UIEdgeInsetsMake(headerMargin, headerPadding, headerMargin, headerPadding);
    });
    return defaultEdgeInsets;
}

@interface XUIListHeaderView ()

@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UILabel *subheaderLabel;

@property (nonatomic, strong) NSDictionary *headerAttributes;
@property (nonatomic, strong) NSDictionary *subheaderAttributes;

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat subheaderHeight;

@end

@implementation XUIListHeaderView

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UIFont *lightHeaderFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:36.f];
    if (!lightHeaderFont) {
        XUI_START_IGNORE_PARTIAL
        if (XUI_SYSTEM_8_2) {
            lightHeaderFont = [UIFont systemFontOfSize:36.f weight:UIFontWeightUltraLight];
        } else {
            lightHeaderFont = [UIFont systemFontOfSize:36.f];
        }
        XUI_END_IGNORE_PARTIAL
    }
    if (lightHeaderFont) {
        _headerAttributes = @{ NSFontAttributeName: lightHeaderFont,
                               NSForegroundColorAttributeName: [UIColor colorWithWhite:0.f alpha:.85f] };
    }
    UIFont *lightSubheaderFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:18.f];
    if (!lightSubheaderFont) {
        XUI_START_IGNORE_PARTIAL
        if (XUI_SYSTEM_8_2) {
            lightSubheaderFont = [UIFont systemFontOfSize:18.f weight:UIFontWeightUltraLight];
        } else {
            lightSubheaderFont = [UIFont systemFontOfSize:18.f];
        }
        XUI_END_IGNORE_PARTIAL
    }
    if (lightSubheaderFont) {
        _subheaderAttributes = @{ NSFontAttributeName: lightSubheaderFont,
                                  NSForegroundColorAttributeName: [UIColor colorWithWhite:0.f alpha:.85f] };
    }
    
    [self addSubview:self.headerLabel];
    [self addSubview:self.subheaderLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.headerLabel.frame = CGRectMake(XUIListHeaderViewEdgeInsets().left, XUIListHeaderViewEdgeInsets().top, self.bounds.size.width - XUIListHeaderViewEdgeInsets().left - XUIListHeaderViewEdgeInsets().right, self.headerHeight);
    self.subheaderLabel.frame = CGRectMake(XUIListHeaderViewEdgeInsets().left, XUIListHeaderViewEdgeInsets().top + self.headerHeight + 12.f, self.bounds.size.width - XUIListHeaderViewEdgeInsets().left - XUIListHeaderViewEdgeInsets().right, self.subheaderHeight);
}

- (CGSize)intrinsicContentSize {
    if (!_headerText && !_subheaderText) {
        return CGSizeZero;
    }
    return CGSizeMake(self.bounds.size.width, XUIListHeaderViewEdgeInsets().top + self.headerHeight + 12.f + self.subheaderHeight + XUIListHeaderViewEdgeInsets().bottom);
}

#pragma mark - UIView Getters

- (UILabel *)headerLabel {
    if (!_headerLabel) {
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel.backgroundColor = UIColor.clearColor;
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.numberOfLines = 1;
        headerLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        headerLabel.adjustsFontSizeToFitWidth = YES;
        headerLabel.minimumScaleFactor = 0.75f;
        _headerLabel = headerLabel;
    }
    return _headerLabel;
}

- (UILabel *)subheaderLabel {
    if (!_subheaderLabel) {
        UILabel *subheaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        subheaderLabel.backgroundColor = UIColor.clearColor;
        subheaderLabel.textAlignment = NSTextAlignmentCenter;
        subheaderLabel.numberOfLines = 0;
        subheaderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _subheaderLabel = subheaderLabel;
    }
    return _subheaderLabel;
}

#pragma mark - Setters

- (void)setHeaderText:(NSString *)headerText {
    _headerText = headerText;
    
    NSAttributedString *attributedHeaderText = [[NSAttributedString alloc] initWithString:headerText attributes:self.headerAttributes];
    [self.headerLabel setAttributedText:attributedHeaderText];
    
    self.headerHeight = [attributedHeaderText boundingRectWithSize:CGSizeMake(self.bounds.size.width - XUIListHeaderViewEdgeInsets().left - XUIListHeaderViewEdgeInsets().right, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
}

- (void)setSubheaderText:(NSString *)subheaderText {
    _subheaderText = subheaderText;
    
    NSAttributedString *attributedSubheaderText = [[NSAttributedString alloc] initWithString:subheaderText attributes:self.subheaderAttributes];
    [self.subheaderLabel setAttributedText:attributedSubheaderText];
    
    self.subheaderHeight = [attributedSubheaderText boundingRectWithSize:CGSizeMake(self.bounds.size.width - XUIListHeaderViewEdgeInsets().left - XUIListHeaderViewEdgeInsets().right, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
}

- (void)setTheme:(XUITheme *)theme {
    _theme = theme;
    self.backgroundColor = theme.headerBackgroundColor ?: UIColor.clearColor;
    if (@available(iOS 13.0, *)) {
        self.headerLabel.textColor = theme.headerTextColor ?: UIColor.labelColor;
        self.subheaderLabel.textColor = theme.subheaderTextColor ?: UIColor.labelColor;
    } else {
        if (theme.headerTextColor) {
            self.headerLabel.textColor = theme.headerTextColor;
        }
        if (theme.subheaderTextColor) {
            self.subheaderLabel.textColor = theme.subheaderTextColor;
        }
    }
}

@end
