//
//  XUISliderCell.h
//  XXTExplorer
//
//  Created by Zheng on 29/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIBaseCell.h"

@interface XUISliderCell : XUIBaseCell

@property (nonatomic, strong) NSNumber *xui_min;
@property (nonatomic, strong) NSNumber *xui_max;
@property (nonatomic, strong) NSNumber *xui_showValue;

@end
