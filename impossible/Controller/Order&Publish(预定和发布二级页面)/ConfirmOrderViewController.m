//
//  ConfirmOrderViewController.m
//  impossible
//
//  Created by Blessed on 16/4/27.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "OrderResultViewController.h"
#import "RMBRequestManager.h"
#import "RMBDataSource.h"
#import "RMBUserInfo.h"
#import "UIColor+Extra.h"
#import "Masonry.h"

@interface ConfirmOrderViewController () <UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSString *begin_time;
    NSString *end_time;
    NSInteger switchViewTag;
    NSString *timeStr;
    double since1970;
    NSInteger visitors;
    UIPickerView *pView;
    UIToolbar *pvToolbar;
    NSMutableArray *paymentArr;
    NSString *rule;
    NSString *changeImage;
    NSInteger dayInt;
    NSDate *saveTime;
    NSString *allPrice;
    NSInteger howtopay;
    RMBUserInfo *user;
}
@end

@implementation ConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"确认详情"];
    [self initGesture];
    [self initData];
    [self initDisplay];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initGesture {
    UITapGestureRecognizer *tap2chooseVisitor = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseVisitorGesture)];
    [self.selectVisitorNumber addGestureRecognizer:tap2chooseVisitor];
    UITapGestureRecognizer *tap2chooseBegin = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseBeginTime)];
    [self.beginTime addGestureRecognizer:tap2chooseBegin];
    UITapGestureRecognizer *tap2chooseEnd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseEndTime)];
    [self.endTime addGestureRecognizer:tap2chooseEnd];
    UITapGestureRecognizer *tap2payment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payment)];
    [self.choosePayment addGestureRecognizer:tap2payment];
    UITapGestureRecognizer *tap2agree = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeStrategy)];
    [self.agreeStrategy addGestureRecognizer:tap2agree];
}

- (void)initData {
    self.hname.text = _nameData;
    self.houseDetails.text = _detailData;
    self.maxVisitors.text = [NSString stringWithFormat:@"最多可接纳%lu个房客",_allowMaxVisitors];
    changeImage = @"round";
    self.totalPrice.text = @"请选择日期来计算价格";
    paymentArr = [NSMutableArray arrayWithCapacity:0];
    howtopay = 1;
    [[RMBRequestManager sharedInstance] getPaymentCompletionHandler:^(id data) {
        if (data) {
            NSInteger c = [RMBDataSource sharedInstance].payment.count;
            for (int i=0; i<c; i++) {
                NSString *payments = [[[RMBDataSource sharedInstance].payment objectAtIndex:i] objectForKey:[NSString stringWithFormat:@"%d",i+1]];
                [paymentArr addObject:payments];
            }
            [[RMBRequestManager sharedInstance] getSingleOptionalDetail:self.hid completionHandler:^(NSString *errMsg, id data) {
                if (data) {
                    rule = [[RMBDataSource sharedInstance].optionalDetail objectForKey:@"rule"];
                    if ([rule isKindOfClass:[NSNull class]]) {
                        self.hrule.text = @"该房源无明显的房屋守则，您可以和房东进行友好协商，达成口头协议。";
                    } else {
                        self.hrule.text = rule;
                    }
                    [[RMBRequestManager sharedInstance] getUserInfo:[RMBDataSource sharedInstance].pass completionHandler:^(NSString *errMsg, id data) {
                        if (data) {
                            user = data;
                        }
                    }];
                }
            }];
        }
    }];
}

- (void)initDisplay {
    self.alphaCover.hidden = YES;
    self.clear.hidden = YES;
    self.datePicker.hidden = YES;
    self.toolbar.hidden = YES;
}

- (void)payment {
    self.alphaCover.hidden = NO;
    self.clear.hidden = NO;
    pView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
    pView.delegate = self;
    pView.tag = 2;
    pView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:pView];
    pvToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216-44, self.view.frame.size.width, 44)];
    pvToolbar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:pvToolbar];
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:0];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.tag = 201;
    cancelBtn.frame = CGRectMake(0, 0, 70, 30);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTintColor:[UIColor colorWithRGB:@"#7DB3E5"]];
    [cancelBtn addTarget:self action:@selector(cancelSelected:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmBtn.tag = 202;
    confirmBtn.frame = CGRectMake(0, 0, 70, 30);
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTintColor:[UIColor colorWithRGB:@"#7DB3E5"]];
    [confirmBtn addTarget:self action:@selector(confirmSelected:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    [buttons addObject:cancel];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [buttons addObject:space];
    UIBarButtonItem *confirm = [[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
    [buttons addObject:confirm];
    [pvToolbar setItems:buttons];
}

- (void)chooseVisitorGesture {
    self.alphaCover.hidden = NO;
    self.clear.hidden = NO;
    pView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
    pView.delegate = self;
    pView.tag = 1;
    pView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:pView];
    pvToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216-44, self.view.frame.size.width, 44)];
    pvToolbar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:pvToolbar];
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:0];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.tag = 101;
    cancelBtn.frame = CGRectMake(0, 0, 70, 30);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTintColor:[UIColor colorWithRGB:@"#7DB3E5"]];
    [cancelBtn addTarget:self action:@selector(cancelSelected:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmBtn.tag = 102;
    confirmBtn.frame = CGRectMake(0, 0, 70, 30);
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTintColor:[UIColor colorWithRGB:@"#7DB3E5"]];
    [confirmBtn addTarget:self action:@selector(confirmSelected:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    [buttons addObject:cancel];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [buttons addObject:space];
    UIBarButtonItem *confirm = [[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
    [buttons addObject:confirm];
    [pvToolbar setItems:buttons];
}

- (void)chooseBeginTime {
    [self initPicker];
    switchViewTag = 101;
}

- (void)chooseEndTime {
    [self initPicker];
    switchViewTag = 102;
}

- (void)cancelSelected:(UIButton*)button {
    self.alphaCover.hidden = YES;
    self.clear.hidden = YES;
    pView.hidden = YES;
    pvToolbar.hidden = YES;
}

- (void)confirmSelected:(UIButton*)button {
    if (!visitors) {
        visitors = 1;
    }
    self.showVisitorNumber.text = [NSString stringWithFormat:@"%lu",visitors];
    self.alphaCover.hidden = YES;
    self.clear.hidden = YES;
    pView.hidden = YES;
    pvToolbar.hidden = YES;
}

- (void)changeStrategy {
    if ([changeImage isEqualToString:@"round"]) {
        self.tick.image = [UIImage imageNamed:@"ico_tick"];
        changeImage = @"tick";
    } else {
        self.tick.image = [UIImage imageNamed:@"ico_round"];
        changeImage = @"round";
    }
}

- (void)initPicker {
    //cover
    self.alphaCover.hidden = NO;
    self.clear.hidden = NO;
    self.datePicker.hidden = NO;
    self.toolbar.hidden = NO;
    NSDate *today = [[NSDate alloc] init];
    self.datePicker.minimumDate = today;
    self.datePicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.toolbar.backgroundColor = [UIColor grayColor];
    [self.datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy年-MM月-dd日";
    timeStr = [format stringFromDate:today];
}

- (void)changeDate:(id)sender {
    UIDatePicker *control = (UIDatePicker*)sender;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy年-MM月-dd日";
    timeStr = [format stringFromDate:control.date];
    since1970 = [control.date timeIntervalSince1970];
}

- (IBAction)cancelDatePicker:(id)sender {
    self.datePicker.hidden = YES;
    self.toolbar.hidden = YES;
    self.alphaCover.hidden = YES;
    self.clear.hidden = YES;
}

- (IBAction)confirmDataPicker:(id)sender {
    self.datePicker.hidden = YES;
    self.toolbar.hidden = YES;
    self.alphaCover.hidden = YES;
    self.clear.hidden = YES;
    switch (switchViewTag) {
        case 101:
            begin_time = [NSString stringWithFormat:@"%f",since1970];
            saveTime = [NSDate dateWithTimeIntervalSince1970:since1970];
            self.beginTimeLabel.text = timeStr;
            break;
        case 102:
            end_time = [NSString stringWithFormat:@"%f",since1970];
            self.endTimeLabel.text = timeStr;
        default:
            break;
    }
    if (begin_time && end_time) {
        double day = end_time.floatValue - begin_time.floatValue;
        dayInt = day/60/60/24;
        self.totalPrice.text = [NSString stringWithFormat:@"¥ %lu",self.price * dayInt];
        allPrice = [NSString stringWithFormat:@"%lu",self.price * dayInt];
    }
}

#pragma mark - uipickerview
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (1 == pickerView.tag) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (int i=1; i<=_allowMaxVisitors; i++) {
            [array addObject:[NSString stringWithFormat:@"%d",i]];
        }
        return [array objectAtIndex:row];
    } else {
        return [paymentArr objectAtIndex:row];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (1 == pickerView.tag) {
        return _allowMaxVisitors;
    } else {
        return paymentArr.count;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (1 == pickerView.tag) {
        visitors = row+1;
    } else {
        NSArray *style = @[@"alipay",@"unionpay",@"visa",@"paypal"];
        self.paymentImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"ico_%@",style[row]]];
        howtopay = row+1;
    }
    
}

- (IBAction)link2result:(id)sender {
    OrderResultViewController *result = [[self storyboard] instantiateViewControllerWithIdentifier:@"orderResultScene"];
    if (!begin_time || !end_time) {
        [self showHintViewWithTitle:@"还没有确认时间" onView:self.view withFrame:90];
        return;
    }
    if (end_time.floatValue<=begin_time.floatValue) {
        [self showHintViewWithTitle:@"退房时间不能早于入住时间" onView:self.view withFrame:90];
        return;
    }
    if ([changeImage isEqualToString:@"round"]) {
        [self showHintViewWithTitle:@"您还未同意相关条款" onView:self.view withFrame:90];
        return;
    }
    if (begin_time && end_time) {
        [[RMBRequestManager sharedInstance] getPastOrderTime:self.hid andBeginTime:begin_time andEndTime:end_time completionHandler:^(NSString *errMsg, id data) {
            if (errMsg) {
                [self showHintViewWithTitle:@"该时间段已被占用，请重新选择" onView:self.view withFrame:90];
            } else {
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                format.dateFormat = @"yyyyMMddHHmmss";
                NSString *time = [format stringFromDate:[NSDate new]];
                NSString *order = [[[time stringByAppendingString:[NSString stringWithFormat:@"%lu",[RMBDataSource sharedInstance].pass]] stringByAppendingString:[NSString stringWithFormat:@"%lu",self.hid]] stringByAppendingString:allPrice];
                
                [[RMBRequestManager sharedInstance] insertOrder:[RMBDataSource sharedInstance].pass hid:self.hid orderid:order beginTime:begin_time endTime:end_time price:allPrice.integerValue payment:howtopay completionHandler:^(NSString *errMsg, id data) {
                    if (data) {
                        result.hname = self.hname.text;
                        format.dateFormat = @"yyyy年-MM月-dd日";
                        result.orderTime = [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:begin_time.floatValue]];
                        result.totalPrice = self.totalPrice.text;
                        result.night = dayInt;
                        NSString *consult = [NSString stringWithFormat:@"用户 %@ 申请了 %@ 房源的预定，请房东及时作出反馈",user.uname,self.hname.text];
                        [[RMBRequestManager sharedInstance] insertConsult:order content:consult completionHandler:^(NSString *errMsg, id data) {
                            if (data) {
                                [self.navigationController pushViewController:result animated:YES];
                            }
                        }];
                    }
                }];
            }
        }];
    } else {
        
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
