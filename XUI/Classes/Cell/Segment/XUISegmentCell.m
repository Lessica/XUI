//
//  XUISegmentCell.m
//  XXTExplorer
//
//  Created by Zheng on 30/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUISegmentCell.h"

#import "XUIPrivate.h"
#import "XUILogger.h"
#import "XUIOptionModel.h"

@interface XUISegmentCell ()

@property (strong, nonatomic) UISegmentedControl *cellSegmentControl;
@property (strong, nonatomic) UILabel *cellTitleLabel;
@property (strong, nonatomic) NSLayoutConstraint *leftConstraint;

@property (assign, nonatomic) BOOL shouldUpdateValue;

@end

@implementation XUISegmentCell

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
      @"options": [NSArray class],
      };
}

+ (NSDictionary <NSString *, Class> *)optionValueTypes {
    return
    @{
      XUIOptionTitleKey: [NSString class],
      XUIOptionShortTitleKey: [NSString class],
      XUIOptionIconKey: [NSString class],
      };
}

#pragma mark - Setup

- (void)setupCell {
    [super setupCell];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.cellTitleLabel.text = @"";
    [self.cellSegmentControl addTarget:self action:@selector(xuiSegmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.contentView addSubview:self.cellTitleLabel];
    [self.contentView addSubview:self.cellSegmentControl];
    {
        self.leftConstraint = [NSLayoutConstraint constraintWithItem:self.cellTitleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:(XUI_SYSTEM_8 ? NSLayoutAttributeLeadingMargin : NSLayoutAttributeLeading) multiplier:1.0 constant:(XUI_SYSTEM_8 ? 0.0 : 20.0)];
        NSArray <NSLayoutConstraint *> *constraints =
        @[
          self.leftConstraint,
          [NSLayoutConstraint constraintWithItem:self.cellTitleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.cellSegmentControl attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-16.0],
          [NSLayoutConstraint constraintWithItem:self.cellTitleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0],
          ];
        [self.contentView addConstraints:constraints];
    }
    {
        NSArray <NSLayoutConstraint *> *constraints =
        @[
          [NSLayoutConstraint constraintWithItem:self.cellSegmentControl attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-16.0],
          [NSLayoutConstraint constraintWithItem:self.cellSegmentControl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0],
          ];
        [self.contentView addConstraints:constraints];
    }
    [self reloadLeftConstraints];
}

- (void)reloadLeftConstraints {
    if (self.cellTitleLabel.text.length == 0) {
        self.leftConstraint.constant = 0.0;
        [self.cellTitleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self.cellSegmentControl setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    } else {
        self.leftConstraint.constant = (XUI_SYSTEM_8 ? 0.0 : self.separatorInset.left);
        [self.cellTitleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [self.cellSegmentControl setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
}

#pragma mark - UIView Getters

- (UISegmentedControl *)cellSegmentControl {
    if (!_cellSegmentControl) {
        _cellSegmentControl = [[UISegmentedControl alloc] init];
        _cellSegmentControl.momentary = NO;
        _cellSegmentControl.apportionsSegmentWidthsByContent = NO;
        _cellSegmentControl.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _cellSegmentControl;
}

- (UILabel *)cellTitleLabel {
    if (!_cellTitleLabel) {
        _cellTitleLabel = [[UILabel alloc] init];
        XUI_START_IGNORE_PARTIAL
        if (XUI_SYSTEM_8_2) {
            _cellTitleLabel.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightLight];
        } else {
            _cellTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.f];
        }
        XUI_END_IGNORE_PARTIAL
        _cellTitleLabel.textAlignment = NSTextAlignmentLeft;
        _cellTitleLabel.numberOfLines = 1;
        _cellTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _cellTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _cellTitleLabel;
}

#pragma mark - Setters

- (void)setXui_options:(NSArray<NSDictionary *> *)xui_options {
    for (NSDictionary *pair in xui_options) {
        for (NSString *pairKey in pair.allKeys) {
            Class pairClass = [[self class] optionValueTypes][pairKey];
            if (pairClass) {
                if (![pair[pairKey] isKindOfClass:pairClass]) {
                    return; // invalid option, ignore
                }
            }
        }
    }
    _xui_options = xui_options;
    [self.cellSegmentControl removeAllSegments];
    NSUInteger titleIdx = 0;
    for (NSDictionary *option in xui_options) {
        NSString *validTitle = option[XUIOptionTitleKey];
        NSString *localizedTitle = [self.adapter localizedStringForKey:validTitle value:validTitle];
        [self.cellSegmentControl insertSegmentWithTitle:localizedTitle atIndex:titleIdx animated:NO];
        titleIdx++;
    }
    if (self.xui_value) {
        NSInteger selectedIdx = [self.xui_value integerValue];
        [self.cellSegmentControl setSelectedSegmentIndex:selectedIdx];
    }
    [self updateValueIfNeeded];
}

- (void)setXui_label:(NSString *)xui_label {
    [super setXui_label:xui_label];
    self.cellTitleLabel.text = self.adapter ? [self.adapter localizedString:xui_label] : xui_label;
    [self reloadLeftConstraints];
}

- (void)setXui_value:(id)xui_value {
    _xui_value = xui_value;
    [self setNeedsUpdateValue];
    [self updateValueIfNeeded];
}

- (void)setNeedsUpdateValue {
    self.shouldUpdateValue = YES;
}

- (void)updateValueIfNeeded {
    if (self.shouldUpdateValue) {
        self.shouldUpdateValue = NO;
        id xui_value = self.xui_value;
        if (xui_value) {
            NSUInteger selectedIndex = [self.xui_options indexOfObjectPassingTest:^BOOL(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([xui_value isEqual:obj[XUIOptionValueKey]]) {
                    return YES;
                }
                return NO;
            }];
            if (selectedIndex != NSNotFound) {
                if (self.cellSegmentControl.numberOfSegments > selectedIndex) {
                    [self.cellSegmentControl setSelectedSegmentIndex:selectedIndex];
                }
            }
        }
    }
}

- (void)setXui_readonly:(NSNumber *)xui_readonly {
    [super setXui_readonly:xui_readonly];
    BOOL readonly = [xui_readonly boolValue];
    self.cellSegmentControl.enabled = !readonly;
}

- (void)setInternalTheme:(XUITheme *)theme {
    [super setInternalTheme:theme];
    self.cellSegmentControl.tintColor = theme.foregroundColor;
    self.cellTitleLabel.textColor = theme.labelColor;
}

#pragma mark - Actions

- (void)xuiSegmentValueChanged:(UISegmentedControl *)sender {
    if (sender == self.cellSegmentControl) {
        NSUInteger selectedIndex = sender.selectedSegmentIndex;
        if (selectedIndex < self.xui_options.count) {
            id selectedValue = self.xui_options[selectedIndex][XUIOptionValueKey];
            self.xui_value = selectedValue;
            [self.adapter saveDefaultsFromCell:self];
        }
    }
}

@end
