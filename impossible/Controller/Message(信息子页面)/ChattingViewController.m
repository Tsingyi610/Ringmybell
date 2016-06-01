//
//  ChattingViewController.m
//  impossible
//
//  Created by Blessed on 16/4/30.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "ChattingViewController.h"
#import "ShowHouseViewController.h"
#import "LandlordProfileViewController.h"
#import "ShowHouseViewController.h"
#import "LandlordProfileViewController.h"
#import "RMBDataSource.h"
#import "RMBRequestManager.h"

@interface ChattingViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *belongsTo;
    NSMutableArray *messageData;
    CGRect viewOriginalFrame;
}
@end

@implementation ChattingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.uid == [RMBDataSource sharedInstance].pass) {
        [self changeNavigationLightVersion:[NSString stringWithFormat:@"与%@沟通中",self.username]];
    } else {
        [self changeNavigationLightVersion:[NSString stringWithFormat:@"与%@沟通中",self.landlordName]];
    }
    [self initImageViewGesture];
    viewOriginalFrame = self.view.frame;
    self.textField.delegate = self;
    [self initHeadView];
    [self initMessages];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initMessages {
    belongsTo = [NSMutableArray arrayWithCapacity:0];
    messageData = [NSMutableArray arrayWithCapacity:0];
    [[RMBRequestManager sharedInstance] getMessageContentByApplyid:self.applyid completionHandler:^(NSString *errMsg, id data) {
        if (data) {
            for (NSDictionary *element in data) {
                [belongsTo addObject:[element objectForKey:@"dtag"]];
                [messageData addObject:[element objectForKey:@"content"]];
            }
            [self initHeaderSubmitButton];
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageData.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }];
}

- (void)initHeadView {
    if (self.uid == [RMBDataSource sharedInstance].pass) {
        self.communicateWith.text = [NSString stringWithFormat:@"与%@沟通中",self.username];
        self.submitBtn.hidden = NO;
    } else {
        self.communicateWith.text = [NSString stringWithFormat:@"与%@沟通中",self.landlordName];
        self.submitBtn.hidden = YES;
    }
    UITapGestureRecognizer *tap2house = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(link2CurrentHouse)];
    [self.gotoHouse addGestureRecognizer:tap2house];
    self.gotoHouse.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2userProfile = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(link2userProfile)];
    [self.gotoProfile addGestureRecognizer:tap2userProfile];
    self.gotoProfile.userInteractionEnabled = YES;
}

- (void)link2CurrentHouse {
    ShowHouseViewController *houseVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"showHouseScene"];
    houseVC.hid = self.hid;
    [self.navigationController pushViewController:houseVC animated:YES];
}

- (void)link2userProfile {
    LandlordProfileViewController *landlordVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"landlordProfileScene"];
    landlordVC.uid = self.uid;
    [self.navigationController pushViewController:landlordVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self observeKeyBoard];
}

- (void)initHeaderSubmitButton {
    [[RMBRequestManager sharedInstance] getCurrentRemark:self.applyid completionHandler:^(NSString *errMsg, id data) {
        if (data) {
            if ([data integerValue] == 1) {
                [self.submitBtn setTitle:@"确认" forState:UIControlStateNormal];
                self.submitBtn.userInteractionEnabled = YES;
            } else if([data integerValue] == 2){
                [self.submitBtn setTitle:@"已成交" forState:UIControlStateNormal];
                self.submitBtn.userInteractionEnabled = NO;
            } else {
                [self.submitBtn setTitle:@"已取消" forState:UIControlStateNormal];
                self.submitBtn.userInteractionEnabled = NO;
            }
            [self.tableView reloadData];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeNotificationOfKeyboard];
}

- (void)observeKeyBoard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotificationOfKeyboard {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShown:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *keyBoardValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSNumber *animationDuration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGRect kbRect = [keyBoardValue CGRectValue];
    if (kbRect.size.height > 216) {
        [UIView animateWithDuration:[animationDuration doubleValue] animations:^{
            self.enterMsg.frame = CGRectMake(0, kbRect.size.height, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *animationDuration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[animationDuration doubleValue] animations:^{
        self.enterMsg.frame = viewOriginalFrame;
    } completion:^(BOOL finished) {
        
    }];
}

//- (IBAction)resign:(id)sender {
//    [self.textField resignFirstResponder];
//}
#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Segue

- (void)initImageViewGesture {
    UITapGestureRecognizer *tap2House = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewGoToHouse)];
    [self.gotoHouse addGestureRecognizer:tap2House];
    [self.gotoHouse setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap2Profile = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewGoToProfile)];
    [self.gotoProfile addGestureRecognizer:tap2Profile];
    [self.gotoProfile setUserInteractionEnabled: YES];
}

- (void)imageViewGoToHouse {
    ShowHouseViewController *showHouseVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"showHouseScene"];
    [self.navigationController pushViewController:showHouseVC animated:YES];
}

- (void)imageViewGoToProfile {
    LandlordProfileViewController *landlordVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"landlordProfileScene"];
    [self.navigationController pushViewController:landlordVC animated:YES];
}

#pragma mark - UITableView Delegate & Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return belongsTo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChattingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chattingCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger belong = [[belongsTo objectAtIndex:indexPath.row] integerValue];
    [self controlDisplayTableView:cell andControlTag:belong andIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static ChattingCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = (ChattingCell*)[tableView dequeueReusableCellWithIdentifier:@"chattingCell"];
    });
    CGFloat height = [cell calculateForCellHeight:[messageData objectAtIndex:indexPath.row]];
    return height;
}

- (void)controlDisplayTableView:(ChattingCell *)cell andControlTag:(NSInteger)tag andIndexPath:(NSIndexPath*)indexPath {
    if (0 == tag) {
        cell.landlordImage.hidden = NO;
        cell.landlordMsg.hidden = NO;
        cell.visitorMsg.hidden = YES;
        cell.visitorImage.hidden = YES;
        cell.landlordMsg.text = [messageData objectAtIndex:indexPath.row];
    } else {
        cell.landlordImage.hidden = YES;
        cell.landlordMsg.hidden = YES;
        cell.visitorImage.hidden = NO;
        cell.visitorMsg.hidden = NO;
        cell.visitorMsg.text = [messageData objectAtIndex:indexPath.row];
    }
}

#pragma mark - Request

- (IBAction)sendMsgAction:(id)sender {
    if (!self.textField.hasText) {
        [self showHintViewWithTitle:@"消息内容不能为空" onView:self.view withFrame:90];
    } else {
        //房东回复
        if (self.uid == [RMBDataSource sharedInstance].pass) {
            [[RMBRequestManager sharedInstance] addResponseMessage:self.applyid content:self.textField.text completionHandler:^(NSString *errMsg, id data) {
                if (data) {
                    self.textField.text = @"";
                    [self initMessages];
                }
            }];
        } else {
            [[RMBRequestManager sharedInstance] insertConsult:self.applyid content:self.textField.text completionHandler:^(NSString *errMsg, id data) {
                if (data) {
                    self.textField.text = @"";
                    [self initMessages];
                }
            }];
        }
    }
}

- (IBAction)link2pay:(id)sender {
    UIAlertController *payController = [UIAlertController alertControllerWithTitle:@"确定成交该申请？" message:@"确定后会跳转到支付页面" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[RMBRequestManager sharedInstance] changeOrderRemark:self.applyid remark:2 completionHandler:^(NSString *errMsg, id data) {
            if (data) {
                UIViewController *payvc = [[self storyboard] instantiateViewControllerWithIdentifier:@"paymentScene"];
                [self.navigationController pushViewController:payvc animated:YES];
            }
        }];
        
    }];
    
    [payController addAction:cancel];
    [payController addAction:confirm];
    
    [self presentViewController:payController animated:YES completion:nil];
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

@implementation ChattingCell

- (CGFloat)calculateForCellHeight:(NSString*)data {
    CGSize size = [data sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-75, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height+30;
}

@end