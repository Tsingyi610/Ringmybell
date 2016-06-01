//
//  EditProfileViewController.m
//  impossible
//
//  Created by Blessed on 16/3/13.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "EditProfileViewController.h"
#import "RMBRequestManager.h"
#import "RMBDataSource.h"

@interface EditProfileViewController ()
{
    NSArray *key;
}
@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initEditDisplay:self.selectedTag];
    key = @[@"uname",@"ugender",@"phone",@"umail"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initEditDisplay:(NSInteger)tag {
    if (5 == tag) {
        self.normalView.hidden = YES;
        self.introView.hidden = NO;
        self.introTextView.text = self.editTarget;
    } else {
        self.normalView.hidden = NO;
        self.introView.hidden = YES;
        self.normalLabel.text = self.editTargetLabel;
        self.normalEditTextField.text = self.editTarget;
    }
}

- (IBAction)confirmAction:(id)sender {
    if (5 == self.selectedTag) {
        [[RMBRequestManager sharedInstance] changeUserInfo:[RMBDataSource sharedInstance].pass andContent:self.introTextView.text withtype:@"udesc" completionHandler:^(NSString *errMsg, id data) {
            [self responseDelegate];
        }];
    } else {
        [[RMBRequestManager sharedInstance] changeUserInfo:[RMBDataSource sharedInstance].pass andContent:self.normalEditTextField.text withtype:[key objectAtIndex:self.selectedTag-1] completionHandler:^(NSString *errMsg, id data) {
            if (errMsg) {
                [self showHintViewWithTitle:@"手机号码不规范或已注册" ];
                return;
            } else {
                if (3 == self.selectedTag) {
                    NSString *password = [[[NSUserDefaults standardUserDefaults] objectForKey:@"login_ghost"] objectForKey:@"upwd"];
                    NSDictionary *param = @{@"uphone":self.normalEditTextField.text,@"upwd":password};
                    [[NSUserDefaults standardUserDefaults] setObject:param forKey:@"login_ghost"];
                }
                [self responseDelegate];
            }
        }];
    }
}

- (void)responseDelegate {
    if (_delegate && [_delegate respondsToSelector:@selector(changeInfomation:andTag:)]) {
        if (5 == self.selectedTag) {
            [_delegate changeInfomation:self.introTextView.text andTag:self.selectedTag];
        } else {
            [_delegate changeInfomation:self.normalEditTextField.text andTag:self.selectedTag];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
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
