//
//  XUIListHeaderView.h
//  XXTExplorer
//
//  Created by Zheng on 2017/7/21.
//  Copyright © 2017年 Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XUITheme;

@interface XUIListHeaderView : UIView

@property (nonatomic, strong) NSString *headerText;
@property (nonatomic, strong) NSString *subheaderText;
@property (nonatomic, strong) XUITheme *theme;

@end
