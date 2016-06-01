//
//  ShowHouseViewController.h
//  impossible
//
//  Created by Blessed on 16/3/17.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface ShowHouseViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (assign, nonatomic) NSInteger hid;
@property (copy, nonatomic) NSData *uimageData;
@property (nonatomic, copy) NSData *himageData;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *visualView;
@property (weak, nonatomic) IBOutlet UILabel *reuseLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIImageView *cross;

@end

@protocol HouseNamedDelegate <NSObject>
@optional
- (void)link2landlordProfile;
@end

@interface HouseNamedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *houseNamedLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseType;
@property (weak, nonatomic) IBOutlet UILabel *houseAddress;
@property (weak, nonatomic) IBOutlet UIView *landlordBack;
@property (weak, nonatomic) IBOutlet UIImageView *landlordImage;
@property (weak, nonatomic) IBOutlet UIView *tapView;
@property (weak, nonatomic) id<HouseNamedDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *add2CollectionLabel;
- (CGFloat)calculateForCellHeight:(NSString*)data;
- (void)tap2landlord;
@end

@interface HouseSpecificsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *max_visitors;
@property (weak, nonatomic) IBOutlet UILabel *hroom;
@property (weak, nonatomic) IBOutlet UILabel *hbed;

@end

@interface HouseIntroCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hdesc;

@end

@interface HouseholdEvaluationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *commentsNumber;
@property (weak, nonatomic) IBOutlet UIImageView *firstStar;
@property (weak, nonatomic) IBOutlet UIImageView *secondStar;
@property (weak, nonatomic) IBOutlet UIImageView *thirdStar;
@property (weak, nonatomic) IBOutlet UIImageView *forthStar;
@property (weak, nonatomic) IBOutlet UIImageView *fifthStar;
@property (weak, nonatomic) IBOutlet UILabel *commentContent;

@end

@interface HouseFacilityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *firstFacility;
@property (weak, nonatomic) IBOutlet UIImageView *secondFacility;
@property (weak, nonatomic) IBOutlet UIImageView *thirdFacility;
@property (weak, nonatomic) IBOutlet UILabel *facilitiesHideNum;

@end

@interface HouseLocationCell : UITableViewCell

@end

@protocol SecurityContactDelegate <NSObject>
- (void)doSomeEvents:(UIButton*)button;
@end

@interface SecurityContactCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *ruleView;
@property (weak, nonatomic) IBOutlet UIView *contactView;
@property (weak, nonatomic) IBOutlet UIView *landlordView;
@property (weak, nonatomic) IBOutlet UIButton *ruleButton;
@property (weak, nonatomic) IBOutlet UIButton *contactLandlordButton;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) id<SecurityContactDelegate> delegate;
- (IBAction)loadEvent:(UIButton *)sender;

@end

@class SpecificView;
@protocol OtherSpecificCellDelegate <NSObject>
@optional
- (void)createSpecificView:(UIButton*)button;
@end

@interface OtherSpecificCell : UITableViewCell
@property (nonatomic,weak) id<OtherSpecificCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *checkin_time;
@property (weak, nonatomic) IBOutlet UILabel *checkout_time;
@property (weak, nonatomic) IBOutlet UILabel *bedtype;
@property (weak, nonatomic) IBOutlet UILabel *hbathroom;
@property (weak, nonatomic) IBOutlet UILabel *min_evenings;
@property (weak, nonatomic) IBOutlet UIButton *strategy;
- (IBAction)loadAlternativeModal:(UIButton*)button;
@end