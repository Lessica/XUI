//
//  XUITextFieldCell.h
//  XXTExplorer
//
//  Created by Zheng on 29/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIBaseCell.h"
#import "XUITextField.h"

@interface XUITextFieldCell : XUIBaseCell

@property (strong, nonatomic) XUITextField *cellTextField;

@property (nonatomic, strong) NSString * xui_alignment;
@property (nonatomic, strong) NSString * xui_keyboard;
@property (nonatomic, strong) NSString * xui_placeholder;
@property (nonatomic, strong) NSNumber * xui_isSecure;

@property (nonatomic, strong) NSNumber *xui_maxLength;
@property (nonatomic, strong) NSString *xui_clearButtonMode;

// Regex

@end
