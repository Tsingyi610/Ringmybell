//
//  RoomDetailsViewController.h
//  impossible
//
//  Created by Blessed on 16/5/1.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface RoomDetailsViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *bedroomView;
@property (weak, nonatomic) IBOutlet UIView *bedView;
@property (weak, nonatomic) IBOutlet UIView *bathroomView;
@property (weak, nonatomic) IBOutlet UIView *maxVisitorsView;
@property (weak, nonatomic) IBOutlet UIView *minEveningsView;
@property (weak, nonatomic) IBOutlet UIView *houseTypeView;

@property (weak, nonatomic) IBOutlet UILabel *bedroomNum;
@property (weak, nonatomic) IBOutlet UILabel *bedNum;
@property (weak, nonatomic) IBOutlet UILabel *bathroomNum;
@property (weak, nonatomic) IBOutlet UILabel *maxVisitorsNum;
@property (weak, nonatomic) IBOutlet UILabel *minEveningsNum;
@property (weak, nonatomic) IBOutlet UILabel *houseTypeLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end
