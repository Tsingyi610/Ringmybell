//
//  LoginViewController.m
//  impossible
//
//  Created by Blessed on 16/1/29.
//  Copyright © 2016年 ringmybell. All rights reserved.
//
#define kPlaceholder @"_placeholderLabel.textColor"

#import "LoginViewController.h"
#import "IndexViewController.h"
#import "RMBRequestManager.h"
#import "UIColor+Extra.h"
#import "SpecificView.h"

@interface LoginViewController () <UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBackground];
    [self initTwoTextFieldStyle];
    UITapGestureRecognizer *tap2pop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2pop:)];
    [self.backView addGestureRecognizer:tap2pop];
    //[SpecificView showSpecificView:self andTitle:@"caonima"];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tap2pop:(UITapGestureRecognizer *)tap {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initBackground {
    self.backImage.image = [UIImage imageNamed:@"login-back"];
    [self backgroundAnimated];
}

- (void)initTwoTextFieldStyle {
    float radius = 4.0f;
    [self textField:self.authTextField cornerRadius:radius placeholderColor:@"#ffffff"];
    [self textField:self.pwdTextField cornerRadius:radius placeholderColor:@"#ffffff"];
    self.authTextField.delegate = self;
    self.pwdTextField.delegate = self;
}

- (void)backgroundAnimated {
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = 12;
    scale.autoreverses = YES;
    scale.repeatCount = 1e100;
    scale.fromValue = [NSNumber numberWithFloat:1.0f];
    scale.toValue = [NSNumber numberWithFloat:1.1f];
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.backImage.layer addAnimation:scale forKey:nil];
}

- (void)textField:(UITextField *)textField cornerRadius:(float)argument placeholderColor:(NSString*)color {
    textField.layer.cornerRadius = argument;
    [textField setValue:[UIColor colorWithRGB:color] forKeyPath:kPlaceholder];
    textField.textColor = [UIColor whiteColor];
}

- (IBAction)action2resign:(id)sender {
    if (self.authTextField.isFirstResponder) {
        [self.authTextField resignFirstResponder];
    } else if (self.pwdTextField.isFirstResponder) {
        [self.pwdTextField resignFirstResponder];
    }
}

- (IBAction)action2index:(id)sender {
    if (self.authTextField.text.length || self.pwdTextField.text.length) {
        //self.success2fadeInLabel.text = [NSString stringWithFormat:@"%@,欢迎回来。",self.authTextField.text];
        [[RMBRequestManager sharedInstance] compareUserPassword:self.pwdTextField.text andPhone:self.authTextField.text completionHandler:^(NSString *errMsg, id data) {
            if (errMsg) {
                [self showHintViewWithTitle:errMsg onView:self.container];
            } else {
                //[self showHintViewWithTitle:@"登录成功" onView:self.container];
                UITabBarController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"gatewayScene"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
        //[self loginSuccess2animated];
    }
}

- (void)loginSuccess2animated {
    float originX = self.success2fadeView.frame.origin.x;
//    [UIView animateWithDuration:5.0 animations:^{
//        self.success2fadeView.frame = CGRectMake(originX,originY+100,self.success2fadeView.frame.size.width,self.success2fadeView.frame.size.height);
//        self.success2fadeView.alpha = 0.0f;
//    } completion:^(BOOL finished) {
//        NSLog(@"complete!");
//    }];
//    [UIView transitionWithView:self.success2fadeView duration:6.0f options:0 animations:^{
//        self.success2fadeView.center = CGPointMake(originX, originY + 5.0f);
//        self.success2fadeView.alpha = 0.0f;
//    } completion:^(BOOL finished) {
//        NSLog(@"complete!");
//    }];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    CGRect position = self.success2fadeView.frame;
    position.origin.y += 50;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(successViewFadeOutDidStop)];
    self.success2fadeView.frame = CGRectMake(originX, position.origin.y,self.success2fadeView.frame.size.width,self.success2fadeView.frame.size.height);
    self.success2fadeView.alpha = 0.0;
    [UIView commitAnimations];
}

- (void)successViewFadeOutDidStop {
    self.success2fadeInLabel.text = [NSString stringWithFormat:@"%@，欢迎回来。",self.authTextField.text];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    CGPoint position = self.success2fadeInLabel.center;
    position.y += 20;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(successLabelFadeInDidStop)];
    [self.success2fadeInLabel setCenter:position];
    self.success2fadeInLabel.alpha = 1;
    [UIView commitAnimations];
}

- (void)successLabelFadeInDidStop {
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(delay, dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"show2index" sender:nil];
    });
}

//- (void)keyboardWillShow:(NSNotification *)notification {
//    //获取键盘高度
//    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//    //计算出键盘顶端到textfield底端的距离+缓冲距离
//    CGFloat offset = (self.pwdTextField.frame.origin.y+self.pwdTextField.frame.size.height+50.0) - (self.view.frame.size.height - kbHeight);
//    //取得键盘的动画时间
//    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    //计算偏移
//    if (offset<0) {
//        [UIView animateWithDuration:duration animations:^{
//            self.view.frame = CGRectMake(0.0f, offset, self.view.frame.size.width, self.view.frame.size.height);
//        }];
//    }
//}
//
//- (void)keyboardWillHide:(NSNotification *)notification {
//    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    [UIView animateWithDuration:duration animations:^{
//        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    }];
//}

#pragma marks - text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = [UIColor colorWithRGB:@"#7db3e5"].CGColor;
    textField.layer.borderWidth = 2.0f;
//    CGRect frame = textField.frame;
//    int offset = frame.origin.y + 100 - (self.view.frame.size.height - 216.0); //键盘高度216
//    NSTimeInterval duration = 0.2f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationCurve:duration];
//    
//    if (offset > 0) {
//        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
//        [UIView commitAnimations];
//    }
    //获取键盘高度
    CGFloat kbHeight = 216.0; //[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    //计算出键盘顶端到textfield底端的距离+缓冲距离
    CGFloat offset = (textField.frame.origin.y+textField.frame.size.height+self.success2fadeView.frame.origin.y+40.0) - (self.view.frame.size.height - kbHeight);
    //取得键盘的动画时间
    double duration = 0.25; //[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //计算偏移
    if (offset>0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.layer.borderWidth = 0.0f;
//    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    double duration = 0.25;
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
