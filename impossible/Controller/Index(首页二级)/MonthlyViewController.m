//
//  MonthlyViewController.m
//  impossible
//
//  Created by Blessed on 16/4/26.
//  Copyright © 2016年 ringmybell. All rights reserved.
//
#define kHEAD_IMAGE_HEIGHT 120

#import "MonthlyViewController.h"
#import "ShowHouseViewController.h"
#import "Masonry.h"
#import "RMBDataSource.h"
#import "RMBActivityHouse.h"
#import "RMBRequestManager.h"
#import "RMBAFNetworking.h"
#import "MRProgress.h"

@interface MonthlyViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UIImageView *header;
    UILabel *text;
    NSMutableArray *dataArr;
    NSArray *type;
    NSMutableArray *imageArr;
    NSMutableArray *uimageArr;
}
@end

@implementation MonthlyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeader];
    dataArr = [NSMutableArray arrayWithCapacity:0];
    UIView *footer = [[UIView alloc] init];
    [self.tableView setTableFooterView:footer];
    type = @[@"整套房子",@"独立房间",@"合住房间"];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
}

- (void)initData {
    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"正在加载..." mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    if (1000 == self.relyTag) {
        [self changeNavigationLightVersion:@"每月推荐"];
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        NSInteger month = [dateComponent month];
        [[RMBRequestManager sharedInstance] getMonthlyRecommendTheme:[NSString stringWithFormat:@"%lu",month] completionHandler:^(NSString *errMsg, id data) {
            if (data) {
                text.text = [NSString stringWithFormat:@"给您精选的%@月理想房源",[[RMBDataSource sharedInstance].monthlyThemeDic objectForKey:@"month"]];
                [[RMBRequestManager sharedInstance] getMonthlyRecommendHouseList:[[RMBDataSource sharedInstance].monthlyThemeDic objectForKey:@"rid"] completionHandler:^(NSString *errMsg, id data) {
                    if (data) {
                        dataArr = data;
                        [self initHouseImage];
                    }
                }];
            }
        }];
    } else {
        [self changeNavigationLightVersion:@"精选活动"];
        [[RMBRequestManager sharedInstance] getBottomThreeActivityHouseList:self.acid completionHandler:^(NSString *errMsg, id data) {
            if (data) {
                text.text = self.headerLabelText;
                dataArr = data;
                [self initHouseImage];
            }
        }];
    }
}

- (void)initHouseImage {
    imageArr = [NSMutableArray arrayWithCapacity:0];
    for (RMBActivityHouse *element in dataArr) {
        [[RMBAFNetworking sharedInstance] downloadHouseImage:element.himage completionHandler:^(NSString *errMsg, id filePath) {
            if (filePath) {
                NSData *fileData = [NSData dataWithContentsOfFile:filePath];
                [imageArr addObject:fileData];
                if (imageArr.count == dataArr.count) {
                    [self initUserImage];
                }
            }
        }];
    }
}

- (void)initUserImage {
    uimageArr = [NSMutableArray arrayWithCapacity:0];
    for (RMBActivityHouse *element in dataArr) {
        [[RMBAFNetworking sharedInstance] downloadHouseImage:element.uimage completionHandler:^(NSString *errMsg, id filePath) {
            if (filePath) {
                NSData *fileData = [NSData dataWithContentsOfFile:filePath];
                [uimageArr addObject:fileData];
                if (uimageArr.count == dataArr.count) {
                    [self.tableView reloadData];
                    [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
                }
            }
        }];
    }
}

- (void)initHeader {
    self.tableView.contentInset = UIEdgeInsetsMake(kHEAD_IMAGE_HEIGHT, 0, 0, 0);
    header = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kHEAD_IMAGE_HEIGHT, self.view.frame.size.width, kHEAD_IMAGE_HEIGHT)];
    if (1000 == self.relyTag) {
        header.image = [UIImage imageNamed:self.monthImage];
    } else {
        header.image = [UIImage imageWithData:self.headerImage];
    }
    header.clipsToBounds = YES;
    header.contentMode = UIViewContentModeScaleAspectFill;
    [self.tableView addSubview:header];
//    UIView *cover = [UIView new];
//    cover.backgroundColor = [UIColor blackColor];
//    cover.alpha = 0.5f;
//    [header addSubview:cover];
//    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(cover.superview).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
    UIView *clear = [UIView new];
    [header addSubview:clear];
    clear.backgroundColor = [UIColor clearColor];
    clear.alpha = 1.0f;
    [clear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(clear.superview).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    text = [[UILabel alloc] init];
    text.alpha = 1.0f;
    text.font = [UIFont systemFontOfSize:16 weight:1.0];
    text.textColor = [UIColor whiteColor];
    text.textAlignment = NSTextAlignmentCenter;
    [clear addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(text.superview).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y+64;
    if (y < -kHEAD_IMAGE_HEIGHT) {
        CGRect frame = header.frame;
        frame.origin.y = y;
        frame.size.height = -y;
        header.frame = frame;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (1000 == self.relyTag) {
        if (0 == indexPath.row) {
            StaticCell *cell = [tableView dequeueReusableCellWithIdentifier:@"staticCell" forIndexPath:indexPath];
            cell.recommendContent.text = [[RMBDataSource sharedInstance].monthlyThemeDic objectForKey:@"theme"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recommendListCell" forIndexPath:indexPath];
            RMBActivityHouse *list = [dataArr objectAtIndex:indexPath.row-1];
            cell.himage.image = [UIImage imageWithData:imageArr[indexPath.row-1]];
            cell.himage.contentMode = UIViewContentModeScaleAspectFill;
            if (uimageArr.count != 0) {
               cell.uimage.image = [UIImage imageWithData:uimageArr[indexPath.row-1]];
            } else {
                cell.uimage.image = [UIImage imageNamed:@"avatar"];
            }
            
            cell.uimage.contentMode = UIViewContentModeScaleAspectFill;
            cell.hname.text = list.hname;
            cell.htype.text = type[list.htype-1];
            cell.cityname.text = list.cityname;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    } else {
        if (0 == indexPath.row) {
            StaticCell *cell = [tableView dequeueReusableCellWithIdentifier:@"staticCell" forIndexPath:indexPath];
            cell.recommendContent.text = [NSString stringWithFormat:@"想%@ ，那就来预定这些房源吧",text.text];
            cell.recommendImage.hidden = YES;
            cell.caTitle.text = @"参考房源推荐";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recommendListCell" forIndexPath:indexPath];
            RMBActivityHouse *list = [dataArr objectAtIndex:indexPath.row-1];
            cell.himage.image = [UIImage imageWithData:imageArr[indexPath.row-1]];
            cell.himage.contentMode = UIViewContentModeScaleAspectFill;
            cell.uimage.image = [UIImage imageWithData:uimageArr[indexPath.row-1]];
            cell.uimage.contentMode = UIViewContentModeScaleAspectFill;
            cell.hname.text = list.hname;
            cell.htype.text = type[list.htype-1];
            cell.cityname.text = list.cityname;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        return 80;
    } else {
        return 240;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 != indexPath.row) {
        ShowHouseViewController *houseScene = [[self storyboard] instantiateViewControllerWithIdentifier:@"showHouseScene"];
        RMBActivityHouse *house = [dataArr objectAtIndex:indexPath.row-1];
        houseScene.hid = house.hid;
        houseScene.himageData = [imageArr objectAtIndex:indexPath.row-1];
        houseScene.uimageData = [uimageArr objectAtIndex:indexPath.row-1];
        [self.navigationController pushViewController:houseScene animated:YES];
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

@implementation StaticCell

@end

@implementation RecommendCell

@end