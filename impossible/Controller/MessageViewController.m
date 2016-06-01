//
//  MessageViewController.m
//  impossible
//
//  Created by Blessed on 16/3/4.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "MessageViewController.h"
#import "RMBDataSource.h"
#import "RMBRequestManager.h"
#import "ChattingViewController.h"
#import "MRProgress.h"

@interface MessageViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *lastContentArray;
    NSMutableArray *houseInfoArray;
    NSArray *sortedHouse;
    NSInteger done;
}
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *footerView = [UIView new];
    [self.tableView setTableFooterView:footerView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changeStatusBar:@"white"];
    self.navigationController.navigationBar.hidden = YES;
    [self initData];
}

- (void)initData {
    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"正在加载信息..." mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    lastContentArray = [NSMutableArray arrayWithCapacity:0];
    houseInfoArray = [NSMutableArray arrayWithCapacity:0];
    sortedHouse = [NSArray array];
    done = 0;
    [[RMBRequestManager sharedInstance] initMessageListByUid:[RMBDataSource sharedInstance].pass completionHandler:^(NSString *errMsg, id data) {
        if (errMsg) {
            [self noData:@"还没有预定和收到预定消息" onTableView:self.tableView];
            [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
        } else {
            for (NSString *applyid in [RMBDataSource sharedInstance].messageApplyid) {
                [[RMBRequestManager sharedInstance] getHouseByApplyID:applyid completionHandler:^(NSString *errMsg, id data) {
                    if (data) {
                        [houseInfoArray addObject:data];
                        if (houseInfoArray.count == [RMBDataSource sharedInstance].messageApplyid.count) {
                            for (NSString *applyid in [RMBDataSource sharedInstance].messageApplyid) {
                                [[RMBRequestManager sharedInstance] getLatestMessage:applyid completionHandler:^(NSString *errMsg, id data) {
                                    if (data) {
                                        [lastContentArray addObject:data];
                                        if (lastContentArray.count == [RMBDataSource sharedInstance].messageApplyid.count) {
                                            NSArray *sortArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"order_time" ascending:NO]];
                                            NSArray *sorted = [houseInfoArray sortedArrayUsingDescriptors:sortArray];
                                            sortedHouse = sorted;
                                            [self.tableView reloadData];
                                            [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
                                        }
                                    }
                                }];
                            }
                        }
                    }
                }];
            }
        }
    }];
}

#pragma marks - UITableView methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NormalMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.hname.text = [[sortedHouse objectAtIndex:indexPath.row] objectForKey:@"hname"];
    cell.lastContent.text = [lastContentArray objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [RMBDataSource sharedInstance].messageApplyid.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    static NSString *identify = @"chatScene";
    ChattingViewController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:identify];
    controller.applyid = [[RMBDataSource sharedInstance].messageApplyid objectAtIndex:indexPath.row];
    controller.hid = [[[houseInfoArray objectAtIndex:indexPath.row] objectForKey:@"hid"] integerValue];
    controller.landlordName = [[houseInfoArray objectAtIndex:indexPath.row] objectForKey:@"uname"];
    controller.uid = [[[houseInfoArray objectAtIndex:indexPath.row] objectForKey:@"uid"] integerValue];
    controller.username = [[houseInfoArray objectAtIndex:indexPath.row] objectForKey:@"username"];
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

@implementation NormalMessageCell

@end
