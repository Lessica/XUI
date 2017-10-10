//
//  XUIButtonCell.h
//  XXTExplorer
//
//  Created by Zheng on 29/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIBaseCell.h"

extern const void * XUIButtonCellStorageKey;

@interface XUIButtonCell : XUIBaseCell

@property (nonatomic, strong) NSString *xui_action;
@property (nonatomic, strong) NSArray *xui_kwargs;

@end
