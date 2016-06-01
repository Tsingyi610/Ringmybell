//
//  MakeCommentViewController.m
//  impossible
//
//  Created by Blessed on 16/5/19.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "MakeCommentViewController.h"
#import "RMBRequestManager.h"
#import "RMBDataSource.h"

@interface MakeCommentViewController () <UITextViewDelegate>
{
    NSInteger satisfactionNum;
}
@end

@implementation MakeCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"添加评论"];
    [self initData];
    [self initSatisfactionGesture];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    self.resultLabel.text = @"请选择满意度";
    self.himage.image = [UIImage imageWithData:_imageData];
    self.himage.contentMode = UIViewContentModeScaleAspectFill;
    self.himage.clipsToBounds = YES;
    self.totalPrice.text = [NSString stringWithFormat:@"总价是：¥%@",self.total_price];
    self.livedTime.text = [NSString stringWithFormat:@"居住时间：%@",[self.begin_time substringToIndex:10]];
    self.hname.text = self.hnameReceive;
}

- (void)initSatisfactionGesture {
    UITapGestureRecognizer *star1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2ChangeStar:)];
    UITapGestureRecognizer *star2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2ChangeStar:)];
    UITapGestureRecognizer *star3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2ChangeStar:)];
    UITapGestureRecognizer *star4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2ChangeStar:)];
    UITapGestureRecognizer *star5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2ChangeStar:)];
    
    self.star1.userInteractionEnabled = YES;
    self.star2.userInteractionEnabled = YES;
    self.star3.userInteractionEnabled = YES;
    self.star4.userInteractionEnabled = YES;
    self.star5.userInteractionEnabled = YES;
    
    [self.star1 addGestureRecognizer:star1];
    [self.star2 addGestureRecognizer:star2];
    [self.star3 addGestureRecognizer:star3];
    [self.star4 addGestureRecognizer:star4];
    [self.star5 addGestureRecognizer:star5];
}

- (void)tap2ChangeStar:(UITapGestureRecognizer*)gesture {
    [self changeStarStatus:gesture.view.tag];
    
}

- (void)changeStarStatus:(NSInteger)tag {
    NSString *unlike = @"ico_house_unlike";
    NSString *like = @"ico_house_like";
    NSArray *stars = @[self.star1,self.star2,self.star3,self.star4,self.star5];
    NSArray *describe = @[@"1分 看起来非常不满意。",@"2分 与预期差距明显。",@"3分 感觉一般,仍需改进。",@"4分 总体来说挺满意。",@"5分 感觉很棒！"];
    NSMutableArray *toLight = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *toGray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i=0; i<tag; i++) {
        [toLight addObject:[stars objectAtIndex:i]];
        self.resultLabel.text = [describe objectAtIndex:tag-1];
    }
    for (NSInteger i=4; i>=tag; i--) {
        [toGray addObject:[stars objectAtIndex:i]];
    }
    for (UIImageView *light in toLight) {
        light.image = [UIImage imageNamed:like];
    }
    for (UIImageView *gray in toGray) {
        gray.image = [UIImage imageNamed:unlike];
    }
    satisfactionNum = tag;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)submitAction:(id)sender {
    if (!self.textView.hasText) {
        [self showHintViewWithTitle:@"还未填写评论内容" onView:self.view withFrame:90];
        return;
    }
    if (!satisfactionNum) {
        [self showHintViewWithTitle:@"还未进行满意度评分" onView:self.view withFrame:90];
        return;
    }
    UIAlertController *submitController = [UIAlertController alertControllerWithTitle:@"确认提交你的评论" message:@"提交后不可修改，请慎重考虑" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *submit = [UIAlertAction actionWithTitle:@"确认提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[RMBRequestManager sharedInstance] addComment:[RMBDataSource sharedInstance].pass hid:self.hid commentContent:self.textView.text satisfaction:satisfactionNum completionHandler:^(NSString *errMsg, id data) {
            if (data) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
        
    }];
    [submitController addAction:cancel];
    [submitController addAction:submit];
    
    [self presentViewController:submitController animated:YES completion:nil];
}

- (IBAction)resign:(id)sender {
    [self.textView resignFirstResponder];
}

#pragma mark - uitextviewdelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.hasText) {
        self.placeholder.hidden = YES;
    } else {
        self.placeholder.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeholder.hidden = YES;
}

@end
