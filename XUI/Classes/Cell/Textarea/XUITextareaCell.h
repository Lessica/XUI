//
//  XUITextareaCell.h
//  XXTExplorer
//
//  Created by Zheng on 10/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIBaseCell.h"

@interface XUITextareaCell : XUIBaseCell

@property (nonatomic, strong) NSNumber *xui_maxLength;
@property (nonatomic, strong) NSString *xui_alignment;
@property (nonatomic, strong) NSString *xui_keyboard;
@property (nonatomic, strong) NSString *xui_autoCaps;
@property (nonatomic, strong) NSNumber *xui_noAutoCorrect;

@end
