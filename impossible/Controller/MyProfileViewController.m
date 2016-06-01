//
//  MyProfileViewController.m
//  impossible
//
//  Created by Blessed on 16/2/4.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "MyProfileViewController.h"
#import "PersonalInfoViewController.h"
#import "RMBRequestManager.h"
#import "RMBDataSource.h"
#import "RMBAFNetworking.h"
#import "MRProgress.h"

@interface MyProfileViewController ()
{
    NSMutableArray *userInfodata;
    NSMutableArray *commentData;
}
@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestUserInfo];
    [self changeStatusBar:@"white"];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initComment {
    commentData = [NSMutableArray arrayWithCapacity:0];
    [[RMBRequestManager sharedInstance] myComments:[RMBDataSource sharedInstance].pass completionHandler:^(NSString *errMsg, id data) {
        if (data) {
            for (NSDictionary *element in data) {
                [commentData addObject:[element objectForKey:@"hid"]];
                if (commentData.count == [RMBDataSource sharedInstance].myComment.count) {
                    [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
                }
            }
        } else {
            [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
        }
    }];
}

- (void)requestUserInfo {
    userInfodata = [NSMutableArray arrayWithCapacity:0];
    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"正在加载..." mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    [[RMBRequestManager sharedInstance] getUserInfo:[RMBDataSource sharedInstance].pass completionHandler:^(NSString *errMsg, id data) {
        if (errMsg) {
            self.unameLabel.text = @"数据请求失败";
            self.descLabel.text = @"数据请求失败";
            [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
            return;
        } 
        RMBUserInfo *infoSource = data;
        [userInfodata addObject:infoSource.uname];
        [userInfodata addObject:infoSource.ugender];
        [userInfodata addObject:infoSource.uphone];
        [userInfodata addObject:infoSource.umail];
        [userInfodata addObject:infoSource.udesc];
        [userInfodata addObject:infoSource.uimageurl];
        self.unameLabel.text = infoSource.uname;
        self.descLabel.text = infoSource.udesc;
        NSLog(@"%@",infoSource.uimageurl);
        [[RMBAFNetworking sharedInstance] downloadUserHeadImage:infoSource.uimageurl completionHandler:^(NSString *errMsg, id filePath) {
            if (filePath) {
                NSData *fileData = [NSData dataWithContentsOfFile:filePath];
                self.headImage.image = [UIImage imageWithData:fileData];
                [self initComment];
            }
        }];
    }];
}

- (IBAction)link2PersonalInfo:(id)sender {
    PersonalInfoViewController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"personalScene"];
    controller.dataArr = userInfodata;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)exit:(id)sender {
    
    UIAlertController *alert2exit = [UIAlertController alertControllerWithTitle:@"退出当前账号" message:@"您确定要退出当前账号吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"choose cancel!");
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"login_ghost"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"leadScene"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alert2exit addAction:cancelAction];
    [alert2exit addAction:confirmAction];
    
    [self presentViewController:alert2exit animated:YES completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"mystep"]) {
        id value = segue.destinationViewController;
        [value setValue:commentData forKey:@"comment"];
    }
}


@end
