//
//  HeaderTwoViewController.m
//  impossible
//
//  Created by Blessed on 16/4/30.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "HeaderTwoViewController.h"
#import "RMBRequestManager.h"
#import "RMBAFNetworking.h"
#import "RMBDataSource.h"
#import "RMBCarousel.h"

@interface HeaderTwoViewController ()
{
    NSString *contentData;
    NSArray *carouselDataArray;
    NSMutableArray *carousel;
}
@end

@implementation HeaderTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"活动和攻略"];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initData];
}

- (void)initData {
    self.contentLabel.text = self.content;
    CGSize size = [self.content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-30, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    //size.height - 338;
    CGRect refresh = CGRectMake(0, 0, 320, 568+size.height-338);
    carouselDataArray = [NSArray array];
    carousel = [NSMutableArray arrayWithCapacity:0];
    
    self.contentView.frame = refresh;
    self.titleDesc.text = self.ca_title;
    self.headViewImage.image = [UIImage imageWithData:[self.imageDataArray objectAtIndex:self.imageTag]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
