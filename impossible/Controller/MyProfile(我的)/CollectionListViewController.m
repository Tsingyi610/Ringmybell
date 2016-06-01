//
//  CollectionListViewController.m
//  impossible
//
//  Created by Blessed on 16/5/20.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "CollectionListViewController.h"
#import "ShowHouseViewController.h"
#import "RMBRequestManager.h"
#import "RMBDataSource.h"
#import "RMBAFNetworking.h"
#import "MRProgress.h"

@interface CollectionListViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *sandboxImagePath;
    NSMutableArray *headImage;
}
@end

@implementation CollectionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"我的收藏房源"];
    [self footerView:self.tableView];
    [self initLongGesture];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [RMBDataSource sharedInstance].customCollectionList = @[];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initLongGesture {
    UILongPressGestureRecognizer *tap2delete = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(changeDtag:)];
    tap2delete.minimumPressDuration = 0.5;
    [self.tableView addGestureRecognizer:tap2delete];
}

- (void)changeDtag:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [gesture locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        if (indexPath) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if ([cell isKindOfClass:[CollectionListCell class]]) {
                    NSString *cname = [[[RMBDataSource sharedInstance].customCollectionList objectAtIndex:indexPath.row] objectForKey:@"hname"];
                    NSString *show = [NSString stringWithFormat:@"%@...",[cname substringToIndex:3]];
                    UIAlertController *sure2dtag = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确认删除 %@ 房源吗？",show] message:@"该操作会将该房源从该收藏列表中移除" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction *destructAction = [UIAlertAction actionWithTitle:@"确定删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        [MRProgressOverlayView showOverlayAddedTo:self.view title:@"正在删除..." mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
                        [[RMBRequestManager sharedInstance] dtagSingleHouse:self.ucid hid:[[[[RMBDataSource sharedInstance].customCollectionList objectAtIndex:indexPath.row] objectForKey:@"hid"] integerValue] uid:[RMBDataSource sharedInstance].pass completionHandler:^(NSString *errMsg, id data) {
                            if (data) {
                                [MRProgressOverlayView dismissOverlayForView:self.view animated:YES completion:^{
                                    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"删除成功" mode:MRProgressOverlayViewModeCheckmark animated:YES];
                                    [self initData];
                                    dispatch_time_t delay_time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC));
                                    dispatch_after(delay_time, dispatch_get_main_queue(), ^{
                                        [self.tableView reloadData];
                                        [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
                                    });
                                }];
                            }
                        }];
                    }];
                    
                    [sure2dtag addAction:destructAction];
                    [sure2dtag addAction:cancelAction];
                    
                    [self presentViewController:sure2dtag animated:YES completion:nil];
            }
        }
    }
}

- (void)initData {
    sandboxImagePath = [NSMutableArray arrayWithCapacity:0];
    headImage = [NSMutableArray arrayWithCapacity:0];
    [[RMBRequestManager sharedInstance] getCollectionHouseList:self.ucid uid:[RMBDataSource sharedInstance].pass completionHandler:^(NSString *errMsg, id data) {
        if (errMsg) {
            [self noData:errMsg onTableView:self.tableView];
        } else {
            for (NSDictionary *element in data) {
                [[RMBAFNetworking sharedInstance] downloadHouseImage:[element objectForKey:@"himage"] completionHandler:^(NSString *errMsg, id filePath) {
                    if (filePath) {
                        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
                        [sandboxImagePath addObject:fileData];
                        if (sandboxImagePath.count == [RMBDataSource sharedInstance].customCollectionList.count) {
                            for (NSDictionary *element in data) {
                                [[RMBAFNetworking sharedInstance] downloadUserHeadImage:[element objectForKey:@"uimage"] completionHandler:^(NSString *errMsg, id filePath) {
                                    if (filePath) {
                                        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
                                        [headImage addObject:fileData];
                                        [self.tableView reloadData];
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

#pragma mark - uitableview delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [RMBDataSource sharedInstance].customCollectionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collectionListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.hname.text = [[[RMBDataSource sharedInstance].customCollectionList objectAtIndex:indexPath.row] objectForKey:@"hname"];
    cell.cityname.text = [[[RMBDataSource sharedInstance].customCollectionList objectAtIndex:indexPath.row] objectForKey:@"cityname"];
    if (headImage.count ==0) {
        cell.uimage.image = [UIImage imageNamed:@"avatar"];
    } else {
        cell.uimage.image = [UIImage imageWithData:[headImage objectAtIndex:indexPath.row]];
    }
    //cell.uimage.image = [UIImage imageWithData:[headImage objectAtIndex:indexPath.row]];
    cell.uimage.contentMode = UIViewContentModeScaleToFill;
    if (sandboxImagePath.count ==0) {
        cell.himage.image = [UIImage imageNamed:@"explore_1"];
    } else {
        cell.himage.image = [UIImage imageWithData:[sandboxImagePath objectAtIndex:indexPath.row]];
    }
    cell.himage.contentMode = UIViewContentModeScaleToFill;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowHouseViewController *singleHouse = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"showHouseScene"];
    singleHouse.hid = [[[[RMBDataSource sharedInstance].customCollectionList objectAtIndex:indexPath.row] objectForKey:@"hid"] integerValue];
    singleHouse.himageData = [sandboxImagePath objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:singleHouse animated:YES];
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

@implementation CollectionListCell

@end
