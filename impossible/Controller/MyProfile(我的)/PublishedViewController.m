//
//  PublishedViewController.m
//  impossible
//
//  Created by Blessed on 16/4/8.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "PublishedViewController.h"
#import "EditHouseProfileViewController.h"
#import "RMBRequestManager.h"
#import "RMBDataSource.h"
#import "RMBAFNetworking.h"
#import "MRProgress.h"

@interface PublishedViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *sandboxImagePath;
}
@end

@implementation PublishedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"我的房源"];
    [self footerView:self.tableView];
    //self.tableView.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initData];
}

- (void)initData {
    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"正在加载..." mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    sandboxImagePath = [NSMutableArray arrayWithCapacity:0];
    [[RMBRequestManager sharedInstance] getMyHouse:[RMBDataSource sharedInstance].pass completionHandler:^(NSString *errMsg, id data) {
        if (errMsg) {
            [self noData:@"您还没有自己的房源，首页可添加。" onTableView:self.tableView];
            [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
        }
        for (NSDictionary *element in data) {
            [[RMBAFNetworking sharedInstance] downloadHouseImage:[element objectForKey:@"himage"] completionHandler:^(NSString *errMsg, id filePath) {
                if (filePath) {
                    NSData *filedata = [NSData dataWithContentsOfFile:filePath];
                    [sandboxImagePath addObject:filedata];
                    if (sandboxImagePath.count == [RMBDataSource sharedInstance].myHouse.count) {
                        [self.tableView reloadData];
                        [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
                    }
                }
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma marks - uitableview method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [RMBDataSource sharedInstance].myHouse.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PublishedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"publishedCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    NSString *hname = [[[RMBDataSource sharedInstance].myHouse objectAtIndex:indexPath.row] objectForKey:@"hname"];
    if ([hname isKindOfClass:[NSNull class]]) {
        cell.hnameLabel.text = @"房源名称为空";
    } else {
        cell.hnameLabel.text = hname;
    }
    cell.hcityAndProvince.text = [NSString stringWithFormat:@"%@，%@",[[[RMBDataSource sharedInstance].myHouse objectAtIndex:indexPath.row] objectForKey:@"city"],[[[RMBDataSource sharedInstance].myHouse objectAtIndex:indexPath.row] objectForKey:@"province"]];
    NSString *pt = [[[RMBDataSource sharedInstance].myHouse objectAtIndex:indexPath.row]objectForKey:@"published_time"];
    if ([pt isEqualToString:@"None"]) {
        cell.publishedTime.text = @"该房源未发布，点击进行修改和发布";
    } else {
        cell.publishedTime.text = [NSString stringWithFormat:@"于 %@ 发布",pt];
    }
    if (sandboxImagePath.count == 0) {
        cell.himage.image = [UIImage imageNamed:@"explore_2"];
    } else {
        cell.himage.image = [UIImage imageWithData:[sandboxImagePath objectAtIndex:indexPath.row]];
    }
    cell.himage.contentMode = UIViewContentModeScaleAspectFill;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EditHouseProfileViewController *editHouse = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"editHouseScene"];
    [RMBDataSource sharedInstance].hid = [[[[RMBDataSource sharedInstance].myHouse objectAtIndex:indexPath.row] objectForKey:@"hid"] integerValue];
    NSString *pt = [[[RMBDataSource sharedInstance].myHouse objectAtIndex:indexPath.row]objectForKey:@"published_time"];
    if (![pt isEqualToString:@"None"]) {
        editHouse.changeButton = @"返回";
    }
    [[RMBRequestManager sharedInstance] getEditHouseInfor:[RMBDataSource sharedInstance].hid completionHandler:^(NSString *errMsg, id data) {
        if (data) {
            [self.navigationController pushViewController:editHouse animated:YES];
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

@implementation PublishedCell

@end
