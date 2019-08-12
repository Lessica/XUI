//
//  XUIStaticTextCell.m
//  XXTExplorer
//
//  Created by Zheng on 29/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIStaticTextCell.h"
#import "XUIPrivate.h"
#import "XUILogger.h"

static UIEdgeInsets const XUIStaticTextCellPadding = { 4.f, 0.f, 4.f, 0.f };

@interface XUIStaticTextCell ()

@property (strong, nonatomic) UITextView *cellStaticTextView;

@end

@implementation XUIStaticTextCell

+ (BOOL)layoutNeedsTextLabel {
    return NO;
}

+ (BOOL)layoutNeedsImageView {
    return NO;
}

+ (BOOL)layoutRequiresDynamicRowHeight {
    return YES;
}

+ (NSDictionary <NSString *, Class> *)entryValueTypes {
    return
    @{
      @"alignment": [NSString class],
      @"selectable": [NSNumber class],
      };
}

+ (BOOL)testValue:(id)value forKey:(NSString *)key error:(NSError **)error {
    if ([key isEqualToString:@"alignment"]) {
        if (NO == [@[ @"Left", @"Right", @"Center", @"Natural", @"Justified" ] containsObject:value]) {
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

#pragma mark - Setup

- (void)setupCell {
    [super setupCell];
    UITextView *textView = self.cellStaticTextView;
    textView.scrollEnabled = NO;
    if (XUI_SYSTEM_8) {
        textView.textContainerInset = XUIStaticTextCellPadding;
    }
    textView.textContainer.lineFragmentPadding = 0;
    textView.contentInset = UIEdgeInsetsZero;
    textView.backgroundColor = [UIColor clearColor];
    BOOL selectable = textView.selectable;
    textView.selectable = YES;
    textView.font = [UIFont systemFontOfSize:16.f];
    textView.selectable = selectable;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    {
        [self.contentView addSubview:self.cellStaticTextView];
        NSArray <NSLayoutConstraint *> *constraints =
        @[
          [NSLayoutConstraint constraintWithItem:self.cellStaticTextView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:16.0],
          [NSLayoutConstraint constraintWithItem:self.cellStaticTextView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-16.0],
          [NSLayoutConstraint constraintWithItem:self.cellStaticTextView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:8.0],
          [NSLayoutConstraint constraintWithItem:self.cellStaticTextView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-8.0],
          ];
        [self.contentView addConstraints:constraints];
    }
}

#pragma mark - UIView Getters

- (UITextView *)cellStaticTextView {
    if (!_cellStaticTextView) {
        _cellStaticTextView = [[UITextView alloc] init];
        _cellStaticTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _cellStaticTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        _cellStaticTextView.spellCheckingType = UITextSpellCheckingTypeNo;
        _cellStaticTextView.editable = NO;
        _cellStaticTextView.selectable = NO;
        _cellStaticTextView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _cellStaticTextView;
}

#pragma mark - Setters

- (void)setXui_label:(NSString *)xui_label {
    [super setXui_label:xui_label];
    self.cellStaticTextView.text = self.adapter ? [self.adapter localizedString:xui_label] : xui_label;
}

- (void)setXui_alignment:(NSString *)xui_alignment {
    _xui_alignment = xui_alignment;
    UITextView *textView = self.cellStaticTextView;
    BOOL selectable = textView.selectable;
    textView.selectable = YES;
    if ([xui_alignment isEqualToString:@"Left"]) {
        textView.textAlignment = NSTextAlignmentLeft;
    }
    else if ([xui_alignment isEqualToString:@"Center"]) {
        textView.textAlignment = NSTextAlignmentCenter;
    }
    else if ([xui_alignment isEqualToString:@"Right"]) {
        textView.textAlignment = NSTextAlignmentRight;
    }
    else if ([xui_alignment isEqualToString:@"Natural"]) {
        textView.textAlignment = NSTextAlignmentNatural;
    }
    else if ([xui_alignment isEqualToString:@"Justified"]) {
        textView.textAlignment = NSTextAlignmentJustified;
    }
    else {
        textView.textAlignment = NSTextAlignmentNatural;
    }
    textView.selectable = selectable;
}

- (void)setXui_selectable:(NSNumber *)xui_selectable {
    _xui_selectable = xui_selectable;
    self.cellStaticTextView.selectable = [xui_selectable boolValue];
}

- (void)setInternalTheme:(XUITheme *)theme {
    [super setInternalTheme:theme];
    self.cellStaticTextView.textColor = theme.labelColor;
    self.cellStaticTextView.tintColor = theme.foregroundColor;
    UIFont *newFont = [self.cellStaticTextView.font fontWithSize:[theme.labelFontSize floatValue]];
    self.cellStaticTextView.font = newFont;
}


@end
