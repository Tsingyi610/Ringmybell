//
//  RMBHintView.h
//  impossible
//
//  Created by Blessed on 16/5/4.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMBHintView : UIView
+ (RMBHintView *)hintViewWithTitle:(NSString *)title onView:(UIView*)view;
+ (RMBHintView *)hintViewWithTitle:(NSString *)title onView:(UIView*)view withFrame:(CGFloat)height;
@end
