//
//  BaseViewController.m
//  impossible
//
//  Created by Blessed on 16/1/29.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"
#import "Masonry.h"
#import "RMBHintView.h"
#import "UIColor+Extra.h"

@interface BaseViewController ()
{
    NSInteger _source;
    UIViewController *viewController;
}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    viewController  = [[UIViewController alloc] init];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //重写viewWillAppear 关闭ios7侧滑返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeStatusBar:(NSString*)color {
    if ([@"white" isEqualToString:color]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

- (void)changeNavigationLightVersion:(NSString*)title {
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationItem setTitle:title];
    //取消导航栏的透明度
    [self.navigationController.navigationBar setTranslucent:NO];
    //pop时显示返回的controller背景色
    self.extendedLayoutIncludesOpaqueBars = YES;
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRGB:@"#7DB3E5"]];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"< 返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationItem setLeftBarButtonItem:back animated:YES];
}

- (void)changeNavigationLightVersionWithoutBack:(NSString *)title {
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationItem setTitle:title];
    //取消导航栏的透明度
    [self.navigationController.navigationBar setTranslucent:NO];
    //pop时显示返回的controller背景色
    self.extendedLayoutIncludesOpaqueBars = YES;
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRGB:@"#7DB3E5"]];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationItem setLeftBarButtonItem:back animated:YES];
}

- (void)changeNavigationLightVersionFromDifferentSource:(NSString *)title sourceTag:(NSInteger)tag pop2VC:(UIViewController*)vc{
    _source = tag;
    viewController = vc;
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationItem setTitle:title];
    //取消导航栏的透明度
    [self.navigationController.navigationBar setTranslucent:NO];
    //pop时显示返回的controller背景色
    self.extendedLayoutIncludesOpaqueBars = YES;
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRGB:@"#7DB3E5"]];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"< 返回" style:UIBarButtonItemStylePlain target:self action:@selector(back2differ)];
    [self.navigationItem setLeftBarButtonItem:back animated:YES];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)back2differ {
    if (1 == _source) {
        [self.navigationController popToViewController:viewController animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)showHintView {
    RMBHintView *hintView = [RMBHintView hintViewWithTitle:@"默认的提示字幕" onView:self.view];
    [UIView animateWithDuration:0.5 animations:^{
        hintView.alpha = 1.0f;
    } completion:nil];
}

- (void)showHintViewWithTitle:(NSString*)title {
    RMBHintView *hintView = [RMBHintView hintViewWithTitle:title onView:self.view];
    [UIView animateWithDuration:0.5 animations:^{
        hintView.alpha = 1.0f;
    } completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endHintView];
    });
}

- (void)showHintViewWithTitle:(NSString *)title onView:(UIView *)view {
    RMBHintView *hintView = [RMBHintView hintViewWithTitle:title onView:view];
    [UIView animateWithDuration:0.5 animations:^{
        hintView.alpha = 1.0f;
    } completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endHintViewOnView:view];
    });
}

- (void)showHintViewWithTitle:(NSString *)title onView:(UIView *)view withFrame:(CGFloat)height {
    RMBHintView *hintView = [RMBHintView hintViewWithTitle:title onView:view withFrame:height];
    [UIView animateWithDuration:0.5 animations:^{
        hintView.alpha = 1.0f;
    } completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endHintViewOnView:view];
    });
}

- (void)endHintView {
    RMBHintView *hintView = [self.view viewWithTag:520];
    [UIView animateWithDuration:0.5 animations:^{
        hintView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [hintView removeFromSuperview];
    }];
}

- (void)endHintViewOnView:(UIView *)view {
    RMBHintView *hintView = [view viewWithTag:520];
    [UIView animateWithDuration:0.5 animations:^{
        hintView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [hintView removeFromSuperview];
    }];
}

- (void)noData:(NSString *)text onTableView:(UITableView *)tableView {
    UIView *container = [UIView new];
    [tableView addSubview:container];
    //container.backgroundColor = [UIColor blueColor];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tableView).with.insets(UIEdgeInsetsMake(tableView.frame.size.height/2-40, 70, tableView.frame.size.height/2-40, 50));
    }];
    UILabel *noDataDisplay = [[UILabel alloc] init];
    noDataDisplay.text = text;
    //noDataDisplay.backgroundColor = [UIColor redColor];
    noDataDisplay.textColor = [UIColor grayColor];
    noDataDisplay.textAlignment = NSTextAlignmentCenter;
    noDataDisplay.font = [UIFont systemFontOfSize:14];
    [container addSubview:noDataDisplay];
    [noDataDisplay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(container).with.insets(UIEdgeInsetsMake(0,0,0,0));
    }];
}

- (void)footerView:(UITableView *)tableview {
    UIView *view = [[UIView alloc] init];
    [tableview setTableFooterView:view];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
