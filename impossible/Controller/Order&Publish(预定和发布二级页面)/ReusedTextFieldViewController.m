//
//  ReusedTextFieldViewController.m
//  impossible
//
//  Created by Blessed on 16/4/28.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "ReusedTextFieldViewController.h"
#import "RMBRequestManager.h"
#import "RMBDataSource.h"
#import "UIColor+Extra.h"

@interface ReusedTextFieldViewController () <UITextViewDelegate>
{
    NSArray *d_placeholder;
    NSInteger symbol;
    NSInteger countElement;
}
@end

@implementation ReusedTextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:self.typeArr[self.navTitleTag]];
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
    d_placeholder = @[@"为您的房源撰写一个描述性的标题（限35个字符）",@"总结您房源的亮点（限50个字符）",@"您房源的详细地址",@"为您的房源设置一个令人惊喜的价格"];
    NSArray *arguments = @[@"hname",@"hdesc",@"hlocation",@"price_per"];
    NSString *arg = [arguments objectAtIndex:self.navTitleTag];
        if ([arg isEqualToString:@"hname"]) {
            if (![[RMBDataSource sharedInstance].hname isEqual:@""]) {
                self.textView.text = [RMBDataSource sharedInstance].hname;
                self.placeholder.hidden = YES;
            } else {
                self.placeholder.text = d_placeholder[self.navTitleTag];
            }
        } else if ([arg isEqualToString:@"hdesc"]) {
            if (![[RMBDataSource sharedInstance].hdesc isEqual:@""]) {
                self.textView.text = [RMBDataSource sharedInstance].hdesc;
                self.placeholder.hidden = YES;
            } else {
                self.placeholder.text = d_placeholder[self.navTitleTag];
            }
        } else if ([arg isEqualToString:@"hlocation"]) {
            if (![[RMBDataSource sharedInstance].hlocation isEqual:@""]) {
                self.textView.text = [RMBDataSource sharedInstance].hlocation;
                self.placeholder.hidden = YES;
            } else {
                self.placeholder.text = d_placeholder[self.navTitleTag];
            }
        } else if ([arg isEqualToString:@"price_per"]) {
            if ([RMBDataSource sharedInstance].price_per != 0) {
                self.textView.text = [NSString stringWithFormat:@"%lu",[RMBDataSource sharedInstance].price_per];
                self.placeholder.hidden = YES;
            } else {
                self.placeholder.text = d_placeholder[self.navTitleTag];
            }
        }
    self.textView.delegate = self;
    symbol = 1;
}

- (IBAction)resign:(id)sender {
    [self.textView resignFirstResponder];
}

- (IBAction)callbackData:(id)sender {
    if (self.textView.hasText) {
        if (0 == self.navTitleTag) {
            if (35 < self.textView.text.length) {
                self.textView.textColor = [UIColor redColor];
                [self changeBtnStatus:0];
            } else {
                self.textView.textColor = [UIColor blackColor];
                [self changeBtnStatus:1];
            }
        } else if (1 == self.navTitleTag) {
            if (50 < self.textView.text.length) {
                self.textView.textColor = [UIColor redColor];
                [self changeBtnStatus:0];
            } else {
                self.textView.textColor = [UIColor blackColor];
                [self changeBtnStatus:1];
            }
        }
    }
    if (0 == symbol) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(callbackData:andTag:)]) {
        [_delegate callbackData:self.textView.text andTag:self.navTitleTag];
        
        [[RMBRequestManager sharedInstance] updateHouseMinor:[RMBDataSource sharedInstance].hid arg:self.arg andValue:self.textView.text completionHandler:^(NSString *errMsg, id data) {
            if (data) {
                switch (self.navTitleTag) {
                    case 0:
                        [RMBDataSource sharedInstance].hname = self.textView.text;
                        break;
                    case 1:
                        [RMBDataSource sharedInstance].hdesc = self.textView.text;
                        break;
                    case 2:
                        [RMBDataSource sharedInstance].hlocation = self.textView.text;
                        break;
                    case 3:
                        [RMBDataSource sharedInstance].price_per = [self.textView.text integerValue];
                        break;
                    default:
                        break;
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

- (void)changeBtnStatus:(NSInteger)controlTag {
    if (0 == controlTag) {
        self.confirmBtn.backgroundColor = [UIColor grayColor];
        self.confirmBtn.userInteractionEnabled = NO;
        symbol = controlTag;
        return;
    } else {
        self.confirmBtn.backgroundColor = [UIColor colorWithRGB:@"#7db3e5"];
        self.confirmBtn.userInteractionEnabled = YES;
        symbol = controlTag;
        return;
    }
}

#pragma marks - UITextField Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeholder.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.hasText) {
        if (0 == self.navTitleTag) {
            if (35 < textView.text.length) {
                textView.textColor = [UIColor redColor];
                [self changeBtnStatus:0];
            } else {
                textView.textColor = [UIColor blackColor];
                [self changeBtnStatus:1];
            }
        } else if (1 == self.navTitleTag) {
            if (50 < self.textView.text.length) {
                self.textView.textColor = [UIColor redColor];
                [self changeBtnStatus:0];
            } else {
                self.textView.textColor = [UIColor blackColor];
                [self changeBtnStatus:1];
            }
        }
    } else {
        self.placeholder.text = d_placeholder[self.navTitleTag];
        self.placeholder.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    } else {
        return YES;
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
