//
//  RegistViewController.m
//  impossible
//
//  Created by Blessed on 16/1/28.
//  Copyright © 2016年 ringmybell. All rights reserved.
//
#define kPlaceholder @"_placeholderLabel.textColor"

#import "RegistViewController.h"
#import "RMBRequestManager.h"
#import "RMBDataSource.h"
#import "UIColor+Extra.h"

@interface RegistViewController () <UITextFieldDelegate>
{
    NSArray *textFieldArr;
}
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    textFieldArr = @[self.nameField,self.phoneField,self.emailField,self.pwdField];
    [self initFourTextFieldStyle];
    [self initBackground];
    [self backgroundAnimated];
    UITapGestureRecognizer *pop2welcome = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pop2welcome:)];
    [self.back2Welcome addGestureRecognizer:pop2welcome];
    self.scrollView.showsVerticalScrollIndicator = NO;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initFourTextFieldStyle {
    float radius = 4.0f;
    for (UITextField *textField in textFieldArr) {
        [self textField:textField cornerRadius:radius placeholderColor:@"#ffffff"];
        textField.delegate = self;
    }
}

- (void)initBackground {
    self.backImage.image = [UIImage imageNamed:@"regist"];
    //    self.coverView.backgroundColor = [UIColor colorWithRGB:@"#A9B7B7"];
}

- (void)textField:(UITextField *)textField cornerRadius:(float)argument placeholderColor:(NSString*)color {
    textField.layer.cornerRadius = argument;
    [textField setValue:[UIColor colorWithRGB:color] forKeyPath:kPlaceholder];
    textField.textColor = [UIColor whiteColor];
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

- (void)pop2welcome:(UITapGestureRecognizer *)tap {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)action2index:(id)sender {
    if (!self.nameField.hasText) {
        [self showHintViewWithTitle:@"请输入姓名" onView:self.hintContainer withFrame:40];
        return;
    }
    if (!self.phoneField.hasText) {
        [self showHintViewWithTitle:@"请输入手机号码" onView:self.hintContainer withFrame:40];
        return;
    }
    if (!self.emailField.hasText) {
        [self showHintViewWithTitle:@"请输入电子邮件地址" onView:self.hintContainer withFrame:40];
        return;
    }
    if (!self.pwdField.hasText) {
        [self showHintViewWithTitle:@"请输入密码" onView:self.hintContainer withFrame:40];
        return;
    }
    [[RMBRequestManager sharedInstance] beforeRegister:self.phoneField.text completionHandler:^(NSString *errMsg, id data) {
        if (errMsg) {
            [self showHintViewWithTitle:errMsg onView:self.hintContainer withFrame:40];
            return;
        } else {
            [[RMBRequestManager sharedInstance] insertUserInfoByName:self.nameField.text password:self.pwdField.text phone:self.phoneField.text andmail:self.emailField.text completionHandler:^(NSString *errMsg, id data) {
                if (errMsg) {
                    [self showHintViewWithTitle:errMsg onView:self.hintContainer withFrame:40];
                } else {
                    UITabBarController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"gatewayScene"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
        }
    }];
}


#pragma marks - textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = [UIColor colorWithRGB:@"#7db3e5"].CGColor;
    textField.layer.borderWidth = 2.0f;
//    以下代码会导致push动画异常 :->
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
    CGFloat offset = (textField.frame.origin.y+textField.frame.size.height+50.0) - (self.view.frame.size.height - kbHeight);
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

- (IBAction)resignResponder:(id)sender {
    for (UITextField *textField in textFieldArr) {
        if ([textField isFirstResponder]) {
            [textField resignFirstResponder];
        }
    }
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
