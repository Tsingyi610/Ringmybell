//
//  RoomDetailsViewController.m
//  impossible
//
//  Created by Blessed on 16/5/1.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "RoomDetailsViewController.h"
#import "RMBDataSource.h"
#import "RMBRequestManager.h"
#import "Masonry.h"

@interface RoomDetailsViewController () <UIPickerViewDelegate,UIPickerViewDataSource,UIPickerViewAccessibilityDelegate>
{
    NSArray *range;
    NSString *getData;
    NSInteger whichTag;
    NSArray *type;
}
@end

@implementation RoomDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"房间和床位"];
    self.pickerView.hidden = YES;
    self.toolBar.hidden = YES;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self initGesture];
    [self initData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    type = @[@"整套房子",@"独立房间",@"合住空间"];
    self.bedroomNum.text = [RMBDataSource sharedInstance].bedroom;
    self.bedNum.text = [RMBDataSource sharedInstance].bed;
    self.bathroomNum.text = [RMBDataSource sharedInstance].bathroom;
    self.maxVisitorsNum.text = [RMBDataSource sharedInstance].maxVisitors;
    self.minEveningsNum.text = [RMBDataSource sharedInstance].minEvenings;
    self.houseTypeLabel.text = type[[RMBDataSource sharedInstance].htype-1];
}

- (void)initGesture {
    UITapGestureRecognizer *tap2changeBedroom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBedroom)];
    UITapGestureRecognizer *tap2changeBed = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBed)];
    UITapGestureRecognizer *tap2changeBathroom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBathroom)];
    UITapGestureRecognizer *tap2changeMaxVisitors = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeMaxVisitors)];
    UITapGestureRecognizer *tap2changeMinEvenings = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeMinEvenings)];
    UITapGestureRecognizer *tap2changeHouseType = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHouseType)];
    
    [self.bedroomView addGestureRecognizer:tap2changeBedroom];
    [self.bedView addGestureRecognizer:tap2changeBed];
    [self.bathroomView addGestureRecognizer:tap2changeBathroom];
    [self.maxVisitorsView addGestureRecognizer:tap2changeMaxVisitors];
    [self.minEveningsView addGestureRecognizer:tap2changeMinEvenings];
    [self.houseTypeView addGestureRecognizer:tap2changeHouseType];
    
    self.bedroomView.tag = 0;
    self.bedView.tag = 1;
    self.bathroomView.tag = 2;
    self.maxVisitorsView.tag = 3;
    self.minEveningsView.tag = 4;
    self.houseTypeView.tag = 5;
}

- (void)changeBedroom {
    whichTag = self.bedroomView.tag;
    range = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    [self.pickerView reloadAllComponents];
    self.pickerView.hidden = NO;
    self.toolBar.hidden = NO;
}

- (void)changeBed {
    whichTag = self.bedView.tag;
    range = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    [self.pickerView reloadAllComponents];
    self.pickerView.hidden = NO;
    self.toolBar.hidden = NO;
}

- (void)changeBathroom {
    whichTag = self.bathroomView.tag;
    range = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    [self.pickerView reloadAllComponents];
    self.pickerView.hidden = NO;
    self.toolBar.hidden = NO;
}

- (void)changeMaxVisitors {
    whichTag = self.maxVisitorsView.tag;
    range = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    [self.pickerView reloadAllComponents];
    self.pickerView.hidden = NO;
    self.toolBar.hidden = NO;
}

- (void)changeMinEvenings {
    whichTag = self.minEveningsView.tag;
    range = @[@"1",@"2"];
    [self.pickerView reloadAllComponents];
    self.pickerView.hidden = NO;
    self.toolBar.hidden = NO;
}

- (void)changeHouseType {
    whichTag = self.houseTypeView.tag;
    range = @[@"整套房子",@"独立房间",@"合住空间"];
    [self.pickerView reloadAllComponents];
    self.pickerView.hidden = NO;
    self.toolBar.hidden = NO;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [range count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [range objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *selected = [range objectAtIndex:row];
    getData = selected;
}

- (IBAction)cancelButton:(id)sender {
    self.toolBar.hidden = YES;
    self.pickerView.hidden = YES;
}
- (IBAction)confirmButton:(id)sender {
    NSArray *arguments = @[@"hroom",@"hbed",@"hbathroom",@"max_visitors",@"min_evenings",@"htype"];
    switch (whichTag) {
        case 0:
            self.bedroomNum.text = getData;
            [RMBDataSource sharedInstance].bedroom = getData;
            break;
        case 1:
            self.bedNum.text = getData;
            [RMBDataSource sharedInstance].bed = getData;
            break;
        case 2:
            self.bathroomNum.text = getData;
            [RMBDataSource sharedInstance].bathroom = getData;
            break;
        case 3:
            self.maxVisitorsNum.text = getData;
            [RMBDataSource sharedInstance].maxVisitors = getData;
            break;
        case 4:
            self.minEveningsNum.text = getData;
            [RMBDataSource sharedInstance].minEvenings = getData;
            break;
        case 5:
            self.houseTypeLabel.text = getData;
            if ([getData isEqualToString:@"整套房子"]) {
                getData = @"1";
            } else if ([getData isEqualToString:@"独立房间"]) {
                getData = @"2";
            } else {
                getData = @"3";
            }
            [RMBDataSource sharedInstance].htype = getData.integerValue;
            break;
        default:
            break;
    }
    [[RMBRequestManager sharedInstance] updateHouseMain:[RMBDataSource sharedInstance].hid arg:[arguments objectAtIndex:whichTag] andValue:getData completionHandler:^(NSString *errMsg, id data) {
        if (data) {
            self.toolBar.hidden = YES;
            self.pickerView.hidden = YES;
        }
    }];
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
