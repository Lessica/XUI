//
//  XUIListFooterView.m
//  XXTExplorer
//
//  Created by Zheng on 24/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIListFooterView.h"
#import "XUIPrivate.h"
#import "XUITheme.h"

static UIEdgeInsets const XUIListFooterViewEdgeInsets = { 32.f, 20.f, 32.f, 20.f };

@interface XUIListFooterView ()

@property (nonatomic, strong) UIImageView *footerIconView;
@property (nonatomic, strong) UILabel *footerLabel;

@property (nonatomic, strong) NSDictionary *footerAttributes;
@property (nonatomic, assign) CGFloat footerHeight;

@end

@implementation XUIListFooterView

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
    _footerIcon = [[UIImage alloc] init];
    
    UIFont *lightFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:14.f];
    if (!lightFont) {
        XUI_START_IGNORE_PARTIAL
        if (XUI_SYSTEM_8_2) {
            lightFont = [UIFont systemFontOfSize:14.f weight:UIFontWeightUltraLight];
        } else {
            lightFont = [UIFont systemFontOfSize:14.f];
        }
        XUI_END_IGNORE_PARTIAL
    }
    if (lightFont) {
        _footerAttributes = @{ NSFontAttributeName: lightFont,
                               NSForegroundColorAttributeName: [UIColor colorWithWhite:0.f alpha:.85f] };
    }
    
    [self addSubview:self.footerIconView];
    [self addSubview:self.footerLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.footerIconView.frame = CGRectMake(XUIListFooterViewEdgeInsets.left, XUIListFooterViewEdgeInsets.top, CGRectGetWidth(self.bounds) - XUIListFooterViewEdgeInsets.left - XUIListFooterViewEdgeInsets.right, 32.f);
    self.footerLabel.frame = CGRectMake(XUIListFooterViewEdgeInsets.left, XUIListFooterViewEdgeInsets.top + 32.f + 12.f, CGRectGetWidth(self.bounds) - XUIListFooterViewEdgeInsets.left - XUIListFooterViewEdgeInsets.right, self.footerHeight);
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(self.bounds.size.width, XUIListFooterViewEdgeInsets.top + 32.f + 12.f + self.footerHeight + XUIListFooterViewEdgeInsets.bottom);
}

#pragma mark - UIView Getters

- (UIImageView *)footerIconView {
    if (!_footerIconView) {
        UIImageView *footerIconView = [[UIImageView alloc] init];
        footerIconView.contentMode = UIViewContentModeScaleAspectFit;
        footerIconView.image = self.footerIcon;
        _footerIconView = footerIconView;
    }
    return _footerIconView;
}

- (UILabel *)footerLabel {
    if (!_footerLabel) {
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        footerLabel.backgroundColor = UIColor.clearColor;
        footerLabel.textAlignment = NSTextAlignmentCenter;
        footerLabel.numberOfLines = 0;
        footerLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _footerLabel = footerLabel;
    }
    return _footerLabel;
}

#pragma mark - Setters

- (void)setFooterText:(NSString *)footerText {
    _footerText = footerText;
    
    NSAttributedString *attributedFooterText = [[NSAttributedString alloc] initWithString:footerText attributes:self.footerAttributes];
    [self.footerLabel setAttributedText:attributedFooterText];
    
    self.footerHeight = [attributedFooterText boundingRectWithSize:CGSizeMake(self.bounds.size.width - XUIListFooterViewEdgeInsets.left - XUIListFooterViewEdgeInsets.right, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
}

- (void)setTheme:(XUITheme *)theme {
    _theme = theme;
    self.backgroundColor = theme.backgroundColor;
    self.footerIconView.tintColor = theme.foregroundColor;
    self.footerLabel.textColor = theme.labelColor;
}

@end
