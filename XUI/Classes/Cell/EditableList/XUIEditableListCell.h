//
//  XUIEditableListCell.h
//  XUI
//
//  Created by Zheng on 15/10/2017.
//

#import <XUI/XUI.h>

@interface XUIEditableListCell : XUIBaseCell

@property (nonatomic, strong) NSNumber *xui_maxCount;
@property (nonatomic, strong) NSString *xui_footerText;
@property (nonatomic, strong) NSString *xui_validationRegex;

@end
