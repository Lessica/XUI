//
//  XUICheckboxCell.h
//  XXTExplorer
//
//  Created by Zheng on 09/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIBaseCell.h"

@interface XUICheckboxCell : XUIBaseCell

@property (nonatomic, strong) NSArray <NSDictionary *> *xui_options;
@property (nonatomic, strong) NSNumber *xui_maxCount;
@property (nonatomic, strong) NSNumber *xui_minCount;
@property (nonatomic, strong) NSString *xui_alignment;

@end
