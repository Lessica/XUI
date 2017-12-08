//
//  XUITheme.h
//  XXTExplorer
//
//  Created by Zheng Wu on 14/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XUITheme : NSObject

#pragma mark - Global

@property (nonatomic, strong) UIColor *dangerColor;
@property (nonatomic, strong) UIColor *warningColor;
@property (nonatomic, strong) UIColor *successColor; // fill

@property (nonatomic, strong) UIColor *navigationBarColor;
@property (nonatomic, strong) UIColor *navigationTitleColor;

#pragma mark - Table View

@property (nonatomic, assign) UITableViewStyle tableViewStyle;
@property (nonatomic, strong) UIColor *foregroundColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *separatorColor;

#pragma mark - Cells

@property (nonatomic, strong) UIColor *cellBackgroundColor; // cell background
@property (nonatomic, strong) UIColor *disclosureIndicatorColor; // cell disclosure

@property (nonatomic, strong) UIColor *labelColor; // text
@property (nonatomic, strong) UIColor *valueColor; // detail text

@property (nonatomic, strong) UIColor *selectedColor; // cell selected
@property (nonatomic, strong) UIColor *highlightedColor; // cell highlighted

#pragma mark - Inputs

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *caretColor;
@property (nonatomic, strong) UIColor *placeholderColor;

#pragma mark - Tag Views

// Text color
@property (strong, nonatomic) UIColor *tagTextColor;
@property (strong, nonatomic) UIColor *tagSelectedTextColor;

// Background color
@property (strong, nonatomic) UIColor *tagBackgroundColor;
@property (strong, nonatomic) UIColor *tagSelectedBackgroundColor;

// Border color
@property (strong, nonatomic) UIColor *tagBorderColor;
@property (strong, nonatomic) UIColor *tagSelectedBorderColor;

#pragma mark - Switch

@property (strong, nonatomic) UIColor *thumbTintColor;

#pragma mark - Dark Mode

@property (nonatomic, assign, readonly, getter=isDarkMode) BOOL darkMode;

#pragma mark - Initializers

- (instancetype)initWithDictionary:(NSDictionary *)themeDictionary;

@end
