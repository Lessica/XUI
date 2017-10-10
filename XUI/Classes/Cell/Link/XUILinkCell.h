//
//  XUILinkCell.h
//  XXTExplorer
//
//  Created by Zheng on 30/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIBaseCell.h"

static NSString * const XUILinkCellReuseIdentifier = @"XUILinkCellReuseIdentifier";

@interface XUILinkCell : XUIBaseCell

@property (nonatomic, strong) NSString *xui_url;

@end
