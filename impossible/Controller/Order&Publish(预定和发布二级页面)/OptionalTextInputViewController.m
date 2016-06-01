//
//  OptionalTextInputViewController.m
//  impossible
//
//  Created by Blessed on 16/5/15.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "OptionalTextInputViewController.h"
#import "RMBDataSource.h"
#import "RMBRequestManager.h"

@interface OptionalTextInputViewController () <UITextViewDelegate>
{
    NSArray *d_placeholder;
    NSArray *arguments;
}
@end

@implementation OptionalTextInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"可选信息填写"];
    self.optionalInputTV.delegate = self;
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self initDisplay];
    // Do any additional setup after loading the view.
}

- (void)initDisplay {
    d_placeholder = @[@"房客可以使用什么便利设施",@"您喜欢您所在的街道的什么方面",@"出行交通是否便利",@"您期望房客有什么样的言行举止",@"还有什么其他信息需要分享"];
    arguments = @[@"visitor_limited",@"block_style",@"transport",@"rule",@"others"];
    NSString *arg = [arguments objectAtIndex:self.selectTag];
    if ([arg isEqualToString:@"visitor_limited"]) {
        if (![[RMBDataSource sharedInstance].visitor_limited isEqual:@""]) {
            self.optionalInputTV.text = [RMBDataSource sharedInstance].visitor_limited;
            self.placeholder.hidden = YES;
        } else {
            self.placeholder.text = d_placeholder[self.selectTag];
        }
    } else if ([arg isEqualToString:@"block_style"]) {
        if (![[RMBDataSource sharedInstance].block_style isEqual:@""]) {
            self.optionalInputTV.text = [RMBDataSource sharedInstance].block_style;
            self.placeholder.hidden = YES;
        } else {
            self.placeholder.text = d_placeholder[self.selectTag];
        }
    } else if ([arg isEqualToString:@"transport"]) {
        if (![[RMBDataSource sharedInstance].transport isEqual:@""]) {
            self.optionalInputTV.text = [RMBDataSource sharedInstance].transport;
            self.placeholder.hidden = YES;
        } else {
            self.placeholder.text = d_placeholder[self.selectTag];
        }
    } else if ([arg isEqualToString:@"others"]) {
        if (![[RMBDataSource sharedInstance].others isEqual:@""]) {
            self.optionalInputTV.text = [RMBDataSource sharedInstance].others;
            self.placeholder.hidden = YES;
        } else {
            self.placeholder.text = d_placeholder[self.selectTag];
        }
    } else if ([arg isEqualToString:@"rule"]) {
        if (![[RMBDataSource sharedInstance].rule isEqual:@""]) {
            self.optionalInputTV.text = [RMBDataSource sharedInstance].rule;
            self.placeholder.hidden = YES;
        } else {
            self.placeholder.text = d_placeholder[self.selectTag];
        }
    }
    self.placeholder.text = d_placeholder[self.selectTag];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitAction:(id)sender {
    [[RMBRequestManager sharedInstance] updateHouseOptional:[RMBDataSource sharedInstance].hid arg:arguments[self.selectTag] andValue:self.optionalInputTV.text completionHandler:^(NSString *errMsg, id data) {
        if (data) {
            switch (self.selectTag) {
                case 0:
                    [RMBDataSource sharedInstance].visitor_limited = self.optionalInputTV.text;
                    break;
                case 1:
                    [RMBDataSource sharedInstance].block_style = self.optionalInputTV.text;
                    break;
                case 2:
                    [RMBDataSource sharedInstance].transport = self.optionalInputTV.text;
                    break;
                case 3:
                    [RMBDataSource sharedInstance].rule = self.optionalInputTV.text;
                    break;
                case 4:
                    [RMBDataSource sharedInstance].others = self.optionalInputTV.text;
                    break;
                default:
                    break;
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeholder.hidden = YES;
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
