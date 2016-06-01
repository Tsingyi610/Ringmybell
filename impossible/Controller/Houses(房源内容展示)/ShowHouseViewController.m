//
//  ShowHouseViewController.m
//  impossible
//
//  Created by Blessed on 16/3/17.
//  Copyright © 2016年 ringmybell. All rights reserved.
//
#define kHEAD_IMAGE_HEIGHT 150

#import "ShowHouseViewController.h"
#import "ConfirmOrderViewController.h"
#import "ExtraFeeViewController.h"
#import "LandlordProfileViewController.h"
#import "SpecificView.h"
#import "RMBRequestManager.h"
#import "RMBSingleHouse.h"
#import "RMBUserInfo.h"
#import "RMBDataSource.h"
#import "RMBAFNetworking.h"
#import "UITableViewCell+CurrentVC.h"
#import "UIViewController+CurrentVC.h"
#import "UIView+Autolayout.h"
#import "UIView+Constraint.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import "MRProgress.h"
#import "UIColor+Extra.h"

@interface ShowHouseViewController () <UITableViewDataSource,UITableViewDelegate,OtherSpecificCellDelegate,HouseNamedDelegate,AMapSearchDelegate,MAMapViewDelegate,SecurityContactDelegate>
{
    UIImageView *houseImage;
    UIView *cover;
    SpecificView *specific;
    UIView *container;
    NSString *username;
    NSInteger landlordid;
    NSString *blurLocation;
    NSDictionary *comment;
    AMapSearchAPI *_search;
    MAMapView *_mapView;
    double latitude;
    double longitude;
}

@property (nonatomic, strong) RMBSingleHouse *singleHouseData;

@end

@implementation ShowHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"房间信息"];
    [self initHeader];
    [self initData];
    [self initVisualView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"正在加载..." mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    if (!self.himageData) {
        [[RMBRequestManager sharedInstance] getSingleOptionalDetail:self.hid completionHandler:^(NSString *errMsg, id data) {
            if (data) {
                [[RMBAFNetworking sharedInstance] downloadHouseImage:[[RMBDataSource sharedInstance].singleHouseDic objectForKey:@"himage"] completionHandler:^(NSString *errMsg, id filePath) {
                    if (filePath) {
                        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
                        houseImage.image = [UIImage imageWithData:fileData];
                        self.himageData = fileData;
                    }
                }];
            }
        }];
    }
}

- (void)initHeader {
    self.mainTableView.contentInset = UIEdgeInsetsMake(kHEAD_IMAGE_HEIGHT, 0, 0, 0);
    houseImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kHEAD_IMAGE_HEIGHT, self.view.frame.size.width, kHEAD_IMAGE_HEIGHT)];
    houseImage.image = [UIImage imageWithData:self.himageData];
    houseImage.clipsToBounds = YES;
    houseImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.mainTableView addSubview:houseImage];
}

- (void)initHeadImage {
    
}

- (void)initVisualView {
    self.visualView.hidden = YES;
    self.cross.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2close = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeVisualView)];
    [self.cross addGestureRecognizer:tap2close];
}


- (void)closeVisualView {
    self.visualView.hidden = YES;
    [self.scrollContentView removeAllSubviews];
    self.navigationController.navigationBarHidden = NO;
}

- (void)initData {
    [[RMBRequestManager sharedInstance] getSingleHouseProfileByHouseId:self.hid comletionHandler:^(NSString *errMsg, id data) {
        self.singleHouseData = data;
        [[RMBRequestManager sharedInstance] getUserInfo:self.singleHouseData.uid completionHandler:^(NSString *errMsg, id data) {
            RMBUserInfo *collection = data;
            landlordid = collection.uid;
            username = collection.uname;
            NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:collection.uimageurl];
            NSData *imageData = [NSData dataWithContentsOfFile:filePath];
            self.uimageData = imageData;
            [[RMBRequestManager sharedInstance] getBlurLocationByCityId:self.singleHouseData.cityid completionHandler:^(NSString *errMsg, id data) {
                blurLocation = [NSString stringWithFormat:@"%@,%@",[RMBDataSource sharedInstance].cityname,[RMBDataSource sharedInstance].province];
                [self initLocation:[RMBDataSource sharedInstance].cityname];
                [[RMBRequestManager sharedInstance] checkHouseIfContainsCollection:[RMBDataSource sharedInstance].pass completionHandler:^(NSString *errMsg, id data) {
                    NSIndexPath *firstIndexpath = [NSIndexPath indexPathForRow:0 inSection:0];
                    HouseNamedCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:@"houseNamedCell" forIndexPath:firstIndexpath];
                    if (errMsg) {
                        [self initComment];
                    } else {
                        for (NSNumber *hid in data) {
                            if ([[NSString stringWithFormat:@"%@",hid] isEqualToString:[NSString stringWithFormat:@"%lu",self.hid]]) {
                                [cell.add2CollectionLabel setTitle:@"已收藏" forState:UIControlStateNormal];
                                [cell.add2CollectionLabel setBackgroundColor:[UIColor colorWithRGB:@"#7db3e5"]];
                                cell.add2CollectionLabel.userInteractionEnabled = NO;
                                [self initComment];
                            }
                        }
                        [self initComment];
                    }
                }];
            }];
        }];
    }];
}

- (void)initComment {
    [[RMBRequestManager sharedInstance] lastComment:self.hid completionHandler:^(NSString *errMsg, id data) {
        if (errMsg) {
            comment = nil;
            [self.mainTableView reloadData];
            [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
        } else {
            comment = data;
            [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
            [self.mainTableView reloadData];
        }
    }];
}

- (void)initLocation:(NSString*)cityname {
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = cityname;
    [_search AMapGeocodeSearch:geo];
}

//正向编码回调经纬度
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response {
    if(response.geocodes.count == 0)
    {
        return;
    }
    for (AMapTip *p in response.geocodes) {
        latitude = p.location.latitude;
        longitude = p.location.longitude;
        [self.mainTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        HouseNamedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"houseNamedCell" forIndexPath:indexPath];
        cell.houseNamedLabel.text = self.singleHouseData.hname;
        cell.houseType.text = [NSString stringWithFormat:@"%@出租的%@",username,self.singleHouseData.htype];
        cell.houseAddress.text = blurLocation;
        cell.landlordImage.image = [UIImage imageWithData:self.uimageData];
        cell.landlordImage.contentMode = UIViewContentModeScaleAspectFill;
        cell.delegate = self;
        [cell tap2landlord];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (1 == indexPath.row) {
        HouseSpecificsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"houseSpecificsCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.max_visitors.text = [NSString stringWithFormat:@"%lu个房客",self.singleHouseData.max_visitors];
        cell.hroom.text = [NSString stringWithFormat:@"%lu个房间",self.singleHouseData.hroom];
        cell.hbed.text = [NSString stringWithFormat:@"%lu张床",self.singleHouseData.hbed];
        return cell;
    } else if (2 == indexPath.row) {
        HouseIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"houseIntroCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.hdesc.text = self.singleHouseData.hdesc;
        return cell;
    } else if (3 == indexPath.row) {
        HouseholdEvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"householdEvaCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!comment) {
            cell.commentContent.text = @"该房源尚无评论";
            cell.firstStar.hidden = YES;
            cell.secondStar.hidden = YES;
            cell.thirdStar.hidden = YES;
            cell.forthStar.hidden = YES;
            cell.fifthStar.hidden = YES;
            cell.commentsNumber.hidden = YES;
        } else {
            cell.commentContent.text = [comment objectForKey:@"content"];
            cell.commentsNumber.text = [NSString stringWithFormat:@"%d条评论",(int)(arc4random()/100000000)];
        }
        return cell;
    } else if (4 == indexPath.row) {
        HouseFacilityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"houseFacilityCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (5 == indexPath.row){
        HouseLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"houseLocationCell" forIndexPath:indexPath];
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.mainTableView.frame.size.width, 200)];
        _mapView.delegate = self;
        [cell.contentView addSubview:_mapView];
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(latitude, longitude) animated:YES];
        _mapView.zoomEnabled = NO;
        _mapView.scrollEnabled = NO;
        _mapView.showsCompass = NO;
        _mapView.showsScale = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (6 == indexPath.row) {
        SecurityContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"securityContactCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    } else {
        OtherSpecificCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherSpecificCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.checkin_time.text = self.singleHouseData.checkin_time;
        cell.checkout_time.text = self.singleHouseData.checkout_time;
        cell.bedtype.text = self.singleHouseData.bedtype;
        cell.hbathroom.text = [NSString stringWithFormat:@"%lu个卫生间",self.singleHouseData.hbathroom];
        cell.min_evenings.text = [NSString stringWithFormat:@"至少住宿%lu晚",self.singleHouseData.min_evenings];
        NSArray *strategyArr = @[@"灵活",@"适中",@"严格"];
        [cell.strategy setTitle:[NSString stringWithFormat:@"%@退订政策",[strategyArr objectAtIndex:self.singleHouseData.unsub_strategy]] forState:UIControlStateNormal];
        cell.delegate = self;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        static HouseNamedCell *cell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            cell = (HouseNamedCell*)[tableView dequeueReusableCellWithIdentifier:@"houseNamedCell"];
        });
        CGFloat height = [cell calculateForCellHeight:self.singleHouseData.hname];
        return height;
    } else if (2 == indexPath.row || 3 == indexPath.row){
        return 220;
//        static UITableViewCell *cell = nil;
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"normalCell"];
//        });
//        CGFloat height = [cell calculateForCellHeight:[data objectAtIndex:indexPath.row]];
    } else if (5 == indexPath.row) {
        return 200;
    } else if (6 == indexPath.row) {
        return 132;
    } else if (7 == indexPath.row) {
        return 280;
    } else {
        return 100;
    }
//    static HouseNamedCell *cell = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        cell = (HouseNamedCell*)[tableView dequeueReusableCellWithIdentifier:@"houseNamedCell"];
//    });
//    CGFloat height = [cell calculateForCellHeight:[data objectAtIndex:indexPath.row]];
//    return height;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.himageData) {
        return;
    }
    CGFloat y = scrollView.contentOffset.y+64;
    if (y < -kHEAD_IMAGE_HEIGHT) {
        CGRect frame = houseImage.frame;
        frame.origin.y = y;
        frame.size.height = -y;
        houseImage.frame = frame;
    }
}

- (void)createSpecificView:(UIButton*)button {
//    specific = [self.view viewWithTag:1001];
//    if (!specific) {
//        cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//        cover.backgroundColor = [UIColor blackColor];
//        cover.alpha = 0.6;
//        [self.view addSubview:cover];
//        self.navigationController.navigationBarHidden = YES;
////        [[self activityViewController].view addSubview:cover];
//        switch (button.tag) {
//            case 1:
//                [SpecificView showSpecificView:self andTitle:@"额外费用"];
//                break;
//            case 2:
//                [SpecificView showSpecificView:self andTitle:@"严格退订政策"];
//                break;
//            case 3:
//                [SpecificView showSpecificView:self andTitle:@"可供出租日历"];
//                break;
//            default:
//                break;
//        }
//        specific = [self.view viewWithTag:1001];
//        for (UIView *view in specific.subviews) {
//            if (100100 == view.tag) {
//                UITapGestureRecognizer *tap2close = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2close)];
//                [view addGestureRecognizer:tap2close];
//            }
//        }
//    } else {
//        cover.hidden = NO;
//        self.navigationController.navigationBarHidden = YES;
//        specific.hidden = NO;
//    }
//    if (!cover) {
//        cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//        cover.backgroundColor = [UIColor blackColor];
//        cover.alpha = 0.6;
//        [self.view addSubview:cover];
//    } else {
//        cover.hidden = NO;
//    }
    self.navigationController.navigationBarHidden = YES;
    //        [[self activityViewController].view addSubview:cover];
    ExtraFeeViewController *extraFeeScene = [[self storyboard] instantiateViewControllerWithIdentifier:@"extraFeeScene"];
    extraFeeScene.hid = self.hid;
    switch (button.tag) {
        case 1:
            self.visualView.hidden = NO;
            self.reuseLabel.text = @"额外费用";
//            [SpecificView showSpecificView:self andTitle:@"额外费用"];
//            specific = [self.view viewWithTag:1001];
//            for (UIView *view in specific.subviews) {
//                if (100 == view.tag) {
//                    container = [view.subviews objectAtIndex:0];
//                    [self addChildViewController:extraFeeScene];
//                    [container addSubview:extraFeeScene.view];
//                    extraFeeScene.view.layout.edge(UIEdgeInsetsMake(0, 0, 0, 0),UILayoutAttributeLeft|UILayoutAttributeTop|UILayoutAttributeBottom|UILayoutAttributeRight);
//                }
//            }
            extraFeeScene.distinguish = button.tag;
            self.scrollContentView.contentSize = CGSizeMake(self.scrollContentView.frame.size.width, extraFeeScene.view.frame.size.height);
            [self.scrollContentView addSubview:extraFeeScene.view];
            break;
        case 2:
            self.visualView.hidden = NO;
            self.reuseLabel.text = @"严格退订政策";
            extraFeeScene.distinguish = button.tag;
            self.scrollContentView.contentSize = CGSizeMake(self.scrollContentView.frame.size.width, extraFeeScene.view.frame.size.height);
            [self.scrollContentView addSubview:extraFeeScene.view];
            break;
        case 3:
            self.visualView.hidden = NO;
            self.reuseLabel.text = @"可供出租日历";
            extraFeeScene.distinguish = button.tag;
            self.scrollContentView.contentSize = CGSizeMake(self.scrollContentView.frame.size.width, extraFeeScene.view.frame.size.height);
            [self.scrollContentView addSubview:extraFeeScene.view];
            break;
        default:
            break;
    }
    
    for (UIView *view in specific.subviews) {
        if (100100 == view.tag) {
            UITapGestureRecognizer *tap2close = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2close)];
            [view addGestureRecognizer:tap2close];
        }
    }
}

- (void)tap2close {
    cover.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    specific.hidden = YES;
    if (container.subviews) {
        [container removeAllSubviews];
    }
}

- (void)link2landlordProfile {
    LandlordProfileViewController *profileVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"landlordProfileScene"];
    profileVC.uid = landlordid;
    [self.navigationController pushViewController:profileVC animated:YES];
}

- (IBAction)link2ConfirmOrder:(id)sender {
    if (landlordid == [RMBDataSource sharedInstance].pass) {
        [self showHintViewWithTitle:@"房东不能预定自己的房源" onView:self.view withFrame:90];
        return;
    }
    ConfirmOrderViewController *confirmVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"confirmOrderScene"];
    confirmVC.nameData = self.singleHouseData.hname;
    confirmVC.detailData = [NSString stringWithFormat:@"%lu间卧室·%lu个卫生间·%lu张床",self.singleHouseData.hroom,self.singleHouseData.hbathroom,self.singleHouseData.hbed];
    confirmVC.allowMaxVisitors = self.singleHouseData.max_visitors;
    confirmVC.hid = self.hid;
    confirmVC.price = self.singleHouseData.price_per.integerValue;
    [self.navigationController pushViewController:confirmVC animated:YES];
}

- (IBAction)add2Collection:(id)sender {
    if (landlordid == [RMBDataSource sharedInstance].pass) {
        [self showHintViewWithTitle:@"房东不能收藏自己的房源" onView:self.view withFrame:90];
        return;
    }
    UIAlertController *collectionController = [UIAlertController alertControllerWithTitle:@"请选择您的一个收藏列表" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"默认收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MRProgressOverlayView showOverlayAddedTo:self.view title:@"请稍等..." mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
        [[RMBRequestManager sharedInstance] addHouse2Collection:0 hid:self.hid uid:[RMBDataSource sharedInstance].pass completionHandler:^(NSString *errMsg, id data) {
            if (data) {
                [MRProgressOverlayView dismissOverlayForView:self.view animated:YES completion:^{
                    NSIndexPath *firstIndexpath = [NSIndexPath indexPathForRow:0 inSection:0];
                    NSArray *cellArray = [NSArray arrayWithObjects:firstIndexpath, nil];
                    HouseNamedCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:@"houseNamedCell" forIndexPath:firstIndexpath];
                    [cell.add2CollectionLabel setTitle:@"已收藏" forState:UIControlStateNormal];
                    [cell.add2CollectionLabel setBackgroundColor:[UIColor colorWithRGB:@"#7db3e5"]];
                    cell.add2CollectionLabel.userInteractionEnabled = NO;
                    [self.mainTableView reloadRowsAtIndexPaths:cellArray withRowAnimation:UITableViewRowAnimationNone];
                    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"添加成功" mode:MRProgressOverlayViewModeCheckmark animated:YES];
                    dispatch_time_t delay_time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC));
                    dispatch_after(delay_time, dispatch_get_main_queue(), ^{
                        [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
                    });
                }];
            }
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [[RMBRequestManager sharedInstance] myCustomCollection:[RMBDataSource sharedInstance].pass completionHandler:^(NSString *errMsg, id data) {
        if (errMsg) {
            [collectionController addAction:defaultAction];
            [collectionController addAction:cancelAction];
            [self presentViewController:collectionController animated:YES completion:nil];
        } else {
            [collectionController addAction:defaultAction];
            for (NSDictionary *element in data) {
                UIAlertAction *customAction = [UIAlertAction actionWithTitle:[element objectForKey:@"cname"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"请稍等..." mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
                    [[RMBRequestManager sharedInstance] addHouse2Collection:[[element objectForKey:@"ucid"] integerValue] hid:self.hid uid:[RMBDataSource sharedInstance].pass completionHandler:^(NSString *errMsg, id data) {
                        if (data) {
                            [MRProgressOverlayView dismissOverlayForView:self.view animated:YES completion:^{
                                NSIndexPath *firstIndexpath = [NSIndexPath indexPathForRow:0 inSection:0];
                                NSArray *cellArray = [NSArray arrayWithObjects:firstIndexpath, nil];
                                HouseNamedCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:@"houseNamedCell" forIndexPath:firstIndexpath];
                                [cell.add2CollectionLabel setTitle:@"已收藏" forState:UIControlStateNormal];
                                [cell.add2CollectionLabel setBackgroundColor:[UIColor colorWithRGB:@"#7db3e5"]];
                                cell.add2CollectionLabel.userInteractionEnabled = NO;
                                [self.mainTableView reloadRowsAtIndexPaths:cellArray withRowAnimation:UITableViewRowAnimationNone];
                                [MRProgressOverlayView showOverlayAddedTo:self.view title:@"添加成功" mode:MRProgressOverlayViewModeCheckmark animated:YES];
                                dispatch_time_t delay_time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC));
                                dispatch_after(delay_time, dispatch_get_main_queue(), ^{
                                    [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
                                });
                            }];
                        }
                    }];
                }];
                [collectionController addAction:customAction];
            }
            [collectionController addAction:cancelAction];
            [self presentViewController:collectionController animated:YES completion:nil];
        }
    }];
}

- (void)doSomeEvents:(UIButton *)button {
    self.navigationController.navigationBarHidden = YES;
    if (3 == button.tag) {
        ExtraFeeViewController *extraFeeScene = [[self storyboard] instantiateViewControllerWithIdentifier:@"extraFeeScene"];
        extraFeeScene.hid = self.hid;
        self.visualView.hidden = NO;
        self.reuseLabel.text = @"房屋守则";
        extraFeeScene.distinguish = 4;
        self.scrollContentView.contentSize = CGSizeMake(self.scrollContentView.frame.size.width, extraFeeScene.view.frame.size.height);
        [self.scrollContentView addSubview:extraFeeScene.view];
    } else if (1 == button.tag) {
        LandlordProfileViewController *landlord = [[self storyboard] instantiateViewControllerWithIdentifier:@"landlordProfileScene"];
        landlord.uid = landlordid;
        [self.navigationController pushViewController:landlord animated:YES];
    }
}

@end

@implementation HouseNamedCell

- (CGFloat)calculateForCellHeight:(NSString*)data {
    CGSize size = [data sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-112, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
//    CGFloat preMaxWaith =[UIScreen mainScreen].bounds.size.width-112;
//    [self.houseNamedLabel setPreferredMaxLayoutWidth:preMaxWaith];
//    [self.houseNamedLabel layoutIfNeeded];
//    [self.contentView layoutIfNeeded];
//    CGSize size = [self.houseNamedLabel.text boundingRectWithSize:CGSizeMake(preMaxWaith, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
//    //加1是关键
    return size.height+136-20;
}

- (void)tap2landlord {
    UITapGestureRecognizer *tap2landlord = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2landlordProfile)];
    [self.tapView addGestureRecognizer:tap2landlord];
}

- (void)tap2landlordProfile {
    if (_delegate && [_delegate respondsToSelector:@selector(link2landlordProfile)]) {
        [_delegate link2landlordProfile];
    }
}

@end

@implementation HouseSpecificsCell

@end

@implementation HouseFacilityCell

@end

@implementation HouseIntroCell

@end

@implementation HouseholdEvaluationCell

@end

@implementation HouseLocationCell

@end

@implementation SecurityContactCell

- (IBAction)loadEvent:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(doSomeEvents:)]) {
        [_delegate doSomeEvents:sender];
    }
}
@end

@implementation OtherSpecificCell

- (IBAction)loadAlternativeModal:(UIButton*)button {
    if (_delegate && [_delegate respondsToSelector:@selector(createSpecificView:)]) {
        [_delegate createSpecificView:button];
    }
}

@end

