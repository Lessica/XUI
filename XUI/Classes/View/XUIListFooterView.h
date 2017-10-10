//
//  XUIListFooterView.h
//  XXTExplorer
//
//  Created by Zheng on 24/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XUITheme;

@interface XUIListFooterView : UIView

@property (nonatomic, strong) NSString *footerText;
@property (nonatomic, strong) UIImage *footerIcon;
@property (nonatomic, strong) XUITheme *theme;

@end
