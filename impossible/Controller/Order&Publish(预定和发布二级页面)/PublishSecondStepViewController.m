//
//  PublishSecondStepViewController.m
//  impossible
//
//  Created by Blessed on 16/4/27.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "PublishSecondStepViewController.h"
#import "PublishThirdStepViewController.h"
#import "Masonry.h"
#import "RMBDataSource.h"
#import "RMBRequestManager.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface PublishSecondStepViewController () <AMapLocationManagerDelegate,AMapSearchDelegate,MAMapViewDelegate,UITextFieldDelegate>
{
    NSArray *typeArr;
    AMapSearchAPI *_search;
    MAMapView *_mapView;
    AMapLocationManager *_locationManager;
}
//@property (nonatomic, strong) AMapLocationManager *locationManager;
@end

@implementation PublishSecondStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"位置"];
    typeArr = @[@"整套房屋",@"独立房间",@"合住空间"];
    [self initData:self.receivedTag];
    [self initMapObject];
    self.locationTextField.delegate = self;
    NSLog(@"%lu",[RMBDataSource sharedInstance].htype);
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)initMapObject {
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    _locationManager = [[AMapLocationManager alloc] init];
    _locationManager.delegate = self;
    _mapView = [[MAMapView alloc] init];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [_mapView setZoomLevel:16 animated:YES];
    [self.amapView addSubview:_mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.amapView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [RMBDataSource sharedInstance].location_city = @"杭州市";
    [RMBDataSource sharedInstance].location_province = @"浙江省";
}

//逆地理编码
- (void)regeocode:(double)latitude andLongitude:(double)longitude {
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    regeo.radius = 10000;
    regeo.requireExtension = YES;
    [_search AMapReGoecodeSearch:regeo];
}

//逆地理位置信息回调
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        if ([response.regeocode.addressComponent.city isEqual: @""] && [response.regeocode.addressComponent.province isEqual: @""]) {
            self.locationTextField.text = @"定位数据不在陆地";
            return;
        }
        if ([response.regeocode.addressComponent.city isEqual: @""]) {
            [RMBDataSource sharedInstance].location_city = response.regeocode.addressComponent.province;
            [RMBDataSource sharedInstance].location_province = response.regeocode.addressComponent.province;
            self.locationTextField.text = [NSString stringWithFormat:@"%@",response.regeocode.addressComponent.province];
            return;
        } else {
            self.locationTextField.text = [NSString stringWithFormat:@"%@，%@",response.regeocode.addressComponent.city,response.regeocode.addressComponent.province];
            [RMBDataSource sharedInstance].location_city = response.regeocode.addressComponent.city;
            [RMBDataSource sharedInstance].location_province = response.regeocode.addressComponent.province;
        }
    }
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response {
    if(response.geocodes.count == 0)
    {
        return;
    }
    //通过AMapGeocodeSearchResponse对象处理搜索结果
    for (AMapTip *p in response.geocodes) {
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(p.location.latitude, p.location.longitude);
        [_mapView setCenterCoordinate:position animated:YES];
        [self regeocode:p.location.latitude andLongitude:p.location.longitude];
    }
}

- (void)initData:(NSInteger)tag {
    self.houseType.text = [NSString stringWithFormat:@"您的%@在哪个城市？",typeArr[tag-1]];
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
        pre.image = [UIImage imageNamed:@"location.png"];
        pre.lineWidth = 3;
        pre.lineDashPattern = @[@6, @3];
        
        [_mapView updateUserLocationRepresentation:pre];
        [self regeocode:mapView.centerCoordinate.latitude andLongitude:mapView.centerCoordinate.longitude];
        view.calloutOffset = CGPointMake(0, 0);
    } 
}

//用户移动后获取经纬度回调
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    if (wasUserAction) {
        [RMBDataSource sharedInstance].latitude = mapView.centerCoordinate.latitude;
        [RMBDataSource sharedInstance].longitude = mapView.centerCoordinate.longitude;
        [self regeocode:[RMBDataSource sharedInstance].latitude andLongitude:[RMBDataSource sharedInstance].longitude];
    }
    //NSLog(@"%f-----%f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 根据中文进行地理编码更新地图

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
//    geo.address = textField.text;
//    [_search AMapGeocodeSearch:geo];
//    return YES;
//}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = textField.text;
    [_search AMapGeocodeSearch:geo];
}

- (IBAction)link2third:(id)sender {
    PublishThirdStepViewController *third = [[self storyboard] instantiateViewControllerWithIdentifier:@"thirdStepScene"];
    third.receivedTag = self.receivedTag-1;
    NSString *city;
    if ([RMBDataSource sharedInstance].location_city == [RMBDataSource sharedInstance].location_province) {
        city = [[RMBDataSource sharedInstance].location_province substringToIndex:[RMBDataSource sharedInstance].location_city.length-1];
    } else {
        city = [[RMBDataSource sharedInstance].location_city substringToIndex:[RMBDataSource sharedInstance].location_city.length-1];
    }
    [[RMBRequestManager sharedInstance] checkCityname:city completionHandler:^(NSString *errMsg, id data) {
        if (errMsg) {
            [self showHintViewWithTitle:@"该城市不在支持范围内" onView:self.displayView withFrame:80.0];
            return;
        } else {
            [self.navigationController pushViewController:third animated:YES];
        }
    }];
    
}

- (IBAction)resign:(id)sender {
    [self.locationTextField resignFirstResponder];
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
