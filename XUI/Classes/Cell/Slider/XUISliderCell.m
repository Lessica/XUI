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

@property (weak, nonatomic) IBOutlet UISlider *cellSlider;
@property (weak, nonatomic) IBOutlet UILabel *cellSliderValueLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellSliderValueLabelWidth;
@property (assign, nonatomic) BOOL shouldUpdateValue;

@end

@implementation XUISliderCell

@synthesize xui_value = _xui_value;

+ (BOOL)xibBasedLayout {
    return YES;
}

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

+ (BOOL)testEntry:(NSDictionary *)cellEntry withError:(NSError **)error {
    BOOL superResult = [super testEntry:cellEntry withError:error];
    return superResult;
}

- (void)setupCell {
    [super setupCell];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.cellSlider addTarget:self action:@selector(xuiSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.cellSlider addTarget:self action:@selector(xuiSliderValueDidFinishChanging:) forControlEvents:UIControlEventTouchUpInside];
}

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

- (void)setXui_showValue:(NSNumber *)xui_showValue {
    _xui_showValue = xui_showValue;
    BOOL showValue = [xui_showValue boolValue];
    if (showValue) {
        self.cellSliderValueLabelWidth.constant = 64.f;
    } else {
        self.cellSliderValueLabelWidth.constant = 0.f;
    }
}

- (IBAction)xuiSliderValueChanged:(UISlider *)sender {
    if (sender == self.cellSlider) {
        self.cellSliderValueLabel.text = [NSString stringWithFormat:@"%.2f", sender.value];
    }
}

- (IBAction)xuiSliderValueDidFinishChanging:(UISlider *)sender {
    if (sender == self.cellSlider) {
        self.xui_value = @(sender.value);
        [self.adapter saveDefaultsFromCell:self];
        self.cellSliderValueLabel.text = [NSString stringWithFormat:@"%.2f", sender.value];
    }
}

- (void)setTheme:(XUITheme *)theme {
    [super setTheme:theme];
    self.cellSliderValueLabel.textColor = theme.valueColor;
    self.cellSlider.minimumTrackTintColor = theme.successColor;
}

- (void)setNeedsUpdateValue {
    self.shouldUpdateValue = YES;
}

- (void)updateValueIfNeeded {
    if (self.shouldUpdateValue) {
        self.shouldUpdateValue = NO;
        float value = [self.xui_value floatValue];
        self.cellSlider.value = value;
        self.cellSliderValueLabel.text = [NSString stringWithFormat:@"%.2f", value];
    }
}

@end
