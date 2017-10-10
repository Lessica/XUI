//
//  XUISegmentCell.m
//  XXTExplorer
//
//  Created by Zheng on 30/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUISegmentCell.h"
#import "XUILogger.h"
#import "XUIOptionModel.h"

@interface XUISegmentCell ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *cellSegmentControl;
@property (assign, nonatomic) BOOL shouldUpdateValue;

@end

@implementation XUISegmentCell

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

+ (BOOL)layoutRequiresDynamicRowHeight {
    return NO;
}

+ (NSDictionary <NSString *, Class> *)entryValueTypes {
    return
    @{
      @"options": [NSArray class]
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

+ (BOOL)testEntry:(NSDictionary *)cellEntry withError:(NSError **)error {
    BOOL superResult = [super testEntry:cellEntry withError:error];
    return superResult;
}

- (void)setupCell {
    [super setupCell];
    
    [self.cellSegmentControl addTarget:self action:@selector(xuiSegmentValueChanged:) forControlEvents:UIControlEventValueChanged];
}

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

- (IBAction)xuiSegmentValueChanged:(UISegmentedControl *)sender {
    if (sender == self.cellSegmentControl) {
        NSUInteger selectedIndex = sender.selectedSegmentIndex;
        if (selectedIndex < self.xui_options.count) {
            id selectedValue = self.xui_options[selectedIndex][XUIOptionValueKey];
            self.xui_value = selectedValue;
            [self.adapter saveDefaultsFromCell:self];
        }
    }
}

- (void)setTheme:(XUITheme *)theme {
    [super setTheme:theme];
    self.cellSegmentControl.tintColor = theme.tintColor;
}

@end
