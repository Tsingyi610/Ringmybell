
//
//  GetMessageViewController.m
//  impossible
//
//  Created by Blessed on 16/4/17.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "GetMessageViewController.h"
#import "MJRefresh.h"

@interface GetMessageViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation GetMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"收到的预定"];
    [self mjRefresh];
    [self footerView:self.tableView];
    // Do any additional setup after loading the view.
}

- (void)mjRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"refresh!!!!");
        //[self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    //self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
}

- (void)loadNewData {
    NSLog(@"callback");
    [self.tableView.mj_header endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma marks - UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GetMessagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"getMessageCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

@implementation GetMessagesCell

@end
