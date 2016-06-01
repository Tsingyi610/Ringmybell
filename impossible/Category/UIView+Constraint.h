//
//  UIView+Constraint.h
//  impossible
//
//  Created by Blessed on 16/4/19.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UILayoutAttributeNone = 0,
    UILayoutAttributeWidth = 1,
    UILayoutAttributeHeight = 1<<1,
    UILayoutAttributeLeft = 1<<2,
    UILayoutAttributeRight = 1<<3,
    UILayoutAttributeTop = 1<<4,
    UILayoutAttributeBottom = 1<<5,
    UILayoutAttributeHorizontal = 1<<6,
    UILayoutAttributeVertical = 1<<7
}UILayoutAttribute;

@class UILayout;

@interface UILayoutProperty : NSObject

-(UILayoutProperty*)initWithLayout:(UILayout*)layout property:(NSLayoutAttribute)attribute;

@property(nonatomic,weak,readonly)UILayout *layout;
@property(nonatomic,assign,readonly)NSLayoutAttribute property;

-(UILayout *(^)(UILayoutProperty *propery,CGFloat constant))spacing;

@end

@interface UILayout : NSObject{
@protected
    __weak UIView *_view;
    __weak UIView *_relatedView;
    
    UILayoutProperty *_left;
    UILayoutProperty *_right;
    UILayoutProperty *_bottom;
    UILayoutProperty *_top;
}

-(UILayout*)initWithView:(UIView*)view;

@property(nonatomic,weak,readonly)UIView *view;
@property(nonatomic,weak,readonly)UIView *relatedView;

@property(nonatomic,retain,readonly)UILayoutProperty *left;
@property(nonatomic,retain,readonly)UILayoutProperty *right;
@property(nonatomic,retain,readonly)UILayoutProperty *bottom;
@property(nonatomic,retain,readonly)UILayoutProperty *top;

-(UILayout *(^)(UIView*))equalTo;
-(UILayout *(^)())end;

-(UILayout *(^)(NSInteger attrs))remove;

-(UILayout *(^)(CGFloat width))width;
-(UILayout *(^)(CGFloat height))height;
-(UILayout *(^)(CGSize size))size;
-(UILayout *(^)(CGFloat ratio))ratio;
-(UILayout *(^)())scaleWidth;
-(UILayout *(^)())scaleHeight;
-(UILayout *(^)(CGFloat multipier,int attrs))scaleSize;
-(UILayout *(^)(CGFloat rate))scaleWidthToHeight;//宽高比

-(UILayout *(^)(CGPoint point))position;
-(UILayout *(^)(CGFloat x))x;
-(UILayout *(^)(CGFloat y))y;
-(UILayout *(^)(UIEdgeInsets insets))insets;
-(UILayout *(^)(UIEdgeInsets,int))edge;
-(UILayout *(^)())fullWidth;
-(UILayout *(^)())fullHeight;

-(UILayout *(^)(UIView*view,CGFloat margin))follow;
-(UILayout *(^)(UIView*view,CGFloat margin))after;

-(UILayout *(^)(int))center;

-(UILayout *(^)(UIView*))equalWidth;
-(UILayout *(^)(UIView*))equalHeight;
@end

@interface UIView (Constraint)
@property(nonatomic,strong,readonly)UILayout *layout;

-(void)removeAllSubviews;
+(void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay constraint:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;
@end

