//
//  SpecificView.m
//  impossible
//
//  Created by Blessed on 16/3/20.
//  Copyright © 2016年 ringmybell. All rights reserved.
//
#define X 10
#define Y 40
#define STANDARDVIEW_WIDTH [UIScreen mainScreen].bounds.size.width-2*X
#define STANDARDVIEW_HEIGHT [UIScreen mainScreen].bounds.size.height-Y-X

#import "SpecificView.h"
#import "UIColor+Extra.h"

@interface SpecificView()
{
    UIView *standardView;
    UIView *outerView;
    UIView *innerView;
    UIView *container;
    UILabel *label;
}
@end

@implementation SpecificView

+ (void)showSpecificView:(UIViewController*)viewController andTitle:(NSString*)title {
    SpecificView *view = [viewController.view viewWithTag:1001];
    CGRect rect = viewController.view.frame;
    if (view) {
        view.hidden = NO;
        [view setupText:title];
        return;
    }
    view = [[SpecificView alloc] initWithFrame:rect andTitle:title];
    view.tag = 1001;
    [viewController.view addSubview:view];
}

- (id)initWithFrame:(CGRect)frame andTitle:(NSString*)title{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
//        label.text = title;
//        label.font = [UIFont systemFontOfSize:17.0f];
//        label.textColor = [UIColor colorWithRGB:@"303030"];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.backgroundColor = [UIColor clearColor];
        
//        [self addSubview:label];
        
        standardView = [[UIView alloc] initWithFrame:CGRectMake(X,Y,STANDARDVIEW_WIDTH,STANDARDVIEW_HEIGHT)];
        standardView.backgroundColor = [UIColor whiteColor];
        standardView.tag = 100;
        
        outerView = [[UIView alloc] initWithFrame:CGRectMake(0, Y-10, 30, 30)];
        outerView.clipsToBounds = YES;
        outerView.layer.cornerRadius = 15.0;
        outerView.backgroundColor = [UIColor lightGrayColor];
        outerView.tag = 100100;
        
        innerView = [[UIView alloc] initWithFrame:CGRectMake(1, 1, 28, 28)];
        innerView.clipsToBounds = YES;
        innerView.layer.cornerRadius = 14.0;
        innerView.backgroundColor = [UIColor whiteColor];
        innerView.tag = 100101;
        
        UIImageView *cross = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 24, 24)];
        cross.image = [UIImage imageNamed:@"ico_house_cross"];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, standardView.frame.size.width-50, 40)];
        label.text = title;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont fontWithName:@"AvenirNext-UltraLight" size:20.0];
        label.textColor = [UIColor colorWithRGB:@"303030"];
        [label sizeToFit];
        
        CGSize labelSize = label.frame.size;
        CGFloat offset = labelSize.height+Y;
        container = [[UIView alloc] initWithFrame:CGRectMake(0, offset, standardView.frame.size.width, STANDARDVIEW_HEIGHT-offset)];
        container.tag = 100102;
        
        [self addSubview:standardView];
        [standardView addSubview:container];
        [standardView addSubview:label];
        [self addSubview:outerView];
        [outerView addSubview:innerView];
        [innerView addSubview:cross];
        
//        UITapGestureRecognizer *tap2close = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSpecificView)];
//        [self addGestureRecognizer:tap2close];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setupText:(NSString *)text {
    label.text = text;
    [label sizeToFit];
}

//modal动画
- (void)setupUI {
    [UIView animateWithDuration:1.0f animations:^{
        standardView.frame = CGRectMake(X, Y, STANDARDVIEW_WIDTH, STANDARDVIEW_HEIGHT);
        standardView.alpha = 1.0;
    } completion:^(BOOL finished) {
        CGRect rect = CGRectMake(X,Y,STANDARDVIEW_WIDTH,STANDARDVIEW_HEIGHT);
        standardView.frame = rect;
    }];
}

@end
