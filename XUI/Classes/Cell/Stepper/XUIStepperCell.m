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

@end

@implementation XUIStepperCell

@synthesize xui_value = _xui_value;

+ (BOOL)xibBasedLayout {
    return NO;
}

+ (BOOL)layoutNeedsTextLabel {
    return YES;
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

+ (BOOL)testEntry:(NSDictionary *)cellEntry withError:(NSError **)error {
    BOOL superResult = [super testEntry:cellEntry withError:error];
    if (superResult) {
        NSString *checkType = kXUICellFactoryErrorDomain;
        double minValue = [cellEntry[@"min"] doubleValue];
        double maxValue = [cellEntry[@"max"] doubleValue];
        if (minValue > maxValue) {
            checkType = kXUICellFactoryErrorInvalidValueDomain;
            NSString *errorReason = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"the value \"%@\" of key \"%@\" is invalid.", nil, FRAMEWORK_BUNDLE, nil), cellEntry[@"maxValue"], @"maxValue"];
            NSError *exceptionError = [NSError errorWithDomain:checkType code:400 userInfo:@{ NSLocalizedDescriptionKey: errorReason }];
            if (error) *error = exceptionError;
            return NO;
        }
    }
    return superResult;
}

#pragma mark - Setup

- (void)setupCell {
    [super setupCell];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.cellStepper addTarget:self action:@selector(xuiStepperValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.cellStepper addTarget:self action:@selector(xuiStepperValueDidFinishChanging:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.cellNumberLabel];
    [self.contentView addSubview:self.cellStepper];
    {
        NSLayoutConstraint *labelConstraint = [NSLayoutConstraint constraintWithItem:self.cellNumberLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.textLabel attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:16.0];
        NSArray <NSLayoutConstraint *> *constraints =
        @[
          labelConstraint,
          [NSLayoutConstraint constraintWithItem:self.cellNumberLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.cellStepper attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-16.0],
          [NSLayoutConstraint constraintWithItem:self.cellNumberLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0],
          ];
        [self.contentView addConstraints:constraints];
    }
    {
        NSArray <NSLayoutConstraint *> *constraints =
        @[
          [NSLayoutConstraint constraintWithItem:self.cellStepper attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-20.0],
          [NSLayoutConstraint constraintWithItem:self.cellStepper attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0],
          ];
        [self.contentView addConstraints:constraints];
    }
}

#pragma mark - UIView Getters

- (UILabel *)cellNumberLabel {
    if (!_cellNumberLabel) {
        _cellNumberLabel = [[UILabel alloc] init];
        _cellNumberLabel.numberOfLines = 1;
        _cellNumberLabel.textAlignment = NSTextAlignmentRight;
        XUI_START_IGNORE_PARTIAL
        if (XUI_SYSTEM_9) {
            _cellNumberLabel.font = [UIFont monospacedDigitSystemFontOfSize:16.0 weight:UIFontWeightLight];
        } else if (XUI_SYSTEM_8_2) {
            _cellNumberLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightLight];
        } else {
            _cellNumberLabel.font = [UIFont systemFontOfSize:16.0];
        }
        XUI_END_IGNORE_PARTIAL
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
}

- (void)setXui_value:(id)xui_value {
    _xui_value = xui_value;
    double value = [xui_value doubleValue];
    self.cellStepper.value = value;
    [self xuiSetDisplayValue:value];
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
    self.cellStepper.tintColor = theme.foregroundColor;
    self.cellNumberLabel.textColor = theme.valueColor;
}

@end
