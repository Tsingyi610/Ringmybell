//
//  EvaluationViewController.m
//  impossible
//
//  Created by Blessed on 16/4/16.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "EvaluationViewController.h"
#import "RMBRequestManager.h"
#import "RMBDataSource.h"

@interface EvaluationViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation EvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"我的评价"];
    [self footerView:self.tableView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[RMBRequestManager sharedInstance] myComments:[RMBDataSource sharedInstance].pass completionHandler:^(NSString *errMsg, id data) {
        if (errMsg) {
            [self noData:@"您还没对您居住过房源评论。" onTableView:self.tableView];
        } else {
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma marks - UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [RMBDataSource sharedInstance].myComment.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"evaluationCell" forIndexPath:indexPath];
    cell.hnameLabel.text = [[[RMBDataSource sharedInstance].myComment objectAtIndex:indexPath.row] objectForKey:@"hname"];
    cell.commentLabel.text = [[[RMBDataSource sharedInstance].myComment objectAtIndex:indexPath.row] objectForKey:@"content"];
    cell.commentTime.text = [[[RMBDataSource sharedInstance].myComment objectAtIndex:indexPath.row] objectForKey:@"ctime"];
    NSInteger satisfaction = [[[[RMBDataSource sharedInstance].myComment objectAtIndex:indexPath.row] objectForKey:@"satisfaction"] integerValue];
    if (satisfaction <= 3) {
        cell.satisfactionImage.image = [UIImage imageNamed:@"ico_dislike"];
    } else {
        cell.satisfactionImage.image = [UIImage imageNamed:@"ico_appreciate"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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

@implementation EvaluationCell

@end
