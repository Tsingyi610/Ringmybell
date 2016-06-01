//
//  FeedbackViewController.m
//  impossible
//
//  Created by Blessed on 16/5/17.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UIColor+Extra.h"
#import "RMBRequestManager.h"
#import "RMBDataSource.h"

@interface FeedbackViewController () <UITextViewDelegate>

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"向我们反馈"];
    [self initDisplay];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDisplay {
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (IBAction)resign:(id)sender {
    [self.textView resignFirstResponder];
}

#pragma mark - uitextview delegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    } else {
        return YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeholder.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.hasText) {
        self.placeholder.hidden = YES;
    } else {
        self.placeholder.hidden = NO;
    }
    if (textView.text.length >= 140) {
        textView.textColor = [UIColor redColor];
        [self.submitBtn setEnabled:NO];
        [self.submitBtn setBackgroundColor:[UIColor grayColor]];
    } else {
        textView.textColor = [UIColor blackColor];
        [self.submitBtn setEnabled:YES];
        [self.submitBtn setBackgroundColor:[UIColor colorWithRGB:@"#7db3e5"]];
    }
}


- (IBAction)submitAction:(id)sender {
    [self.textView resignFirstResponder];
    if (self.submitBtn.isEnabled) {
        [[RMBRequestManager sharedInstance] addFeedback:[RMBDataSource sharedInstance].pass content:self.textView.text completionHandler:^(NSString *errMsg, id data) {
            if (data) {
                UIAlertController *actionController = [UIAlertController alertControllerWithTitle:@"提交成功" message:@"您的反馈意见已经记录，感谢你的反馈！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [actionController addAction:ok];
                [self presentViewController:actionController animated:YES completion:nil];
            }
        }];
    } else {
        return;
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
