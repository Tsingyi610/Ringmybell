//
//  ChattingViewController.h
//  impossible
//
//  Created by Blessed on 16/4/30.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface ChattingViewController : BaseViewController

@property (nonatomic, copy) NSString *applyid;
@property (nonatomic, assign) NSInteger hid;
@property (nonatomic, copy) NSString *landlordName;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *username;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *enterMsg;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *sendMsgBtn;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *communicateWith;
@property (weak, nonatomic) IBOutlet UIImageView *gotoHouse;
@property (weak, nonatomic) IBOutlet UIImageView *gotoProfile;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@interface ChattingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *landlordImage;
@property (weak, nonatomic) IBOutlet UIImageView *visitorImage;
@property (weak, nonatomic) IBOutlet UILabel *visitorMsg;
@property (weak, nonatomic) IBOutlet UILabel *landlordMsg;
- (CGFloat)calculateForCellHeight:(NSString*)data;
@end