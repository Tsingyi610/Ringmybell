//
//  WelcomeViewController.m
//  impossible
//
//  Created by Blessed on 16/1/27.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "WelcomeViewController.h"
#import "RegistViewController.h"
#import "LoginViewController.h"
#import "UIColor+Extra.h"

@interface WelcomeViewController () <UIScrollViewDelegate>

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDisplay];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDisplay {
    CGFloat imgWidth = self.view.frame.size.width;
    CGFloat imgHeight = self.view.frame.size.height;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    NSInteger imgCount = 4;
    for (int i = 0; i < imgCount; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        //[imgView setContentMode:UIViewContentModeScaleAspectFit];
        CGFloat imgX = i * imgWidth;
        imgView.frame = CGRectMake(imgX, 0, imgWidth, imgHeight);
        NSString *imgName = [NSString stringWithFormat:@"welcome%d",i+1];
        imgView.image = [UIImage imageNamed:imgName];
        [imgView setContentMode:UIViewContentModeScaleAspectFill];
        [self.scrollView addSubview:imgView];
    }
    CGFloat contentWidth = imgCount * imgWidth;
    self.scrollView.contentSize = CGSizeMake(contentWidth, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.pageControl.numberOfPages = imgCount;
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRGB:@"#7DB3E5"];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRGB:@"#EFEFF4"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addTimer];
}

- (void)nextImage {
    NSInteger page = self.pageControl.currentPage;
    if (page == 3) {
        page = 0;
    } else {
        page++;
    }
    CGFloat x = page * self.view.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}

//- (IBAction)action2Login:(id)sender {
//    LoginViewController *loginScene = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScene"];
//    [self.navigationController pushViewController:loginScene animated:YES];
//}
//
//- (IBAction)action2Regist:(id)sender {
//    RegistViewController *registeScene = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistScene"];
//    [self.navigationController pushViewController:registeScene animated:YES];
//}

- (IBAction)action2Login:(id)sender {
    [self performSegueWithIdentifier:@"show2login" sender:nil];
}

- (IBAction)action2Regist:(id)sender {
    [self performSegueWithIdentifier:@"show2regist" sender:nil];
}

#pragma marks - scroll view delegate 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollViewWidth = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    NSInteger page = (x + scrollViewWidth / 2) / scrollViewWidth;
    self.pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addTimer];
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
