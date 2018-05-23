//
//  XUICheckboxCell.m
//  XXTExplorer
//
//  Created by Zheng on 09/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUICheckboxCell.h"
#import "XUITextTagCollectionView.h"

#import "XUIPrivate.h"
#import "XUILogger.h"
#import "XUIOptionModel.h"
#import "XUIViewShaker.h"

@interface XUICheckboxCell () <XUITextTagCollectionViewDelegate>

@property (nonatomic, strong) XUIViewShaker *viewShaker;
@property (strong, nonatomic) XUITextTagCollectionView *tagView;
@property (assign, nonatomic) BOOL shouldUpdateValue;
@property (assign, nonatomic) BOOL shouldReloadTagView;

@end

@implementation XUICheckboxCell

@synthesize xui_value = _xui_value;

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
      @"options": [NSArray class],
      @"alignment": [NSString class],
      @"numPerLine": [NSNumber class],
      @"maxCount": [NSNumber class],
      @"minCount": [NSNumber class],
      @"value": [NSArray class],
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

+ (BOOL)testValue:(id)value forKey:(NSString *)key error:(NSError **)error {
    if ([key isEqualToString:@"alignment"]) {
        if (NO == [@[ @"Left", @"Right", @"Center", @"FillByExpandingSpace", @"FillByExpandingWidth", @"FillByEqualWidth" ] containsObject:value]) {
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
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.tagView.alpha = 1.0;
    
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
    self.tagView.defaultConfig.tagExtraSpace = CGSizeMake(14.0, 14.0);
    
    // Alignment
    self.tagView.alignment = XUITagCollectionAlignmentFillByEqualWidth;
    if (XUI_PAD) {
        self.tagView.numberOfTagsPerLine = 4;
    } else {
        self.tagView.numberOfTagsPerLine = 2;
    }
    
    // Use manual calculate height
    self.tagView.delegate = self;
    self.tagView.manualCalculateHeight = YES;
    
    self.viewShaker = [[XUIViewShaker alloc] initWithView:self.tagView];
    
    [self.contentView addSubview:self.tagView];
    {
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
    [self reloadTagViewIfNeeded];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(CGRectGetWidth(self.bounds), self.tagView.intrinsicContentSize.height + 24.f + 1.f);
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
    
    [self setNeedsReloadTagView];
    [self updateValueIfNeeded];
}

- (void)setXui_value:(id)xui_value {
    _xui_value = xui_value;
    [self setNeedsUpdateValue];
    [self updateValueIfNeeded];
}

- (void)setXui_alignment:(NSString *)xui_alignment {
    _xui_alignment = xui_alignment;
    
    XUITagCollectionAlignment alignment = XUITagCollectionAlignmentFillByEqualWidth;
    if ([xui_alignment isEqualToString:@"Left"]) {
        alignment = XUITagCollectionAlignmentLeft;
    }
    else if ([xui_alignment isEqualToString:@"Center"]) {
        alignment = XUITagCollectionAlignmentCenter;
    }
    else if ([xui_alignment isEqualToString:@"Right"]) {
        alignment = XUITagCollectionAlignmentRight;
    }
    else if ([xui_alignment isEqualToString:@"FillByExpandingSpace"]) {
        alignment = XUITagCollectionAlignmentFillByExpandingSpace;
    }
    else if ([xui_alignment isEqualToString:@"FillByExpandingWidth"]) {
        alignment = XUITagCollectionAlignmentFillByExpandingWidth;
    }
    else if ([xui_alignment isEqualToString:@"FillByEqualWidth"]) {
        alignment = XUITagCollectionAlignmentFillByEqualWidth;
    }
    else {
        alignment = XUITagCollectionAlignmentFillByEqualWidth;
    }
    self.tagView.alignment = alignment;
    
    [self setNeedsReloadTagView];
}

- (void)setXui_readonly:(NSNumber *)xui_readonly {
    [super setXui_readonly:xui_readonly];
    BOOL readonly = [xui_readonly boolValue];
    self.tagView.enableTagSelection = !readonly;
    if (readonly) {
        self.tagView.alpha = 0.5;
    } else {
        self.tagView.alpha = 1.0;
    }
}

- (void)setXui_numPerLine:(NSNumber *)xui_numPerLine {
    _xui_numPerLine = xui_numPerLine;
    
    NSUInteger numPerLine = [xui_numPerLine unsignedIntegerValue];
    if (numPerLine == 0) {
        numPerLine = 1;
    } else if (numPerLine > 12) {
        numPerLine = 12;
    }
    
    self.tagView.numberOfTagsPerLine = numPerLine;
    [self setNeedsReloadTagView];
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
    
    [self setNeedsReloadTagView];
}

- (void)setXui_maxCount:(NSNumber *)xui_maxCount {
    _xui_maxCount = xui_maxCount;
    self.tagView.selectionLimit = [xui_maxCount unsignedIntegerValue];
}

#pragma mark - Value Reload

- (void)setNeedsUpdateValue {
    self.shouldUpdateValue = YES;
}

- (void)updateValueIfNeeded {
    if (self.shouldUpdateValue && self.tagView.allTags.count > 0) {
        self.shouldUpdateValue = NO;
        NSArray *selectedValues = self.xui_value;
        NSUInteger minCount = [self.xui_minCount unsignedIntegerValue];
        NSUInteger maxCount = [self.xui_maxCount unsignedIntegerValue];
        if (selectedValues.count > maxCount || selectedValues.count < minCount) {
            return; // Invalid value, ignore
        }
        XUITextTagCollectionView *tagView = self.tagView;
        for (NSUInteger tagIndex = 0; tagIndex < tagView.allTags.count; tagIndex++)
        {
            [tagView setTagAtIndex:tagIndex selected:NO];
        }
        for (id selectedValue in selectedValues) {
            NSUInteger selectedIndex = [self.xui_options indexOfObjectPassingTest:^BOOL(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([selectedValue isEqual:obj[XUIOptionValueKey]]) {
                    return YES;
                }
                return NO;
            }];
            if (selectedIndex != NSNotFound) {
                [tagView setTagAtIndex:selectedIndex selected:YES];
            }
        }
    }
}

- (id)textTagCollectionView:(XUITextTagCollectionView *)textTagCollectionView valueForTagAtIndex:(NSUInteger)selectedIndexValue {
    NSMutableArray *validValues = [[NSMutableArray alloc] init];
    for (NSDictionary *obj in self.xui_options) {
        if (obj[XUIOptionValueKey]) {
            [validValues addObject:obj[XUIOptionValueKey]];
        } else {
            return nil;
        }
    }
    if (selectedIndexValue >= validValues.count) return nil;
    id selectedValue = validValues[selectedIndexValue];
    return selectedValue;
}

- (BOOL)textTagCollectionView:(XUITextTagCollectionView *)textTagCollectionView canTapTag:(NSString *)tagText atIndex:(NSUInteger)index currentSelected:(BOOL)currentSelected {
    NSArray *selectedValues = self.xui_value;
    NSUInteger maxCount = [self.xui_maxCount unsignedIntegerValue];
    NSUInteger minCount = [self.xui_minCount unsignedIntegerValue];
    BOOL canTap = YES;
    if (selectedValues.count >= maxCount && currentSelected == NO) {
        canTap = NO;
    }
    else if (selectedValues.count <= minCount && currentSelected == YES) {
        canTap = NO;
    }
    if ([self textTagCollectionView:textTagCollectionView valueForTagAtIndex:index] == nil) {
        canTap = NO;
    }
    if (!canTap) {
        [self.viewShaker shake];
    }
    return canTap;
}

- (void)textTagCollectionView:(XUITextTagCollectionView *)textTagCollectionView
                    didTapTag:(NSString *)tagText
                      atIndex:(NSUInteger)index
                     selected:(BOOL)selected
{
    NSMutableArray *validValues = [[NSMutableArray alloc] init];
    [self.xui_options enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj[XUIOptionValueKey]) {
            [validValues addObject:obj[XUIOptionValueKey]];
        } else {
            return;
        }
    }];
    NSMutableArray *selectedValues = [[NSMutableArray alloc] init];
    NSArray <NSNumber *> *selectedIndexes = textTagCollectionView.allSelectedIndexes;
    for (NSNumber *selectedIndex in selectedIndexes) {
        NSUInteger selectedIndexValue = [selectedIndex unsignedIntegerValue];
        if (selectedIndexValue >= validValues.count) return;
        id selectedValue = validValues[selectedIndexValue];
        if (selectedValue) [selectedValues addObject:selectedValue];
    }
    self.xui_value = [selectedValues copy];
    [self.adapter saveDefaultsFromCell:self];
}


#pragma mark - Reload

- (void)setNeedsReloadTagView {
    self.shouldReloadTagView = YES;
}

- (void)reloadTagViewIfNeeded {
    if (self.shouldReloadTagView) {
        [self.tagView reload];
        self.shouldReloadTagView = NO;
    }
}

@end
