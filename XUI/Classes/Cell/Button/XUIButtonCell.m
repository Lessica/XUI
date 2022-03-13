//
//  XUIButtonCell.m
//  XXTExplorer
//
//  Created by Zheng on 29/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIButtonCell.h"
#import "XUITheme.h"
#import "XUIPrivate.h"
#import "XUILogger.h"
#import "XUIAdapter.h"

void const * XUIButtonCellStorageKey = &XUIButtonCellStorageKey;
NSString * const XUIButtonCellReuseIdentifier = @"XUIButtonCellReuseIdentifier";

@interface XUIButtonCell ()

@property (nonatomic, strong) NSLayoutConstraint *labelConstraint;
@property (nonatomic, strong) NSLayoutConstraint *iconConstraint;

@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, strong) UILabel *cellTitleLabel; // extra titleLabel

@end

@implementation XUIButtonCell

+ (BOOL)layoutNeedsTextLabel {
    return YES;
}

+ (BOOL)layoutNeedsImageView {
    return YES;
}

+ (NSDictionary <NSString *, Class> *)entryValueTypes {
    return
    @{
      @"action": [NSString class],
      @"args": [NSDictionary class],
      @"alignment": [NSString class],
      };
}

+ (BOOL)testValue:(id)value forKey:(NSString *)key error:(NSError **)error {
    if ([key isEqualToString:@"alignment"]) {
        if (NO == [@[@"Left", @"Right", @"Center", @"Natural", @"Justified"] containsObject:value])
        {
            NSString *errorReason
            = [NSString stringWithFormat:[XUIStrings localizedStringForString:@"key \"%@\" (\"%@\") is invalid."], @"alignment", value];
            NSError *exceptionError
            = [NSError errorWithDomain:kXUICellFactoryErrorUnknownEnumDomain code:400 userInfo:@{ NSLocalizedDescriptionKey: errorReason }];
            if (error) *error = exceptionError;
            return NO;
        }
    }
    return [super testValue:value forKey:key error:error];
}

- (void)setupCell {
    [super setupCell];
    
    _textAlignment = NSTextAlignmentLeft;
    
    self.cellTitleLabel.text = @"";
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    [self.contentView addSubview:self.cellTitleLabel];
    {
        XUI_START_IGNORE_PARTIAL
        NSArray <NSLayoutConstraint *> *constraints =
        @[
          [NSLayoutConstraint constraintWithItem:self.cellTitleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:(XUI_SYSTEM_9 ? NSLayoutAttributeLeadingMargin : NSLayoutAttributeLeading) multiplier:1.0 constant:(XUI_SYSTEM_9 ? 0.0 : 16.0)],
          [NSLayoutConstraint constraintWithItem:self.cellTitleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:(XUI_SYSTEM_9 ? NSLayoutAttributeTrailingMargin : NSLayoutAttributeTrailing) multiplier:1.0 constant:(XUI_SYSTEM_9 ? 0.0 : -16.0)],
          [NSLayoutConstraint constraintWithItem:self.cellTitleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0],
          ];
        XUI_END_IGNORE_PARTIAL
        [self.contentView addConstraints:constraints];
    }
    
    [self reloadVisibleLabel];
}

#pragma mark - UIView Getters

- (UILabel *)cellTitleLabel {
    if (!_cellTitleLabel) {
        _cellTitleLabel = [[UILabel alloc] init];
        if (@available(iOS 14.0, *)) {
            _cellTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
            _cellTitleLabel.adjustsFontForContentSizeCategory = YES;
        } else {
            _cellTitleLabel.font = [UIFont systemFontOfSize:16.f];
        }
        _cellTitleLabel.textAlignment = NSTextAlignmentLeft;
        _cellTitleLabel.numberOfLines = 1;
        _cellTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _cellTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _cellTitleLabel;
}

#pragma mark - Setters

- (void)setInternalTheme:(XUITheme *)theme {
    [super setInternalTheme:theme];
    if (theme.foregroundColor) {
        self.textLabel.textColor = theme.foregroundColor; // Button uses foregroundColor as its label color
        self.cellTitleLabel.textColor = theme.foregroundColor;
    } else {
        self.textLabel.textColor = self.tintColor;
        self.cellTitleLabel.textColor = self.tintColor;
    }
}

- (void)setXui_label:(NSString *)xui_label {
    [super setXui_label:xui_label];
    self.cellTitleLabel.text = self.adapter ? [self.adapter localizedString:xui_label] : xui_label;
}

- (void)setXui_alignment:(NSString *)xui_alignment {
    _xui_alignment = xui_alignment;
    NSTextAlignment textAlignment = NSTextAlignmentLeft;
    if ([xui_alignment isEqualToString:@"Left"]) {
        textAlignment = NSTextAlignmentLeft;
    }
    else if ([xui_alignment isEqualToString:@"Center"]) {
        textAlignment = NSTextAlignmentCenter;
    }
    else if ([xui_alignment isEqualToString:@"Right"]) {
        textAlignment = NSTextAlignmentRight;
    }
    else if ([xui_alignment isEqualToString:@"Natural"]) {
        textAlignment = NSTextAlignmentNatural;
    }
    else if ([xui_alignment isEqualToString:@"Justified"]) {
        textAlignment = NSTextAlignmentJustified;
    }
    else {
        textAlignment = NSTextAlignmentNatural;
    }
    _textAlignment = textAlignment;
    self.textLabel.textAlignment = textAlignment;
    self.cellTitleLabel.textAlignment = textAlignment;
    [self reloadVisibleLabel];
}

- (void)reloadVisibleLabel {
    BOOL needsExtraLabel = (self.textAlignment != NSTextAlignmentLeft);
    if (needsExtraLabel) {
        [self.imageView setHidden:YES];
        [self.textLabel setHidden:YES];
        [self.cellTitleLabel setHidden:NO];
    } else {
        [self.imageView setHidden:NO];
        [self.textLabel setHidden:NO];
        [self.cellTitleLabel setHidden:YES];
    }
}

@end
