//
//  XUIDateTimeCell.m
//  XXTExplorer
//
//  Created by Zheng on 16/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIDateTimeCell.h"
#import "XUIPrivate.h"

@interface XUIDateTimeCell ()

@property (weak, nonatomic) IBOutlet UIDatePicker *dateTimePicker;
@property (assign, nonatomic) BOOL shouldUpdateValue;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation XUIDateTimeCell

@synthesize xui_value = _xui_value, xui_height = _xui_height;

+ (BOOL)xibBasedLayout {
    return YES;
}

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
      @"mode": [NSString class],
      @"minuteInterval": [NSNumber class],
      @"max": [NSNumber class],
      @"min": [NSNumber class],
      @"format": [NSString class],
//      @"value": [NSNumber class]
      };
}

+ (BOOL)testEntry:(NSDictionary *)cellEntry withError:(NSError **)error {
    BOOL superResult = [super testEntry:cellEntry withError:error];
    return superResult;
}

- (void)setupCell {
    [super setupCell];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _xui_height = @(217.0);
    
    self.dateTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.dateTimePicker.minuteInterval = 1;
    self.dateTimePicker.date = [NSDate date];
    
    [self.dateTimePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (NSNumber *)xui_height {
    if (XUI_SYSTEM_8) {
        return _xui_height;
    } else {
        return @(217.0);
    }
}

- (void)setXui_format:(NSString *)xui_format {
    _xui_format = xui_format;
    if (xui_format.length) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setDateFormat:xui_format];
        _dateFormatter = dateFormatter;
    } else {
        _dateFormatter = nil;
    }
}

- (void)setXui_readonly:(NSNumber *)xui_readonly {
    [super setXui_readonly:xui_readonly];
    BOOL readonly = [xui_readonly boolValue];
    self.dateTimePicker.enabled = !readonly;
}

- (void)setXui_mode:(NSString *)xui_mode {
    _xui_mode = xui_mode;
    if ([xui_mode isEqualToString:@"date"])
    {
        self.dateTimePicker.datePickerMode = UIDatePickerModeDate;
    }
    else if ([xui_mode isEqualToString:@"time"])
    {
        self.dateTimePicker.datePickerMode = UIDatePickerModeTime;
    }
    else if ([xui_mode isEqualToString:@"datetime"])
    {
        self.dateTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    else if ([xui_mode isEqualToString:@"interval"])
    {
        self.dateTimePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    }
    [self updateValueIfNeeded];
}

- (void)setXui_minuteInterval:(NSNumber *)xui_minuteInterval {
    _xui_minuteInterval = xui_minuteInterval;
    self.dateTimePicker.minuteInterval = [xui_minuteInterval integerValue];
    [self updateValueIfNeeded];
}

- (void)setXui_max:(NSNumber *)xui_max {
    _xui_max = xui_max;
    NSDate *maximumDate = [NSDate dateWithTimeIntervalSince1970:[xui_max doubleValue]];
    self.dateTimePicker.maximumDate = maximumDate;
    [self updateValueIfNeeded];
}

- (void)setXui_min:(NSNumber *)xui_min {
    _xui_min = xui_min;
    NSDate *minimumDate = [NSDate dateWithTimeIntervalSince1970:[xui_min doubleValue]];
    self.dateTimePicker.minimumDate = minimumDate;
    [self updateValueIfNeeded];
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
        id xuiValue = self.xui_value;
        if ([self.xui_mode isEqualToString:@"interval"]) {
            if ([xuiValue isKindOfClass:[NSNumber class]]) {
                NSTimeInterval duration = [self.xui_value doubleValue];
                self.dateTimePicker.countDownDuration = duration;
            }
        } else {
            if (self.dateFormatter) {
                if ([xuiValue isKindOfClass:[NSString class]]) {
                    NSDate *savedDate = [self.dateFormatter dateFromString:xuiValue];
                    if (!savedDate) {
                        savedDate = [NSDate date];
                    }
                    self.dateTimePicker.date = savedDate;
                }
            } else {
                if ([xuiValue isKindOfClass:[NSNumber class]]) {
                    NSTimeInterval timestamp = [xuiValue doubleValue];
                    NSDate *valueDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    self.dateTimePicker.date = valueDate;
                }
            }
        }
    }
}

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender {
    if (sender == self.dateTimePicker) {
        if ([self.xui_mode isEqualToString:@"interval"]) {
            NSTimeInterval duration = sender.countDownDuration;
            self.xui_value = @(duration);
            [self.adapter saveDefaultsFromCell:self];
        } else {
            NSDate *toDate = sender.date;
            if (self.dateFormatter) {
                NSString *savedDate = [self.dateFormatter stringFromDate:toDate];
                self.xui_value = savedDate;
            } else {
                NSTimeInterval toInterval = [toDate timeIntervalSince1970];
                self.xui_value = @(toInterval);
            }
            [self.adapter saveDefaultsFromCell:self];
        }
    }
}

- (void)setInternalTheme:(XUITheme *)theme {
    [super setInternalTheme:theme];
    UIDatePicker *picker = self.dateTimePicker;
    picker.tintColor = theme.foregroundColor;
    [picker setValue:theme.labelColor forKeyPath:@"textColor"];
}

@end
