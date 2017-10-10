//
//  XUIListHeaderView.m
//  XXTExplorer
//
//  Created by Zheng on 2017/7/21.
//  Copyright © 2017年 Zheng. All rights reserved.
//

#import "XUIListHeaderView.h"

#import "XUITheme.h"

static UIEdgeInsets const XUIListHeaderViewEdgeInsets = { 40.f, 20.f, 20.f, 20.f };

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
    UIFont *lightHeaderFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:45.f];
    if (!lightHeaderFont) {
        lightHeaderFont = [UIFont systemFontOfSize:45.f];
    }
    if (lightHeaderFont) {
        _headerAttributes = @{ NSFontAttributeName: lightHeaderFont,
                               NSForegroundColorAttributeName: [UIColor colorWithWhite:0.f alpha:.85f] };
    }
    UIFont *lightSubheaderFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:18.f];
    if (!lightSubheaderFont) {
        lightSubheaderFont = [UIFont systemFontOfSize:18.f];
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
    self.headerLabel.frame = CGRectMake(XUIListHeaderViewEdgeInsets.left, XUIListHeaderViewEdgeInsets.top, self.bounds.size.width - XUIListHeaderViewEdgeInsets.left - XUIListHeaderViewEdgeInsets.right, self.headerHeight);
    self.subheaderLabel.frame = CGRectMake(XUIListHeaderViewEdgeInsets.left, XUIListHeaderViewEdgeInsets.top + self.headerHeight + 12.f, self.bounds.size.width - XUIListHeaderViewEdgeInsets.left - XUIListHeaderViewEdgeInsets.right, self.subheaderHeight);
}

- (CGSize)intrinsicContentSize {
    if (self.headerText && self.subheaderHeight) {
        return CGSizeMake(self.bounds.size.width, XUIListHeaderViewEdgeInsets.top + self.headerHeight + 12.f + self.subheaderHeight + XUIListHeaderViewEdgeInsets.bottom);
    }
    return CGSizeZero;
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
    
    self.headerHeight = [attributedHeaderText boundingRectWithSize:CGSizeMake(self.bounds.size.width - XUIListHeaderViewEdgeInsets.left - XUIListHeaderViewEdgeInsets.right, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
}

- (void)setSubheaderText:(NSString *)subheaderText {
    _subheaderText = subheaderText;
    
    NSAttributedString *attributedSubheaderText = [[NSAttributedString alloc] initWithString:subheaderText attributes:self.subheaderAttributes];
    [self.subheaderLabel setAttributedText:attributedSubheaderText];
    
    self.subheaderHeight = [attributedSubheaderText boundingRectWithSize:CGSizeMake(self.bounds.size.width - XUIListHeaderViewEdgeInsets.left - XUIListHeaderViewEdgeInsets.right, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
}

- (void)setTheme:(XUITheme *)theme {
    _theme = theme;
    self.headerLabel.textColor = theme.labelColor;
    self.subheaderLabel.textColor = theme.labelColor;
}

@end
