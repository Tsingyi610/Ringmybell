//
//  RMBHintView.m
//  impossible
//
//  Created by Blessed on 16/5/4.
//  Copyright © 2016年 ringmybell. All rights reserved.
//
#define CONSTRAINTS [UIScreen mainScreen].bounds.size.height - 70 - 30

#import "RMBHintView.h"
#import "Masonry.h"

@implementation RMBHintView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (RMBHintView *)hintViewWithTitle:(NSString *)title onView:(UIView *)view {
    NSStringFromCGRect(view.frame);
    RMBHintView *hintView = [[RMBHintView alloc] init];
    hintView.backgroundColor = [UIColor grayColor];
    hintView.clipsToBounds = YES;
    hintView.layer.cornerRadius = 5.0;
    UIView *superView = view;
    [superView addSubview:hintView];
    [hintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView).with.insets(UIEdgeInsetsMake(70, 50, view.frame.size.height-70-30, 50));
    }];
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.text = title;
    hintLabel.textColor = [UIColor whiteColor];
    hintLabel.font = [UIFont systemFontOfSize:14];
    [hintView addSubview:hintLabel];
    [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(hintLabel.superview).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintView.alpha = 0.0f;
    hintView.tag = 520;
    return hintView;
}

+ (RMBHintView *)hintViewWithTitle:(NSString *)title onView:(UIView *)view withFrame:(CGFloat)height {
    NSStringFromCGRect(view.frame);
    RMBHintView *hintView = [[RMBHintView alloc] init];
    hintView.backgroundColor = [UIColor grayColor];
    hintView.clipsToBounds = YES;
    hintView.layer.cornerRadius = 5.0;
    UIView *superView = view;
    [superView addSubview:hintView];
    [hintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView).with.insets(UIEdgeInsetsMake(height, 50, view.frame.size.height-height-30, 50));
    }];
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.text = title;
    hintLabel.textColor = [UIColor whiteColor];
    hintLabel.font = [UIFont systemFontOfSize:14];
    [hintView addSubview:hintLabel];
    [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(hintLabel.superview).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintView.alpha = 0.0f;
    hintView.tag = 520;
    return hintView;
}


@end
