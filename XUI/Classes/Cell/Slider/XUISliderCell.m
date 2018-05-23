//
//  XUISliderCell.m
//  XXTExplorer
//
//  Created by Zheng on 29/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUISliderCell.h"
#import "XUIPrivate.h"
#import "XUILogger.h"

@interface XUISliderCell ()

@property (strong, nonatomic) UISlider *cellSlider;
@property (strong, nonatomic) UILabel *cellSliderValueLabel;
@property (strong, nonatomic) NSLayoutConstraint *cellSliderValueLabelWidth;
@property (assign, nonatomic) BOOL shouldUpdateValue;

@end

@implementation XUISliderCell

@synthesize xui_value = _xui_value;

+ (BOOL)layoutNeedsTextLabel {
    return NO;
}

+ (BOOL)layoutNeedsImageView {
    return NO;
}

+ (NSDictionary <NSString *, Class> *)entryValueTypes {
    return
    @{
      @"min": [NSNumber class],
      @"max": [NSNumber class],
      @"showValue": [NSNumber class],
      @"value": [NSNumber class]
      };
}

#pragma mark - Setup

- (void)setupCell {
    [super setupCell];
    
    _xui_step = @(0);
    _xui_min = @(0);
    _xui_max = @(1.0);
    _xui_value = @(0.0);
    _xui_showValue = @(NO);
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.cellSlider addTarget:self action:@selector(xuiSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.cellSlider addTarget:self action:@selector(xuiSliderValueDidFinishChanging:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.cellSliderValueLabel];
    [self.contentView addSubview:self.cellSlider];
    {
        self.cellSliderValueLabelWidth = [NSLayoutConstraint constraintWithItem:self.cellSliderValueLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
        XUI_START_IGNORE_PARTIAL
        NSArray <NSLayoutConstraint *> *constraints =
        @[
          self.cellSliderValueLabelWidth,
          [NSLayoutConstraint constraintWithItem:self.cellSliderValueLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:(XUI_SYSTEM_8 ? NSLayoutAttributeLeadingMargin : NSLayoutAttributeLeading) multiplier:1.0 constant:(XUI_SYSTEM_8 ? 0.0 : 16.0)],
          [NSLayoutConstraint constraintWithItem:self.cellSliderValueLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0],
          [NSLayoutConstraint constraintWithItem:self.cellSliderValueLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.cellSlider attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-8.0],
          ];
        XUI_END_IGNORE_PARTIAL
        [self.contentView addConstraints:constraints];
    }
    {
        NSArray <NSLayoutConstraint *> *constraints =
        @[
          [NSLayoutConstraint constraintWithItem:self.cellSlider attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-16.0],
          [NSLayoutConstraint constraintWithItem:self.cellSlider attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0],
          ];
        [self.contentView addConstraints:constraints];
    }
}

#pragma mark - UIView Getters

- (UISlider *)cellSlider {
    if (!_cellSlider) {
        _cellSlider = [[UISlider alloc] init];
        _cellSlider.minimumValue = 0.0;
        _cellSlider.maximumValue = 1.0;
        _cellSlider.value = 0.0;
        _cellSlider.continuous = YES;
        _cellSlider.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _cellSlider;
}

- (UILabel *)cellSliderValueLabel {
    if (!_cellSliderValueLabel) {
        _cellSliderValueLabel = [[UILabel alloc] init];
        _cellSliderValueLabel.numberOfLines = 1;
        _cellSliderValueLabel.textAlignment = NSTextAlignmentCenter;
        XUI_START_IGNORE_PARTIAL
        if (XUI_SYSTEM_9) {
            _cellSliderValueLabel.font = [UIFont monospacedDigitSystemFontOfSize:16.0 weight:UIFontWeightLight];
        } else if (XUI_SYSTEM_8_2) {
            _cellSliderValueLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightLight];
        } else {
            _cellSliderValueLabel.font = [UIFont systemFontOfSize:16.0];
        }
        XUI_END_IGNORE_PARTIAL
        _cellSliderValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _cellSliderValueLabel;
}

#pragma mark - Setters

- (void)setXui_readonly:(NSNumber *)xui_readonly {
    [super setXui_readonly:xui_readonly];
    BOOL readonly = [xui_readonly boolValue];
    self.cellSlider.enabled = !readonly;
}

- (void)setXui_value:(id)xui_value {
    _xui_value = xui_value;
    [self setNeedsUpdateValue];
    [self updateValueIfNeeded];
}

- (void)setXui_min:(NSNumber *)xui_min {
    _xui_min = xui_min;
    self.cellSlider.minimumValue = [xui_min floatValue];
    [self updateValueIfNeeded];
}

- (void)setXui_max:(NSNumber *)xui_max {
    _xui_max = xui_max;
    self.cellSlider.maximumValue = [xui_max floatValue];
    [self updateValueIfNeeded];
}

- (void)setXui_step:(NSNumber *)xui_step {
    _xui_step = xui_step;
    [self updateValueIfNeeded];
}

- (void)setXui_showValue:(NSNumber *)xui_showValue {
    _xui_showValue = xui_showValue;
    BOOL showValue = [xui_showValue boolValue];
    if (showValue) {
        self.cellSliderValueLabelWidth.constant = 64.f;
    } else {
        self.cellSliderValueLabelWidth.constant = 0.f;
    }
}

- (void)xuiSliderValueChanged:(UISlider *)sender {
    if (sender == self.cellSlider) {
        float value = sender.value;
        float stepValue = [self.xui_step floatValue];
        if (stepValue > 0.f) {
            float newStep = roundf((value) / stepValue);
            value = newStep * stepValue;
            sender.value = value;
        }
        self.cellSliderValueLabel.text = [NSString stringWithFormat:@"%.2f", value];
    }
}

- (void)xuiSliderValueDidFinishChanging:(UISlider *)sender {
    if (sender == self.cellSlider) {
        self.xui_value = @(sender.value);
        [self.adapter saveDefaultsFromCell:self];
        self.cellSliderValueLabel.text = [NSString stringWithFormat:@"%.2f", sender.value];
    }
}

- (void)setInternalTheme:(XUITheme *)theme {
    [super setInternalTheme:theme];
    self.cellSliderValueLabel.textColor = theme.valueColor;
    self.cellSlider.minimumTrackTintColor = theme.foregroundColor;
    self.cellSlider.tintColor = theme.thumbTintColor;
    if (NO == [theme.thumbTintColor isEqual:[UIColor whiteColor]]) {
        self.cellSlider.thumbTintColor = theme.thumbTintColor;
    }
}

- (void)setNeedsUpdateValue {
    self.shouldUpdateValue = YES;
}

- (void)updateValueIfNeeded {
    if (self.shouldUpdateValue) {
        self.shouldUpdateValue = NO;
        float value = [self.xui_value floatValue];
        float stepValue = [self.xui_step floatValue];
        if (stepValue > 0.f) {
            float newStep = roundf((value) / stepValue);
            value = newStep * stepValue;
        }
        self.cellSlider.value = value;
        self.cellSliderValueLabel.text = [NSString stringWithFormat:@"%.2f", value];
    }
}

@end
