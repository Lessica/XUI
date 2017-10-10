//
//  XUISecureTextFieldCell.h
//  XXTExplorer
//
//  Created by Zheng on 29/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIBaseCell.h"

@interface XUISecureTextFieldCell : XUIBaseCell

@property (nonatomic, strong) NSString * xui_alignment;
@property (nonatomic, strong) NSString * xui_keyboard;
@property (nonatomic, strong) NSString * xui_autoCaps;
@property (nonatomic, strong) NSString * xui_placeholder;
@property (nonatomic, strong) NSString * xui_bestGuess;
@property (nonatomic, strong) NSNumber * xui_noAutoCorrect;
@property (nonatomic, strong) NSNumber * xui_isIP;
@property (nonatomic, strong) NSNumber * xui_isURL;
@property (nonatomic, strong) NSNumber * xui_isNumeric;
@property (nonatomic, strong) NSNumber * xui_isDecimalPad;
@property (nonatomic, strong) NSNumber * xui_isEmail;
// Max length
// Regex

@end
