//
//  XUIDateTimeCell.h
//  XXTExplorer
//
//  Created by Zheng on 16/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIBaseCell.h"

@interface XUIDateTimeCell : XUIBaseCell

@property (nonatomic, strong) NSString *xui_mode;
@property (nonatomic, strong) NSNumber *xui_minuteInterval;
@property (nonatomic, strong) NSNumber *xui_max;
@property (nonatomic, strong) NSNumber *xui_min;

@end
