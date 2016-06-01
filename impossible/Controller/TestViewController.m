//
//  TestViewController.m
//  impossible
//
//  Created by Blessed on 16/1/29.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "TestViewController.h"
#import "RMBAFNetworking.h"
#import "RMBHintView.h"
#import "AFImageDownloader.h"
#import "AFNetworking.h"
#import "Masonry.h"
#import <MAMapKit/MAMapKit.h>

@interface TestViewController () <MAMapViewDelegate>
{
    MAMapView *_mapView;
}
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self testAMap];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://127.0.0.1:8080/static/test.png"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        NSLog(@"Response : %@",response);
        NSLog(@"ERROR : %@", error);
        NSString *image_path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"test.png"];
        self.downloadSync.image = [UIImage imageWithContentsOfFile:image_path];
    }];
    [downloadTask resume];

//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:view];
//    UIView *superview = self.view;
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(superview).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
//    }];
//    [self secondUIView:view];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    //_mapView.showsUserLocation = YES;
    //_mapView.userTrackingMode = MAUserTrackingModeFollow;
    //[RMBHintView hintViewWithTitle:@"手机号码格式错误" inController:self];
    //地图后台挂起
//    _mapView.pausesLocationUpdatesAutomatically = NO;
//    _mapView.allowsBackgroundLocationUpdates = YES;
    
    //[_mapView setZoomLevel:16.1 animated:YES];
//    self.title = @"navigationController!";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testAMap {
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 100, 320, 320)];
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
}

//地图定位回调
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
        pre.lineWidth = 3;
        pre.lineDashPattern = @[@6, @3];
        
        [_mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
    }
}

- (void)link2list {

}
- (IBAction)testHintView:(id)sender {
    [self showHintView];
}
- (IBAction)closeHintView:(id)sender {
    [self endHintView];
}

- (IBAction)show2index:(id)sender {
    [self performSegueWithIdentifier:@"show2index" sender:nil];
}


- (void)secondUIView:(UIView *)view {
    UIView *secondView = [UIView new];
    secondView.backgroundColor = [UIColor grayColor];
    [view addSubview:secondView];
    [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
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
