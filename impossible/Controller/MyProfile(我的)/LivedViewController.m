//
//  LivedViewController.m
//  impossible
//
//  Created by Blessed on 16/4/12.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "LivedViewController.h"
#import "IndexViewController.h"
#import "RMBDataSource.h"
#import "RMBRequestManager.h"
#import "RMBAFNetworking.h"
#import "MakeCommentViewController.h"

@interface LivedViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *sandboxImagePath;
}
@end

@implementation LivedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"我的足迹"];
    [self footerView:self.tableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initData];
}

- (void)initData {
    sandboxImagePath = [NSMutableArray arrayWithCapacity:0];
    [[RMBRequestManager sharedInstance] livedHouseInformation:[RMBDataSource sharedInstance].pass completionHandler:^(NSString *errMsg, id data) {
        if (errMsg) {
            [self noData:@"您暂时还没有居住过的房源！" onTableView:self.tableView];
        } else {
            for (NSDictionary *element in data) {
                [[RMBAFNetworking sharedInstance] downloadHouseImage:[element objectForKey:@"himage"] completionHandler:^(NSString *errMsg, id filePath) {
                    if (filePath) {
                        NSData *filedata = [NSData dataWithContentsOfFile:filePath];
                        [sandboxImagePath addObject:filedata];
                        if (sandboxImagePath.count == [RMBDataSource sharedInstance].myStep.count) {
                            [self.tableView reloadData];
                        }
                    }
                }];
            }
        }
    }];
}

#pragma marks - UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [RMBDataSource sharedInstance].myStep.count;
    //return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LivedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"livedCell" forIndexPath:indexPath];
    cell.hnameLabel.text = [[[RMBDataSource sharedInstance].myStep objectAtIndex:indexPath.row] objectForKey:@"hname"];
    cell.beginTime.text = [NSString stringWithFormat:@"居住时间：%@",[[[[RMBDataSource sharedInstance].myStep objectAtIndex:indexPath.row] objectForKey:@"begin_time"] substringToIndex:10]];
    if (sandboxImagePath.count == 0) {
        cell.houseImage.image = [UIImage imageNamed:@"explore_2"];
    } else {
        cell.houseImage.image = [UIImage imageWithData:[sandboxImagePath objectAtIndex:indexPath.row]];
    }
    if ([self.comment containsObject:[[[RMBDataSource sharedInstance].myStep objectAtIndex:indexPath.row] objectForKey:@"hid"]]) {
        cell.isComment.text = @"已评价";
        cell.userInteractionEnabled = NO;
    } else {
        cell.isComment.text = @"该房源您还未给出评价";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //link 2 make comment!
    MakeCommentViewController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"makeCommentScene"];
    controller.hnameReceive = [[[RMBDataSource sharedInstance].myStep objectAtIndex:indexPath.row] objectForKey:@"hname"];
    controller.imageData = [sandboxImagePath objectAtIndex:indexPath.row];
    controller.total_price = [NSString stringWithFormat:@"%@",[[[RMBDataSource sharedInstance].myStep objectAtIndex:indexPath.row] objectForKey:@"total_price"]];
    controller.begin_time = [[[RMBDataSource sharedInstance].myStep objectAtIndex:indexPath.row] objectForKey:@"begin_time"];
    controller.hid = [[[[RMBDataSource sharedInstance].myStep objectAtIndex:indexPath.row] objectForKey:@"hid"] integerValue];
    [self.navigationController pushViewController:controller animated:YES];
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

@implementation LivedCell

@end