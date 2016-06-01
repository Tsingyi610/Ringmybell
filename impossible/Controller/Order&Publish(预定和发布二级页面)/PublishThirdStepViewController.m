//
//  PublishThirdStepViewController.m
//  impossible
//
//  Created by Blessed on 16/4/28.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "PublishThirdStepViewController.h"
#import "EditHouseProfileViewController.h"
#import "RMBDataSource.h"
#import "RMBRequestManager.h"

@interface PublishThirdStepViewController ()
{
    NSArray *typeArr;
    NSMutableArray *info;
}
@end

@implementation PublishThirdStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"房间和床位"];
    typeArr = @[@"整套房屋",@"独立房间",@"合住空间"];
    [self initData:self.receivedTag];
    // Do any additional setup after loading the view.
}

- (void)initData:(NSInteger)tag {
    self.introLabel.text = [NSString stringWithFormat:@"关于您的%@的更多一些信息...",typeArr[tag]];
    info = [NSMutableArray arrayWithObjects:@"3",@"1",@"1",@"1", nil];
    self.maxVisitors.text = [info objectAtIndex:0];
    self.bedroom.text = [info objectAtIndex:1];
    self.bed.text = [info objectAtIndex:2];
    self.bathroom.text = [info objectAtIndex:3];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)removeAction:(UIButton*)sender {
    int temp = [[info objectAtIndex:sender.tag] intValue];
    if (1 == temp) {
        return;
    }
    temp--;
    NSString *tempStr = [NSString stringWithFormat:@"%d",temp];
    switch (sender.tag) {
        case 0:
            self.maxVisitors.text = tempStr;
            break;
        case 1:
            self.bedroom.text = tempStr;
            break;
        case 2:
            self.bed.text = tempStr;
            break;
        case 3:
            self.bathroom.text = tempStr;
            break;
        default:
            break;
    }
    [info replaceObjectAtIndex:sender.tag withObject:tempStr];
}
- (IBAction)addAction:(UIButton*)sender {
    int temp = [[info objectAtIndex:sender.tag] intValue];
    if (10 == temp) {
        return;
    }
    temp++;
    NSString *tempStr = [NSString stringWithFormat:@"%d",temp];
    switch (sender.tag) {
        case 0:
            self.maxVisitors.text = tempStr;
            break;
        case 1:
            self.bedroom.text = tempStr;
            break;
        case 2:
            self.bed.text = tempStr;
            break;
        case 3:
            self.bathroom.text = tempStr;
            break;
        default:
            break;
    }
    [info replaceObjectAtIndex:sender.tag withObject:tempStr];
}
- (IBAction)link2editHouseProfile:(id)sender {
    EditHouseProfileViewController *fillVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"editHouseScene"];
    [RMBDataSource sharedInstance].maxVisitors = self.maxVisitors.text;
    [RMBDataSource sharedInstance].bedroom = self.bedroom.text;
    [RMBDataSource sharedInstance].bed = self.bed.text;
    [RMBDataSource sharedInstance].bathroom = self.bathroom.text;
    [RMBDataSource sharedInstance].minEvenings = @"1";
    [[RMBRequestManager sharedInstance] insertHouseMainSheet:[RMBDataSource sharedInstance].pass htype:[RMBDataSource sharedInstance].htype cityid:[RMBDataSource sharedInstance].cityid maxVisitors:[RMBDataSource sharedInstance].maxVisitors.integerValue hroom:[RMBDataSource sharedInstance].bedroom.integerValue hbed:[RMBDataSource sharedInstance].bed.integerValue hbathroom:[RMBDataSource sharedInstance].bathroom.integerValue completionHandler:^(NSString *errMsg, id data) {
        if (errMsg) {
            
        } else {
          [self.navigationController pushViewController:fillVC animated:YES];
        }
    }];
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
