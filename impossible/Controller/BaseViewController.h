//
//  BaseViewController.h
//  impossible
//
//  Created by Blessed on 16/1/29.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
- (void)viewWillAppear:(BOOL)animated;
- (void)changeStatusBar:(NSString*)color;
- (void)changeNavigationLightVersion:(NSString*)title;
- (void)changeNavigationLightVersionWithoutBack:(NSString *)title;
- (void)changeNavigationLightVersionFromDifferentSource:(NSString *)title sourceTag:(NSInteger)tag pop2VC:(UIViewController*)vc;
- (void)footerView:(UITableView*)tableview;
- (void)showHintView;
- (void)showHintViewWithTitle:(NSString*)title;
- (void)showHintViewWithTitle:(NSString*)title onView:(UIView*)view;
- (void)showHintViewWithTitle:(NSString *)title onView:(UIView *)view withFrame:(CGFloat)height;
- (void)endHintView;
- (void)endHintViewOnView:(UIView*)view;
- (void)noData:(NSString*)text onTableView:(UITableView*)tableView;
@end
