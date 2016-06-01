//
//  EditHouseProfileViewController.h
//  impossible
//
//  Created by Blessed on 16/4/28.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface EditHouseProfileViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *delayButton;
@property (weak, nonatomic) IBOutlet UIButton *publishedButton;
@property (nonatomic, copy) NSString *changeButton;
@end

@protocol UploadImageDelegate <NSObject>
- (void)uploadImage;
@end

@interface UploadImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *houseImage;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *visualCover;
@property (weak, nonatomic) IBOutlet UIView *emptyImageDisplay;
- (IBAction)click2upload:(id)sender;
@property (weak, nonatomic) id<UploadImageDelegate> delegate;

@end

@interface FillHouseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *need2completeTitle;
@property (weak, nonatomic) IBOutlet UILabel *need2completeContent;
@property (weak, nonatomic) IBOutlet UILabel *completedContent;
@property (weak, nonatomic) IBOutlet UIView *otherInfoView;

@end