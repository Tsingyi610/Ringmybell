//
//  LandlordProfileViewController.m
//  impossible
//
//  Created by Blessed on 16/4/24.
//  Copyright © 2016年 ringmybell. All rights reserved.
//
#define kHEAD_IMAGE_HEIGHT 200

#import "LandlordProfileViewController.h"
#import "RMBAFNetworking.h"
#import "RMBRequestManager.h"
#import "RMBDataSource.h"
#import "RMBUserInfo.h"

@interface LandlordProfileViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UIImageView *landlord;
    NSArray *identifiedType;
    NSArray *publishedHouseArr;
    RMBUserInfo *userinfo;
    NSMutableArray *houseImagePath;
    NSData *landlordImagePath;
}
@end

@implementation LandlordProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self changeNavigationLightVersion:@"房东资料"];
    self.tableView.contentInset = UIEdgeInsetsMake(kHEAD_IMAGE_HEIGHT, 0, 0, 0);
    UIView *footer = [UIView new];
    [self.tableView setTableFooterView:footer];
    
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
    identifiedType = @[@"a",@"b",@"c"];
    publishedHouseArr = @[@"a"];
    houseImagePath = [NSMutableArray arrayWithCapacity:0];
    [[RMBRequestManager sharedInstance] getUserInfo:self.uid completionHandler:^(NSString *errMsg, id data) {
        if (data) {
            userinfo = data;
            [[RMBRequestManager sharedInstance] getMyHouse:self.uid completionHandler:^(NSString *errMsg, id data) {
                if (data) {
                    for (NSDictionary *element in data) {
                        [[RMBAFNetworking sharedInstance] downloadHouseImage:[element objectForKey:@"himage"] completionHandler:^(NSString *errMsg, id filePath) {
                            if (filePath) {
                                NSData *fileData = [NSData dataWithContentsOfFile:filePath];
                                [houseImagePath addObject:fileData];
                                if (houseImagePath.count == [RMBDataSource sharedInstance].myHouse.count) {
                                    [self initLandlordImage];
                                }
                            }
                        }];
                    }
                }
            }];
        }
    }];
}

- (void)initLandlordImage {
    [[RMBAFNetworking sharedInstance] downloadUserHeadImage:userinfo.uimageurl completionHandler:^(NSString *errMsg, id filePath) {
        if (filePath) {
            NSData *fileData = [NSData dataWithContentsOfFile:filePath];
            landlordImagePath = fileData;
            landlord = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kHEAD_IMAGE_HEIGHT, self.view.frame.size.width, kHEAD_IMAGE_HEIGHT)];
            landlord.image = [UIImage imageWithData:fileData];
            landlord.clipsToBounds = YES;
            landlord.contentMode = UIViewContentModeScaleAspectFill;
            [self.tableView addSubview:landlord];
            [self.tableView reloadData];
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y+64;
    if (y < -kHEAD_IMAGE_HEIGHT) {
        CGRect frame = landlord.frame;
        frame.origin.y = y;
        frame.size.height = -y;
        landlord.frame = frame;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4+houseImagePath.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        LandlordProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"landlordProfileCell" forIndexPath:indexPath];
        cell.landlordName.text = userinfo.uname;
        cell.enrolTime.text = [NSString stringWithFormat:@"注册时间:%@",userinfo.utime];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (1 == indexPath.row) {
        IdentifyCell *identify = [tableView dequeueReusableCellWithIdentifier:@"checkedCell" forIndexPath:indexPath];
        identify.selectionStyle = UITableViewCellSelectionStyleNone;
        identify.identifyType.hidden = YES;
        identify.identifyTypeImage.hidden = YES;
        return identify;
    } else if (2 <= indexPath.row && identifiedType.count > indexPath.row) {
        IdentifyCell *identify = [tableView dequeueReusableCellWithIdentifier:@"checkedCell" forIndexPath:indexPath];
        identify.selectionStyle = UITableViewCellSelectionStyleNone;
        identify.identifyDesc.hidden = YES;
        identify.identifyTypeImage.hidden = NO;
        identify.identifyType.hidden = NO;
        return identify;
    } else if (identifiedType.count == indexPath.row) {
        PublishedHouseCell *published = [tableView dequeueReusableCellWithIdentifier:@"publishedCell" forIndexPath:indexPath];
        published.selectionStyle = UITableViewCellSelectionStyleNone;
        published.publishedImage.hidden = YES;
        published.publishedHouseName.hidden = YES;
        published.location.hidden = YES;
        if (houseImagePath.count ==0) {
            published.numberOfPublished.text = @"该用户还没发布房源";
        } else {
            published.numberOfPublished.text = [NSString stringWithFormat:@"%lu个房源",houseImagePath.count];
        }
        return published;
    } else {
        PublishedHouseCell *published = [tableView dequeueReusableCellWithIdentifier:@"publishedCell" forIndexPath:indexPath];
        published.selectionStyle = UITableViewCellSelectionStyleNone;
        published.publishedImage.hidden = NO;
        published.publishedImage.image = [UIImage imageWithData:[houseImagePath objectAtIndex:indexPath.row-4]];
        published.publishedHouseName.text = [[[RMBDataSource sharedInstance].myHouse objectAtIndex:indexPath.row-4] objectForKey:@"hname"];
        published.publishedHouseName.hidden = NO;
        published.location.hidden = NO;
        published.location.text = [[[RMBDataSource sharedInstance].myHouse objectAtIndex:indexPath.row-4] objectForKey:@"city"];
        published.numberOfPublished.hidden = YES;
        return published;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        return 60;
    } else if (1 <= indexPath.row && identifiedType.count > indexPath.row) {
        return 44;
    } else if (identifiedType.count == indexPath.row){
        return 80;
    } else {
        return 80;
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

@implementation LandlordProfileCell

@end

@implementation IdentifyCell

@end

@implementation PublishedHouseCell

@end
