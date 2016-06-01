//
//  HospitaliyViewController.m
//  impossible
//
//  Created by Blessed on 16/4/17.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "HospitaliyViewController.h"
#import "MRProgress.h"

@interface HospitaliyViewController () <UIWebViewDelegate>

@end

@implementation HospitaliyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"好客之道"];
    self.hospitalityWebView.delegate = self;
    [self initWebView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initWebView {
    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"正在加载..." mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    NSString *localHTMLFile = @"hospitaliy";
    NSString *localHTMLFilePath = [[NSBundle mainBundle] pathForResource:localHTMLFile ofType:@"html"];
    NSURL *localHTMLFileURL = [NSURL fileURLWithPath:localHTMLFilePath];
    [self.hospitalityWebView loadRequest:[NSURLRequest requestWithURL:localHTMLFileURL]];
}

#pragma marks - UIWebView Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
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
