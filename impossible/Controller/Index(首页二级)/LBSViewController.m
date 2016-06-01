//
//  LBSViewController.m
//  impossible
//
//  Created by Blessed on 16/4/26.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "LBSViewController.h"
#import "ShowHouseViewController.h"
#import "RMBLBSList.h"
#import "RMBRequestManager.h"
#import "RMBAFNetworking.h"
#import "MRProgress.h"

@interface LBSViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSArray *listData;
    NSMutableArray *imageData;
    NSMutableArray *headData;
}
@end

@implementation LBSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"发现"];
    [self footerView:self.tableView];
    [self initData];
    NSLog(@"%@",[NSString stringWithFormat:@"离我%.2fkm",(double)arc4random()/1000000000]);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"正在定位和加载..." mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    listData = [NSArray array];
    imageData = [NSMutableArray arrayWithCapacity:0];
    headData = [NSMutableArray arrayWithCapacity:0];
    [[RMBRequestManager sharedInstance] getLBSHouseList:self.cityid completionHandler:^(NSString *errMsg, id data) {
        if (errMsg) {
            [self noData:errMsg onTableView:self.tableView];
            listData = @[];
            [self.tableView reloadData];
        } else {
            listData = data;
            for (RMBLBSList *element in data) {
                [[RMBAFNetworking sharedInstance] downloadHouseImage:element.himage completionHandler:^(NSString *errMsg, id filePath) {
                    if (filePath) {
                        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
                        [imageData addObject:fileData];
                        if (imageData.count == listData.count) {
                            for (RMBLBSList *element in data) {
                                [[RMBAFNetworking sharedInstance] downloadUserHeadImage:element.uimage completionHandler:^(NSString *errMsg, id filePath) {
                                    if (filePath) {
                                        NSData *uimageData = [NSData dataWithContentsOfFile:filePath];
                                        [headData addObject:uimageData];
                                        if (headData.count == listData.count) {
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LBSCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lbsCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RMBLBSList *element = [listData objectAtIndex:indexPath.row];
    cell.hname.text = element.hname;
    cell.hlocation.text = element.cityname;
    cell.distance.text = [NSString stringWithFormat:@"离我%.2fkm",(double)arc4random()/1000000000];
    cell.himage.image = [UIImage imageWithData:[imageData objectAtIndex:indexPath.row]];
    cell.hdesc.text = element.hdesc;
    cell.goodSatisfaction.hidden = YES;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return listData.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShowHouseViewController *houseScene = [[self storyboard] instantiateViewControllerWithIdentifier:@"showHouseScene"];
    RMBLBSList *element = [listData objectAtIndex:indexPath.row];
    houseScene.hid = element.hid;
    houseScene.uimageData = [headData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:houseScene animated:YES];
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

@implementation LBSCell

@end