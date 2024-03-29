//
//  XUIStepperCell.m
//  XXTExplorer
//
//  Created by Zheng on 04/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIStepperCell.h"
#import "XUIPrivate.h"
#import "XUILogger.h"
#import "XUIAdapter.h"

@interface XUIStepperCell ()

@property (strong, nonatomic) UIStepper *cellStepper;
@property (strong, nonatomic) UILabel *cellNumberLabel;
@property (strong, nonatomic) UILabel *cellTitleLabel;

@property (strong, nonatomic) NSLayoutConstraint *leftConstraint;
@property (strong, nonatomic) NSLayoutConstraint *middleConstraint;

@end

@implementation XUIStepperCell

@synthesize xui_value = _xui_value;

+ (BOOL)layoutNeedsTextLabel {
    return NO;
}

+ (BOOL)layoutNeedsImageView {
    return NO;
}

+ (BOOL)layoutRequiresDynamicRowHeight {
    return NO;
}

+ (NSDictionary <NSString *, Class> *)entryValueTypes {
    return
    @{
      @"min": [NSNumber class],
      @"max": [NSNumber class],
      @"step": [NSNumber class],
      @"value": [NSNumber class],
      @"autoRepeat": [NSNumber class],
      @"isInteger": [NSNumber class]
      };
}

#pragma mark - Setup

- (void)setupCell {
    [super setupCell];
    
    _xui_min = @(0);
    _xui_max = @(100);
    _xui_step = @(1);
    _xui_value = @(0);
    _xui_isInteger = @(NO);
    _xui_autoRepeat = @(YES);
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.cellTitleLabel.text = @"";
    self.cellStepper.alpha = 1.0;
    [self.cellStepper addTarget:self action:@selector(xuiStepperValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.cellStepper addTarget:self action:@selector(xuiStepperValueDidFinishChanging:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.cellTitleLabel];
    [self.contentView addSubview:self.cellNumberLabel];
    [self.contentView addSubview:self.cellStepper];
    
    {
        XUI_START_IGNORE_PARTIAL
        self.leftConstraint = [NSLayoutConstraint constraintWithItem:self.cellTitleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:(XUI_SYSTEM_9 ? NSLayoutAttributeLeadingMargin : NSLayoutAttributeLeading) multiplier:1.0 constant:(XUI_SYSTEM_9 ? 0.0 : 20.0)];
        XUI_END_IGNORE_PARTIAL
        NSArray <NSLayoutConstraint *> *constraints =
        @[
          self.leftConstraint,
          [NSLayoutConstraint constraintWithItem:self.cellTitleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0],
          [NSLayoutConstraint constraintWithItem:self.cellTitleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.cellStepper attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-16.0],
          ];
        [self.contentView addConstraints:constraints];
    }
    {
        self.middleConstraint = [NSLayoutConstraint constraintWithItem:self.cellNumberLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.cellTitleLabel attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:16.0];
        NSArray <NSLayoutConstraint *> *constraints =
        @[
          self.middleConstraint,
          [NSLayoutConstraint constraintWithItem:self.cellNumberLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.cellStepper attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-16.0],
          [NSLayoutConstraint constraintWithItem:self.cellNumberLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0],
          ];
        [self.contentView addConstraints:constraints];
    }
    {
        NSArray <NSLayoutConstraint *> *constraints =
        @[
          [NSLayoutConstraint constraintWithItem:self.cellStepper attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-16.0],
          [NSLayoutConstraint constraintWithItem:self.cellStepper attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0],
          ];
        [self.contentView addConstraints:constraints];
    }
    [self reloadLeftConstraints];
}

- (void)reloadLeftConstraints {
    self.leftConstraint.constant = (XUI_SYSTEM_9 ? 0.0 : self.separatorInset.left);
    if (self.cellTitleLabel.text.length == 0) {
        self.middleConstraint.constant = 0.0;
        [self.cellTitleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self.cellNumberLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    } else {
        self.middleConstraint.constant = 16.0;
        [self.cellTitleLabel setContentCompressionResistancePriority:500 forAxis:UILayoutConstraintAxisHorizontal];
        [self.cellNumberLabel setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    }
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

- (UILabel *)cellNumberLabel {
    if (!_cellNumberLabel) {
        _cellNumberLabel = [[UILabel alloc] init];
        _cellNumberLabel.numberOfLines = 1;
        _cellNumberLabel.textAlignment = NSTextAlignmentRight;
        if (@available(iOS 14.0, *)) {
            _cellNumberLabel.font = [UIFont monospacedDigitSystemFontOfSize:[UIFont preferredFontForTextStyle:UIFontTextStyleBody].pointSize weight:UIFontWeightRegular];
            _cellNumberLabel.adjustsFontForContentSizeCategory = YES;
        } else {
            XUI_START_IGNORE_PARTIAL
            if (XUI_SYSTEM_9) {
                _cellNumberLabel.font = [UIFont monospacedDigitSystemFontOfSize:16.0 weight:UIFontWeightRegular];
            } else {
                _cellNumberLabel.font = [UIFont systemFontOfSize:16.0];
            }
            XUI_END_IGNORE_PARTIAL
        }
        _cellNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _cellNumberLabel;
}

- (UIStepper *)cellStepper {
    if (!_cellStepper) {
        _cellStepper = [[UIStepper alloc] init];
        _cellStepper.wraps = NO;
        _cellStepper.continuous = YES;
        _cellStepper.autorepeat = YES;
        _cellStepper.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _cellStepper;
}

#pragma mark - Setters

- (void)setXui_readonly:(NSNumber *)xui_readonly {
    [super setXui_readonly:xui_readonly];
    BOOL readonly = [xui_readonly boolValue];
    self.cellStepper.enabled = !readonly;
    if (readonly) {
        self.cellStepper.alpha = 0.5;
    } else {
        self.cellStepper.alpha = 1.0;
    }
}

- (void)setXui_value:(id)xui_value {
    _xui_value = xui_value;
    double value = [xui_value doubleValue];
    self.cellStepper.value = value;
    [self xuiSetDisplayValue:value];
}

- (void)setXui_label:(NSString *)xui_label {
    [super setXui_label:xui_label];
    self.cellTitleLabel.text = self.adapter ? [self.adapter localizedString:xui_label] : xui_label;
    [self reloadLeftConstraints];
}

- (void)setXui_min:(NSNumber *)xui_min {
    _xui_min = xui_min;
    self.cellStepper.minimumValue = [xui_min doubleValue];
}

- (void)setXui_max:(NSNumber *)xui_max {
    _xui_max = xui_max;
    self.cellStepper.maximumValue = [xui_max doubleValue];
}

- (void)setXui_step:(NSNumber *)xui_step {
    _xui_step = xui_step;
    self.cellStepper.stepValue = [xui_step doubleValue];
}

- (void)setXui_autoRepeat:(NSNumber *)xui_autoRepeat {
    _xui_autoRepeat = xui_autoRepeat;
    self.cellStepper.autorepeat = [xui_autoRepeat boolValue];
}

- (IBAction)xuiStepperValueChanged:(UIStepper *)sender {
    if (sender == self.cellStepper) {
        [self xuiSetDisplayValue:sender.value];
    }
}

- (IBAction)xuiStepperValueDidFinishChanging:(UIStepper *)sender {
    if (sender == self.cellStepper) {
        self.xui_value = @(sender.value);
        [self.adapter saveDefaultsFromCell:self];
        [self xuiSetDisplayValue:sender.value];
    }
}

- (void)xuiSetDisplayValue:(double)value {
    if ([self.xui_isInteger boolValue]) {
        self.cellNumberLabel.text = [NSString stringWithFormat:@"%d", (int)value];
    } else {
        self.cellNumberLabel.text = [NSString stringWithFormat:@"%.2f", value];
    }
}

- (void)setInternalTheme:(XUITheme *)theme {
    [super setInternalTheme:theme];
    if (theme.foregroundColor) {
        self.cellStepper.tintColor = theme.foregroundColor;
        if (@available(iOS 13.0, *)) {
            [self updateStepperAppearanceWithTraitCollection:self.traitCollection];
        }
    }
    if (@available(iOS 13.0, *)) {
        self.cellNumberLabel.textColor = theme.valueColor ?: [UIColor secondaryLabelColor];
        self.cellTitleLabel.textColor = theme.labelColor ?: [UIColor labelColor];
    } else {
        if (theme.valueColor) {
            self.cellNumberLabel.textColor = theme.valueColor;
        }
        if (theme.labelColor) {
            self.cellTitleLabel.textColor = theme.labelColor;
        }
    }
}

- (void)updateStepperAppearanceWithTraitCollection:(UITraitCollection *)traitCollection API_AVAILABLE(ios(13.0))
{
    if (@available(iOS 13.0, *)) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            UIImage *decrementImage = [self.cellStepper decrementImageForState:UIControlStateHighlighted];
            UIImage *incrementImage = [self.cellStepper incrementImageForState:UIControlStateHighlighted];
            decrementImage = [[decrementImage imageWithTintColor:[UIColor whiteColor]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            incrementImage = [[incrementImage imageWithTintColor:[UIColor whiteColor]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [self.cellStepper setDecrementImage:decrementImage forState:UIControlStateHighlighted];
            [self.cellStepper setIncrementImage:incrementImage forState:UIControlStateHighlighted];
        } else {
            [self.cellStepper setDecrementImage:nil forState:UIControlStateNormal];
            [self.cellStepper setIncrementImage:nil forState:UIControlStateNormal];
            [self.cellStepper setDecrementImage:nil forState:UIControlStateHighlighted];
            [self.cellStepper setIncrementImage:nil forState:UIControlStateHighlighted];
        }
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection API_AVAILABLE(ios(8.0))
{
    if (@available(iOS 13.0, *)) {
        [self updateStepperAppearanceWithTraitCollection:self.traitCollection];
    }
}

@end
