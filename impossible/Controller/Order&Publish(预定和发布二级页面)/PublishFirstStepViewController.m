//
//  PublishFirstStepViewController.m
//  impossible
//
//  Created by Blessed on 16/4/27.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "PublishFirstStepViewController.h"
#import "PublishSecondStepViewController.h"
#import "RMBDataSource.h"

@interface PublishFirstStepViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSArray *imageArr;
    NSArray *typeArr;
    NSArray *typeDescArr;
}
@end

@implementation PublishFirstStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"发布空间"];
    imageArr = @[@"ico_publish_whole",@"ico_publish_single",@"ico_publish_share"];
    typeArr = @[@"整套房屋",@"独立房间",@"合住空间"];
    typeDescArr = @[@"您的整套房子",@"您房子里的一个单人房间",@"一张沙发、一张气垫床等"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        IntroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"introCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        HouseTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"houseTypeCell" forIndexPath:indexPath];
        cell.typeImage.image = [UIImage imageNamed:[imageArr objectAtIndex:indexPath.row-1]];
        cell.houseType.text = [typeArr objectAtIndex:indexPath.row-1];
        cell.houseTypeDesc.text = [typeDescArr objectAtIndex:indexPath.row-1];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (0 != indexPath.row) {
        PublishSecondStepViewController *second = [[self storyboard] instantiateViewControllerWithIdentifier:@"secondStepScene"];
        second.receivedTag = indexPath.row;
        [RMBDataSource sharedInstance].htype = indexPath.row;
        [self.navigationController pushViewController:second animated:YES];
    } else {
        return;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        return self.tableView.frame.size.height/2;
    } else {
        return (self.tableView.frame.size.height/2-64)/3;
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

@implementation IntroCell

@end

@implementation HouseTypeCell

@end