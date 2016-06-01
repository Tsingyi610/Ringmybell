//
//  OrderResultViewController.m
//  impossible
//
//  Created by Blessed on 16/4/27.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "OrderResultViewController.h"
#import "IndexViewController.h"

@interface OrderResultViewController ()

@end

@implementation OrderResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersionWithoutBack:@"预定结果"];
    [self initData];
    // Do any additional setup after loading the view.
}

- (void)initData {
    self.hnameLabel.text = self.hname;
    self.orderTimeLabel.text = [NSString stringWithFormat:@"您入住的时间：%@",self.orderTime];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"共%lu晚，总价格是：%@",self.night,self.totalPrice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)link2LivedScene:(id)sender {
    UITabBarController *index = [[self storyboard] instantiateViewControllerWithIdentifier:@"gatewayScene"];
    NSMutableArray *vcarr = [self.navigationController.viewControllers mutableCopy];
    [vcarr addObject:index];
    [self.navigationController setViewControllers:vcarr animated:YES];
    [self.navigationController popToViewController:index animated:YES];
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
