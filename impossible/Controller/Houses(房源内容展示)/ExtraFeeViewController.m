//
//  ExtraFeeViewController.m
//  impossible
//
//  Created by Blessed on 16/3/28.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "ExtraFeeViewController.h"
#import "RMBRequestManager.h"
#import "RMBDataSource.h"

@interface ExtraFeeViewController ()

@end

@implementation ExtraFeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData:self.hid];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData:(NSInteger)hid {
    self.weekDiscountNum.hidden = YES;
    self.weekDiscount.hidden = YES;
    self.monthDiscountNum.hidden = YES;
    self.monthDiscount.hidden = YES;
    if (1 == self.distinguish) {
        self.strategy.text = @"请稍等";
        [[RMBRequestManager sharedInstance] getHouseStrategy:hid completionHandler:^(NSString *errMsg, id data) {
            if (data) {
                NSInteger week = [[data objectForKey:@"week_extrafee"] integerValue];
                NSInteger month = [[data objectForKey:@"mon_extrafee"] integerValue];
                self.weekDiscountNum.text = [NSString stringWithFormat:@"%lu%%",week];
                self.monthDiscountNum.text = [NSString stringWithFormat:@"%lu%%",month];
                self.strategy.hidden = YES;
                self.weekDiscountNum.hidden = NO;
                self.weekDiscount.hidden = NO;
                self.monthDiscountNum.hidden = NO;
                self.monthDiscount.hidden = NO;
            }
        }];
    }
    if (2 == self.distinguish) {
        self.strategy.text = @"请稍等";
        [[RMBRequestManager sharedInstance] getStrategyByhid:hid completionHandler:^(NSString *errMsg, id data) {
            if (data) {
                NSString *text = [[data objectAtIndex:0] stringByReplacingOccurrencesOfString:@"<br>" withString:@"\r\n"];
                self.strategy.text = text;
            }
        }];
    }
    if (3 == self.distinguish) {
        self.strategy.text = @"该功能系统暂不支持";
    }
    //rule
    if (4 == self.distinguish) {
        self.strategy.text = @"请稍等";
        [[RMBRequestManager sharedInstance] getHouseRule:hid completionHandler:^(NSString *errMsg, id data) {
            if (data) {
                self.strategy.text = data;
            }
        }];
    }
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
