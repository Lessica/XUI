//
//  XUIOptionCell.h
//  XXTExplorer
//
//  Created by Zheng on 30/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIBaseCell.h"

@interface XUIOptionCell : XUIBaseCell

@property (nonatomic, strong) NSArray <NSDictionary *> *xui_options;
@property (nonatomic, strong) NSString *xui_staticTextMessage;

@end
