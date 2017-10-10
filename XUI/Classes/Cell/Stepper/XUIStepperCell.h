//
//  XUIStepperCell.h
//  XXTExplorer
//
//  Created by Zheng on 04/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIBaseCell.h"

@interface XUIStepperCell : XUIBaseCell

@property (nonatomic, strong) NSNumber *xui_min;
@property (nonatomic, strong) NSNumber *xui_max;
@property (nonatomic, strong) NSNumber *xui_step;
@property (nonatomic, strong) NSNumber *xui_isInteger;
@property (nonatomic, strong) NSNumber *xui_autoRepeat;

@end
