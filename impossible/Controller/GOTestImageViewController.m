//
//  GOTestImageViewController.m
//  impossible
//
//  Created by Blessed on 16/5/18.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "GOTestImageViewController.h"
#import "RMBAFNetworking.h"

@interface GOTestImageViewController ()

@end

@implementation GOTestImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"图片请求！！！"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sessionStart:(id)sender {
    [[RMBAFNetworking sharedInstance] downloadUserHeadImage:@"caonima.png" completionHandler:^(NSString *errMsg, id filePath) {
        if (filePath) {
            NSData *filedata = [NSData dataWithContentsOfFile:filePath];
            self.image.image = [UIImage imageWithData:filedata];
        }
    }];
    NSLog(@"prior!");
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
