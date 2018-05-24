//
//  XUITheme.h
//  XXTExplorer
//
//  Created by Zheng Wu on 14/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XUITheme : NSObject <NSCopying>


#pragma mark - Global
@property (nonatomic, strong, readonly) UIColor *dangerColor;
@property (nonatomic, strong, readonly) UIColor *warningColor;
@property (nonatomic, strong, readonly) UIColor *successColor; // fill


#pragma mark - Navigation Bar
@property (nonatomic, strong, readonly) UIColor *navigationBarColor;
@property (nonatomic, strong, readonly) UIColor *navigationTitleColor;


#pragma mark - Header & Footer
@property (nonatomic, strong, readonly) UIColor *headerTextColor;
@property (nonatomic, strong, readonly) UIColor *subheaderTextColor;
@property (nonatomic, strong, readonly) UIColor *footerTextColor;
@property (nonatomic, strong, readonly) UIColor *headerBackgroundColor;
@property (nonatomic, strong, readonly) UIColor *footerBackgroundColor;


#pragma mark - Table View
@property (nonatomic, assign, readonly) UITableViewStyle tableViewStyle;
@property (nonatomic, strong, readonly) UIColor *foregroundColor;
@property (nonatomic, strong, readonly) UIColor *backgroundColor;
@property (nonatomic, strong, readonly) UIColor *separatorColor;
@property (nonatomic, strong, readonly) NSString *backgroundImagePath;


#pragma mark - Group Cell
@property (nonatomic, strong, readonly) UIColor *sectionHeaderTextColor;
@property (nonatomic, strong, readonly) UIColor *sectionHeaderBackgroundColor;
@property (nonatomic, strong, readonly) UIColor *sectionFooterTextColor;
@property (nonatomic, strong, readonly) UIColor *sectionFooterBackgroundColor;


#pragma mark - Other Cells
@property (nonatomic, strong, readonly) UIColor *cellBackgroundColor; // cell background
@property (nonatomic, strong, readonly) UIColor *selectedColor; // cell selected
@property (nonatomic, strong, readonly) UIColor *highlightedColor; // cell highlighted
@property (nonatomic, strong, readonly) UIColor *disclosureIndicatorColor; // cell disclosure
@property (nonatomic, strong, readonly) UIColor *labelColor; // text
@property (nonatomic, strong, readonly) UIColor *valueColor; // detail text


#pragma mark - Inputs
@property (nonatomic, strong, readonly) UIColor *textColor;
@property (nonatomic, strong, readonly) UIColor *caretColor;
@property (nonatomic, strong, readonly) UIColor *placeholderColor;


#pragma mark - Tag Views
@property (strong, nonatomic, readonly) UIColor *tagTextColor;
@property (strong, nonatomic, readonly) UIColor *tagSelectedTextColor;
@property (strong, nonatomic, readonly) UIColor *tagBackgroundColor;
@property (strong, nonatomic, readonly) UIColor *tagSelectedBackgroundColor;
@property (strong, nonatomic, readonly) UIColor *tagBorderColor;
@property (strong, nonatomic, readonly) UIColor *tagSelectedBorderColor;


#pragma mark - Switch
// tintColor
@property (strong, nonatomic, readonly) UIColor *thumbTintColor;


#pragma mark - Dark Mode
@property (nonatomic, assign, readonly, getter=isDarkMode) BOOL darkMode;
@property (nonatomic, assign, readonly, getter=isBackgroundDark) BOOL backgroundDark;


#pragma mark - Initializers
@property (nonatomic, copy) NSDictionary *rawTheme;
- (instancetype)initWithDictionary:(NSDictionary *)themeDictionary;


@end
