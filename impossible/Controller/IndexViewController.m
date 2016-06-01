//
//  IndexViewController.m
//  impossible
//
//  Created by Blessed on 16/1/29.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "IndexViewController.h"
#import "MonthlyViewController.h"
#import "HospitaliyViewController.h"
#import "HeaderTwoViewController.h"
#import "LBSViewController.h"
#import "RMBRequestManager.h"
#import "RMBDataSource.h"
#import "UIColor+Extra.h"
#import "Masonry.h"
#import "MRProgress.h"
#import "RMBAFNetworking.h"
#import "RMBCarousel.h"
#import "RMBThreeActivity.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface IndexViewController () <UIScrollViewDelegate,AMapLocationManagerDelegate>
{
    NSArray *carouselData;
    NSArray *bottomThreeAcitvityData;
    NSMutableArray *sandboxImagePath;
    NSMutableArray *carouselImagePath;
    AMapLocationManager *_locationManager;
    NSString *cityid;
}
@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    self.tabBarController.tabBar.tintColor = [UIColor colorWithRGB:@"#00bb9c"];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self configLocationManager];
}

- (void)configLocationManager
{
    _locationManager = [[AMapLocationManager alloc] init];
    
    [_locationManager setDelegate:self];
    
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    [_locationManager setLocationTimeout:6];
    
    [_locationManager setReGeocodeTimeout:3];
}

- (void)initBanner {
    CGFloat imgWidth = self.view.frame.size.width;
    CGFloat imgHeight = imgWidth * 0.5;
    self.bannerScrollView.showsHorizontalScrollIndicator = NO;
    NSInteger imgCount = 3;
    for (int i = 0; i < imgCount; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        CGFloat imgX = i * imgWidth;
        imgView.frame = CGRectMake(imgX, 0, imgWidth, imgHeight);
        RMBCarousel *carousel = [carouselData objectAtIndex:i];
        [[RMBAFNetworking sharedInstance] downloadCarouselImage:carousel.image completionHandler:^(NSString *errMsg, id filePath) {
            if (filePath) {
                NSData *filedata = [NSData dataWithContentsOfFile:filePath];
                [carouselImagePath addObject:filedata];
                imgView.image = [UIImage imageWithData:filedata];
                imgView.tag = i;
                [self initHeaderGesture:imgView];
                [self.bannerScrollView addSubview:imgView];
                UILabel *theme = [[UILabel alloc]init];
                theme.text = carousel.ca_title;
                theme.font = [UIFont fontWithName:@"Helvetica-Light" size:25.0];
                theme.textColor = [UIColor whiteColor];
                theme.textAlignment = NSTextAlignmentCenter;
                [imgView addSubview:theme];
                [theme mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(imgView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
                }];
            }
        }];
    }
    CGFloat contentWidth = imgCount * imgWidth;
    self.bannerScrollView.contentSize = CGSizeMake(contentWidth, 0);
    self.bannerScrollView.pagingEnabled = YES;
    self.bannerScrollView.delegate = self;
    self.bannerPageControl.numberOfPages = imgCount;
    self.bannerPageControl.currentPageIndicatorTintColor = [UIColor colorWithRGB:@"#7DB3E5"];
    self.bannerPageControl.pageIndicatorTintColor = [UIColor colorWithRGB:@"#EFEFF4"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self bannerTimer];
}

- (void)initHeaderGesture:(UIImageView*)imageView {
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2activity = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(header2Activity:)];
    [imageView addGestureRecognizer:tap2activity];
}

- (void)header2Activity:(UITapGestureRecognizer*)gesture {
    HeaderTwoViewController *alterVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"headerTwoScene"];
    RMBCarousel *element = [carouselData objectAtIndex:gesture.view.tag];
    alterVC.ca_title = element.ca_title;
    alterVC.content = element.content;
    alterVC.imageData = [carouselImagePath objectAtIndex:gesture.view.tag];
    alterVC.imageTag = gesture.view.tag;
    alterVC.imageDataArray = carouselImagePath;
    [self.navigationController pushViewController:alterVC animated:YES];
}

- (void)initGesture {
    UITapGestureRecognizer *tap2monthly = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(monthlyScene:)];
    [self.monthlyView addGestureRecognizer:tap2monthly];
    UITapGestureRecognizer *tap2lbs = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lbsScene)];
    [self.tourStrategyView addGestureRecognizer:tap2lbs];
    UITapGestureRecognizer *tap2firstActivity = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(monthlyScene:)];
    [self.firstBottomView addGestureRecognizer:tap2firstActivity];
    UITapGestureRecognizer *tap2SecondActivity = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(monthlyScene:)];
    [self.secondBottomView addGestureRecognizer:tap2SecondActivity];
    UITapGestureRecognizer *tap2ThirdActivity = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(monthlyScene:)];
    [self.thirdBottomView addGestureRecognizer:tap2ThirdActivity];
    
    self.monthlyView.tag = 1000;
    self.firstBottomView.tag = 1001;
    self.secondBottomView.tag = 1002;
    self.thirdBottomView.tag = 1003;
    
    self.firstBottomImage.tag = 10000;
    self.secondBottomImage.tag = 10001;
    self.thirdBottomImage.tag = 10002;
    
    self.firstBottomLabel.tag = 100000;
    self.secondBottomLabel.tag = 100001;
    self.thirdBottomLabel.tag = 100002;
    
    sandboxImagePath = [NSMutableArray arrayWithCapacity:0];
    
    for (int i=0; i<3; i++) {
        RMBThreeActivity *list = [bottomThreeAcitvityData objectAtIndex:i];
        NSString *tag = [@"1000" stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
        NSString *labelTag = [@"10000" stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
        [[RMBAFNetworking sharedInstance] downloadIndexActivityImage:list.image completionHandler:^(NSString *errMsg, id filePath) {
            if (filePath) {
                NSData *filedata = [NSData dataWithContentsOfFile:filePath];
                [sandboxImagePath addObject:filedata];
                UIImageView *imageView = [self.view viewWithTag:tag.integerValue];
                UILabel *label = [self.view viewWithTag:labelTag.integerValue];
                imageView.image = [UIImage imageWithData:filedata];
                label.text = list.theme;
            }
        }];
    }
    
}

- (void)initData {
    carouselData = [NSArray array];
    bottomThreeAcitvityData = [NSArray array];
    carouselImagePath = [NSMutableArray array];
    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"正在为您载入首页..." mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    NSString *uphone = [[[NSUserDefaults standardUserDefaults] objectForKey:@"login_ghost"] objectForKey:@"uphone"];
    [[RMBRequestManager sharedInstance] getUserIDByUphone:uphone completionHandler:^(id data) {
        if (data) {
            [[RMBRequestManager sharedInstance] getBottomThreeActivitiesCompletionHandler:^(NSString *errMsg, id data) {
                if (data) {
                    bottomThreeAcitvityData = data;
                    [self initGesture];
                    [[RMBRequestManager sharedInstance] getCarouselCompletionHandler:^(NSString *errMsg, id data) {
                        if (data) {
                            carouselData = data;
                            [self initBanner];
//                            [self initLocationCompletionHandler:^(id callback) {
//                                if (callback) {
//                                    cityid = [NSString stringWithFormat:@"%@",callback];
                            //[self locateAction];
                                    [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
//                                }
//                            }];
                    
                        }
                    }];
                }
            }];
        }
    }];
////////////////////////////测试用////////////////////////////////
//    NSDictionary *param = @{@"uphone":@"15757135720",@"upwd":@"zhang"};
//    [[NSUserDefaults standardUserDefaults] setObject:param forKey:@"login_ghost"];
//    [[RMBRequestManager sharedInstance] getUserIDByUphone:[param objectForKey:@"uphone"] completionHandler:^(id data) {
//        NSLog(@"测试用户数据初始化完成！");
//    }];
    
}

- (void)initLocationCompletionHandler:(void (^)(id callback))handler {
    [_locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == 0)
            {
                return;
            }
        }
        if (regeocode)
        {
            if (regeocode.city) {
                NSString *cityname = [regeocode.city substringToIndex:regeocode.city.length-1];
                [[RMBRequestManager sharedInstance] getCityid:cityname completionHandler:^(NSString *errMsg, id data) {
                    if (!errMsg) {
                        handler(data);
                    } else {
                        handler(errMsg);
                    }
                }];
            } else {
                NSString *cityname = [regeocode.province substringToIndex:regeocode.province.length-1];
                [[RMBRequestManager sharedInstance] getCityid:cityname completionHandler:^(NSString *errMsg, id data) {
                    if (!errMsg) {
                        handler(data);
                    } else {
                        handler(errMsg);
                    }
                }];
            }
        }
    }];
}

#pragma marks - Gesture Methods

- (void)monthlyScene:(UITapGestureRecognizer*)gesture {
    MonthlyViewController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"monthlyScene"];
    controller.relyTag = gesture.view.tag;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (RMBThreeActivity *element in bottomThreeAcitvityData) {
        [array addObject:element.acid];
    }
    switch (gesture.view.tag) {
        case 1001:
            controller.acid = [array objectAtIndex:0];
            controller.headerLabelText = self.firstBottomLabel.text;
            controller.headerImage = [sandboxImagePath objectAtIndex:0];
            break;
        case 1002:
            controller.acid = [array objectAtIndex:1];
            controller.headerLabelText = self.secondBottomLabel.text;
            controller.headerImage = [sandboxImagePath objectAtIndex:1];
            break;
        case 1003:
            controller.acid = [array objectAtIndex:2];
            controller.headerLabelText = self.thirdBottomLabel.text;
            controller.headerImage = [sandboxImagePath objectAtIndex:2];
            break;
        default:
            controller.monthImage = @"monthly";
            break;
    }
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)lbsScene {
    LBSViewController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"lbsScene"];
    //controller.cityid = cityid;
    NSLog(@"%@",cityid);
    controller.cityid = @"0";
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)nextPage {
    NSInteger page = self.bannerPageControl.currentPage;
    if (page == 2) {
        page = 0;
    } else {
        page++;
    }
    CGFloat x = page * self.view.frame.size.width;
    [self.bannerScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)bannerTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)link2publish:(id)sender {
    UIViewController *publish = [[self storyboard] instantiateViewControllerWithIdentifier:@"firstStepScene"];
    [self.navigationController pushViewController:publish animated:YES];
}

#pragma marks - UIScrollView Delegate 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollViewWidth = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    NSInteger page = (x + scrollViewWidth / 2) / scrollViewWidth;
    self.bannerPageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self bannerTimer];
}


- (IBAction)link2searchVC:(id)sender {
    UIViewController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"searchScene"];
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
