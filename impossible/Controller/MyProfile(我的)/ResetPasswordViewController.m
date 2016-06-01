//
//  ResetPasswordViewController.m
//  impossible
//
//  Created by Blessed on 16/5/16.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "RMBRequestManager.h"
#import "RMBDataSource.h"

@interface ResetPasswordViewController () <UITextFieldDelegate>

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"修改登录密码"];
    self.oldPassword.delegate = self;
    self.resetPassword.delegate = self;
    self.confirmPassword.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmAction:(id)sender {
    NSString *old = [[[NSUserDefaults standardUserDefaults] objectForKey:@"login_ghost"] objectForKey:@"upwd"];
    if (self.oldPassword.text.length == 0) {
        [self showHintViewWithTitle:@"请填写原密码"];
        return;
    } else
    if (self.resetPassword.text.length == 0) {
        [self showHintViewWithTitle:@"请填写修改的新密码"];
        return;
    } else
    if (self.confirmPassword.text.length ==0) {
        [self showHintViewWithTitle:@"请确认新密码"];
        return;
    }else
    if (![self.oldPassword.text isEqualToString:old]) {
        [self showHintViewWithTitle:@"原密码错误"];
        return;
    }else
    if (self.resetPassword.text != self.confirmPassword.text) {
        [self showHintViewWithTitle:@"两次密码输入不一致"];
        return;
    }else
    if (self.resetPassword.text.length <= 3 || self.resetPassword.text.length >= 16) {
        [self showHintViewWithTitle:@"密码长度应在3~16字符之间"];
        return;
    } else {
        NSMutableDictionary *login = [[NSUserDefaults standardUserDefaults] objectForKey:@"login_ghost"];
        NSDictionary *param = @{@"uphone":[login objectForKey:@"uphone"],@"upwd":self.resetPassword.text};
        [[NSUserDefaults standardUserDefaults] setObject:param forKey:@"login_ghost"];
        [[RMBRequestManager sharedInstance] changeLoginPassword:[RMBDataSource sharedInstance].pass oldPassword:self.oldPassword.text newPassword:self.resetPassword.text completionHandler:^(NSString *errMsg, id data) {
            if (errMsg) {
                [self showHintViewWithTitle:@"密码修改失败!请重试"];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

#pragma mark - uitextfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (3 == textField.tag) {
        NSLog(@"check!");
    }
}

- (IBAction)resign:(id)sender {
    [self.resetPassword resignFirstResponder];
    [self.oldPassword resignFirstResponder];
    [self.confirmPassword resignFirstResponder];
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
