//
//  XUIRadioCell.m
//  XXTExplorer
//
//  Created by Zheng on 09/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIRadioCell.h"
#import "XUITextTagCollectionView.h"

#import "XUIPrivate.h"
#import "XUILogger.h"
#import "XUIOptionModel.h"

@interface XUIRadioCell () <XUITextTagCollectionViewDelegate>

@property (strong, nonatomic) XUITextTagCollectionView *tagView;
@property (assign, nonatomic) BOOL shouldUpdateValue;

@end

@implementation XUIRadioCell

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
    return YES;
}

+ (BOOL)layoutUsesAutoResizing {
    return YES;
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

#pragma mark - Setup

- (void)setupCell {
    [super setupCell];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.tagView.scrollView.scrollEnabled = NO;
    self.tagView.contentInset = UIEdgeInsetsZero;
    self.tagView.scrollDirection = XUITagCollectionScrollDirectionVertical;
    
    self.tagView.defaultConfig.tagCornerRadius = 4.f;
    self.tagView.defaultConfig.tagSelectedCornerRadius = 4.f;
    
    self.tagView.defaultConfig.tagShadowColor = UIColor.clearColor;
    
    self.tagView.defaultConfig.tagBorderColor = UIColor.clearColor;
    self.tagView.defaultConfig.tagSelectedBorderColor = UIColor.clearColor;
    
    self.tagView.defaultConfig.tagBorderWidth = 1.f;
    self.tagView.defaultConfig.tagSelectedBorderWidth = 1.f;
    
    // Alignment
    self.tagView.alignment = XUITagCollectionAlignmentLeft;
    
    // Use manual calculate height
    self.tagView.delegate = self;
    self.tagView.manualCalculateHeight = NO;
    
    {
        [self.contentView addSubview:self.tagView];
        NSArray <NSLayoutConstraint *> *constraints =
        @[
          [NSLayoutConstraint constraintWithItem:self.tagView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:16.0],
          [NSLayoutConstraint constraintWithItem:self.tagView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-16.0],
          [NSLayoutConstraint constraintWithItem:self.tagView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:12.0],
          [NSLayoutConstraint constraintWithItem:self.tagView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-12.0],
          ];
        [self.contentView addConstraints:constraints];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tagView.preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - 32.f;
}

#pragma mark - UIView Getters

- (XUITextTagCollectionView *)tagView {
    if (!_tagView) {
        _tagView = [[XUITextTagCollectionView alloc] init];
        _tagView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _tagView;
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
    NSMutableArray <NSString *> *xui_validTitles = [[NSMutableArray alloc] init];
    [xui_options enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = obj[XUIOptionTitleKey];
        if (title) {
            NSString *localizedTitle = [self.adapter localizedStringForKey:title value:title];
            [xui_validTitles addObject:localizedTitle];
        }
    }];
    [self.tagView removeAllTags];
    [self.tagView addTags:xui_validTitles];
    [self.tagView reload];
    
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
    if (self.shouldUpdateValue && self.tagView.allTags.count > 0) {
        self.shouldUpdateValue = NO;
        id selectedValue = self.xui_value;
        NSUInteger selectedIndex = [self.xui_options indexOfObjectPassingTest:^BOOL(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([selectedValue isEqual:obj[XUIOptionValueKey]]) {
                return YES;
            }
            return NO;
        }];
        if (selectedIndex != NSNotFound) {
            [self.tagView setTagAtIndex:selectedIndex selected:YES];
        }
    }
}

- (BOOL)textTagCollectionView:(XUITextTagCollectionView *)textTagCollectionView canTapTag:(NSString *)tagText atIndex:(NSUInteger)index currentSelected:(BOOL)currentSelected {
    return YES;
}

- (void)textTagCollectionView:(XUITextTagCollectionView *)textTagCollectionView
                    didTapTag:(NSString *)tagText
                      atIndex:(NSUInteger)index
                     selected:(BOOL)selected
{
    NSUInteger selectedIndexValue = index;
    NSMutableArray *validValues = [[NSMutableArray alloc] init];
    [self.xui_options enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj[XUIOptionValueKey]) {
            [validValues addObject:obj[XUIOptionValueKey]];
        }
    }];
    if (index < validValues.count) {
        for (NSUInteger tagIndex = 0; tagIndex < textTagCollectionView.allTags.count; tagIndex++) {
            if (tagIndex == index) {
                [textTagCollectionView setTagAtIndex:tagIndex selected:YES];
            } else {
                [textTagCollectionView setTagAtIndex:tagIndex selected:NO];
            }
        }
        id selectedValue = validValues[selectedIndexValue];
        self.xui_value = selectedValue;
        [self.adapter saveDefaultsFromCell:self];
    }
}

- (void)setXui_alignment:(NSString *)xui_alignment {
    _xui_alignment = xui_alignment;
    if ([xui_alignment isEqualToString:@"Left"]) {
        self.tagView.alignment = XUITagCollectionAlignmentLeft;
    }
    else if ([xui_alignment isEqualToString:@"Center"]) {
        self.tagView.alignment = XUITagCollectionAlignmentCenter;
    }
    else if ([xui_alignment isEqualToString:@"Right"]) {
        self.tagView.alignment = XUITagCollectionAlignmentRight;
    }
    else if ([xui_alignment isEqualToString:@"Natural"]) {
        self.tagView.alignment = XUITagCollectionAlignmentFillByExpandingSpace;
    }
    else if ([xui_alignment isEqualToString:@"Justified"]) {
        self.tagView.alignment = XUITagCollectionAlignmentFillByExpandingWidth;
    }
    else {
        self.tagView.alignment = XUITagCollectionAlignmentLeft;
    }
}

- (void)setXui_readonly:(NSNumber *)xui_readonly {
    [super setXui_readonly:xui_readonly];
    BOOL readonly = [xui_readonly boolValue];
    self.tagView.enableTagSelection = !readonly;
}

- (void)setInternalTheme:(XUITheme *)theme {
    [super setInternalTheme:theme];
    
    self.tagView.defaultConfig.tagTextColor = theme.tagTextColor;
    self.tagView.defaultConfig.tagSelectedTextColor = theme.tagSelectedTextColor;
    
    self.tagView.defaultConfig.tagBackgroundColor = theme.tagBackgroundColor;
    self.tagView.defaultConfig.tagSelectedBackgroundColor = theme.tagSelectedBackgroundColor;
    
    self.tagView.defaultConfig.tagBorderColor = theme.tagBorderColor;
    self.tagView.defaultConfig.tagSelectedBorderColor = theme.tagSelectedBorderColor;
    
    self.tagView.backgroundColor = [UIColor clearColor];
    
    [self.tagView reload];
}

@end
