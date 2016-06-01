//
//  OptionalViewController.m
//  impossible
//
//  Created by Blessed on 16/5/1.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "OptionalViewController.h"

@interface OptionalViewController ()

@end

@implementation OptionalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"选填信息"];
    [self initGesture];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - INIT GESTURE

- (void)initGesture {
    UITapGestureRecognizer *tap2about = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(link2about)];
    [self.aboutHouseView addGestureRecognizer:tap2about];
    UITapGestureRecognizer *tap2convenience = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(link2convenience)];
    [self.convenienceView addGestureRecognizer:tap2convenience];
    UITapGestureRecognizer *tap2bed = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(link2bed)];
    [self.roomAndBedView addGestureRecognizer:tap2bed];
}

#pragma mark - GESTURE METHODS

- (void)link2about {
    UIViewController *aboutScene = [[self storyboard] instantiateViewControllerWithIdentifier:@"aboutDetailsScene"];
    [self.navigationController pushViewController:aboutScene animated:YES];
}

- (void)link2convenience {
    UIViewController *convenienceScene = [[self storyboard] instantiateViewControllerWithIdentifier:@"convenienceScene"];
    [self.navigationController pushViewController:convenienceScene animated:YES];
}

- (void)link2bed {
    UIViewController *bedScene = [[self storyboard] instantiateViewControllerWithIdentifier:@"bedScene"];
    [self.navigationController pushViewController:bedScene animated:YES];
}

- (IBAction)cancelThisSpaceAction:(id)sender {
    UIAlertController *cancelController = [UIAlertController alertControllerWithTitle:@"确定注销该房源" message:@"确认注销后，该房源仍旧保留但不可发布" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"choose cancel!");
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"choose resign!");
    }];
    
    [cancelController addAction:cancelAction];
    [cancelController addAction:confirmAction];
    
    [self presentViewController:cancelController animated:YES completion:nil];
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
