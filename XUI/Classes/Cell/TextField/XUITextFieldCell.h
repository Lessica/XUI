//
//  XUITextFieldCell.h
//  XXTExplorer
//
//  Created by Zheng on 29/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIBaseCell.h"

@interface XUITextFieldCell : XUIBaseCell

@property (weak, nonatomic) IBOutlet UITextField *cellTextField;

@property (nonatomic, strong) NSString * xui_alignment;
@property (nonatomic, strong) NSString * xui_keyboard;
@property (nonatomic, strong) NSString * xui_placeholder;
@property (nonatomic, strong) NSNumber * xui_isSecure;
// Max length
// Regex

@end
