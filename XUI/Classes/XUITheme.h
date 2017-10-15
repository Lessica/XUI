//
//  XUITheme.h
//  XXTExplorer
//
//  Created by Zheng Wu on 14/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XUITheme : NSObject

@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, strong) UIColor *dangerColor;
@property (nonatomic, strong) UIColor *warningColor;
@property (nonatomic, strong) UIColor *successColor;

@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *highlightedColor;

@property (nonatomic, strong) UIColor *navigationBarColor;
@property (nonatomic, strong) UIColor *navigationTitleColor;

@property (nonatomic, strong) UIColor *labelColor;
@property (nonatomic, strong) UIColor *valueColor;

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *disclosureIndicatorColor;


@property (nonatomic, assign, readonly, getter=isDarkMode) BOOL darkMode;

- (instancetype)initWithDictionary:(NSDictionary *)themeDictionary;

@end
