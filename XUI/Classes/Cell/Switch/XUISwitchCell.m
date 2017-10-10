//
//  XUISwitchCell.m
//  XXTExplorer
//
//  Created by Zheng on 28/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUISwitchCell.h"

@interface XUISwitchCell ()

@property (weak, nonatomic) IBOutlet UISwitch *cellSwitch;
@property (assign, nonatomic) BOOL shouldUpdateValue;

@end

@implementation XUISwitchCell

@synthesize xui_value = _xui_value;

+ (BOOL)xibBasedLayout {
    return YES;
}

+ (BOOL)layoutNeedsTextLabel {
    return YES;
}

+ (BOOL)layoutNeedsImageView {
    return YES;
}

+ (NSDictionary <NSString *, Class> *)entryValueTypes {
    return
    @{
      @"negate": [NSNumber class],
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
    [self.cellSwitch addTarget:self action:@selector(xuiSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setXui_value:(id)xui_value {
    _xui_value = xui_value;
    [self setNeedsUpdateValue];
    [self updateValueIfNeeded];
}

- (void)setXui_readonly:(NSNumber *)xui_readonly {
    [super setXui_readonly:xui_readonly];
    BOOL readonly = [xui_readonly boolValue];
    self.cellSwitch.enabled = !readonly;
}

- (void)setXui_negate:(NSNumber *)xui_negate {
    _xui_negate = xui_negate;
    [self updateValueIfNeeded];
}

- (IBAction)xuiSwitchValueChanged:(UISwitch *)sender {
    if (sender == self.cellSwitch) {
        self.xui_value = [self.xui_negate boolValue] ? @(!(BOOL)sender.on) : @((BOOL)sender.on);
        [self.adapter saveDefaultsFromCell:self];
    }
}

- (void)setTheme:(XUITheme *)theme {
    [super setTheme:theme];
    self.cellSwitch.onTintColor = theme.successColor;
}

- (void)setNeedsUpdateValue {
    self.shouldUpdateValue = YES;
}

- (void)updateValueIfNeeded {
    if (self.shouldUpdateValue) {
        self.shouldUpdateValue = NO;
        BOOL value = [self.xui_value boolValue];
        self.cellSwitch.on = [self.xui_negate boolValue] ? !value : value;
    }
}

@end
