//
//  SearchResultViewController.h
//  impossible
//
//  Created by Blessed on 16/4/19.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@protocol SetupOptionsDelegate <NSObject>
@optional
- (void)link2chooseMoreDetails;
@end

@protocol SearchResultDelegate <NSObject>
@required
- (void)changeLikeStatus:(NSInteger)status buttontag:(NSInteger)tag;
@end


@interface SetupOptionsCell : UITableViewCell
@property (weak, nonatomic) id<SetupOptionsDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *moreDetailButton;

- (IBAction)getMoreDetails:(id)sender;

@end

@interface SearchResultCell : UITableViewCell
@property (weak, nonatomic) id<SearchResultDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *likeStatusImage;
@property (weak, nonatomic) IBOutlet UIImageView *himage;
@property (weak, nonatomic) IBOutlet UIImageView *uimage;
@property (weak, nonatomic) IBOutlet UILabel *hname;
@property (weak, nonatomic) IBOutlet UILabel *htype;
@property (weak, nonatomic) IBOutlet UILabel *cityname;
@property (weak, nonatomic) IBOutlet UILabel *commentsNumber;
@property (weak, nonatomic) IBOutlet UIButton *isInWishlist;
- (IBAction)likeAction:(UIButton *)sender;

@end

@interface SearchResultViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSString *keyWord;
@property (copy, nonatomic) NSMutableArray *dataArray;
@end
