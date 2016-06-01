//
//  HouseNamedViewController.m
//  impossible
//
//  Created by Blessed on 16/3/17.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "HouseNamedViewController.h"

@interface HouseNamedViewController ()

@end

@implementation HouseNamedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat original = self.houseNamedLabel.frame.size.height;
    CGFloat originalView = self.houseNamedView.frame.size.height;
    self.houseNamedLabel.text = @"撒旦法萨芬";
    CGFloat changeHeight = self.houseNamedLabel.frame.size.height - original;
    CGFloat overall = originalView + changeHeight;
    self.houseNamedView.frame = CGRectMake(0, 0, 320, overall);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
