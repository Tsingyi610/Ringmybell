//
//  SearchResultViewController.m
//  impossible
//
//  Created by Blessed on 16/4/19.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "SearchResultViewController.h"
#import "ShowHouseViewController.h"
#import "RMBRequestManager.h"
#import "RMBDataSource.h"
#import "RMBHouseList.h"
#import "RMBAFNetworking.h"
#import "UIColor+Extra.h"

@interface SearchResultViewController () <UITableViewDelegate,UITableViewDataSource,SetupOptionsDelegate,SearchResultDelegate>
{
    NSArray *type;
    NSMutableArray *imagePath;
    NSMutableArray *isInWishlistHid;
    NSMutableArray *uimageArr;
}
@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"搜索城市"];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self initData];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    type = @[@"整套房子",@"独立房间",@"合住房间"];
    imagePath = [NSMutableArray arrayWithCapacity:0];
    isInWishlistHid = [NSMutableArray arrayWithCapacity:0];
    [[RMBRequestManager sharedInstance] getHouseListBySearchCityName:self.keyWord completionHandler:^(NSString *errMsg, id data) {
        self.dataArray = data;
        [[RMBRequestManager sharedInstance] myWishlist:[RMBDataSource sharedInstance].pass completionHandler:^(NSString *errMsg, id data) {
            if (data) {
                for (NSDictionary *element in [RMBDataSource sharedInstance].wishlist) {
                    [isInWishlistHid addObject:[NSString stringWithFormat:@"%@",[element objectForKey:@"hid"]]];
                    if (isInWishlistHid.count == [RMBDataSource sharedInstance].wishlist.count) {
                        for (RMBHouseList *element in self.dataArray) {
                            [[RMBAFNetworking sharedInstance] downloadHouseImage:element.himage completionHandler:^(NSString *errMsg, id filePath) {
                                if (filePath) {
                                    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
                                    [imagePath addObject:fileData];
                                    if (self.dataArray.count == imagePath.count) {
                                        [self initUserImage];
                                        //[self.tableView reloadData];
                                    }
                                }
                            }];
                        }
                    }
                }
            } else {
                for (RMBHouseList *element in self.dataArray) {
                    [[RMBAFNetworking sharedInstance] downloadHouseImage:element.himage completionHandler:^(NSString *errMsg, id filePath) {
                        if (filePath) {
                            NSData *fileData = [NSData dataWithContentsOfFile:filePath];
                            [imagePath addObject:fileData];
                            if (self.dataArray.count == imagePath.count) {
                                [self initUserImage];
                                //[self.tableView reloadData];
                            }
                        }
                    }];
                }
            }
        }];
    }];
}

- (void)initUserImage {
    uimageArr = [NSMutableArray arrayWithCapacity:0];
    for (RMBHouseList *element in self.dataArray) {
        [[RMBAFNetworking sharedInstance] downloadHouseImage:element.uimage completionHandler:^(NSString *errMsg, id filePath) {
            if (filePath) {
                NSData *fileData = [NSData dataWithContentsOfFile:filePath];
                [uimageArr addObject:fileData];
                if (self.dataArray.count == uimageArr.count) {
                    [self.tableView reloadData];
                }
            }
        }];
    }
}

#pragma marks - UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        SetupOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setupOptionsCell" forIndexPath:indexPath];
        cell.moreDetailButton.layer.borderWidth = 1.0f;
        cell.moreDetailButton.layer.borderColor = [UIColor colorWithRGB:@"#7DB3E5"].CGColor;
        cell.moreDetailButton.layer.cornerRadius = 2.0f;
        cell.delegate = self;
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCell" forIndexPath:indexPath];
        if (self.dataArray.count!=0) {
            RMBHouseList *list = [self.dataArray objectAtIndex:indexPath.row-1];
            cell.hname.text = list.hname;
            cell.htype.text = type[list.htype-1];
            cell.cityname.text = self.keyWord;
            cell.uimage.image = [UIImage imageWithData:[uimageArr objectAtIndex:indexPath.row-1]];
            cell.uimage.contentMode = UIViewContentModeScaleAspectFill;
            cell.himage.contentMode = UIViewContentModeScaleAspectFill;
            cell.himage.image = [UIImage imageWithData:[imagePath objectAtIndex:indexPath.row-1]];
            cell.isInWishlist.tag = list.hid;
            if ([isInWishlistHid containsObject:[NSString stringWithFormat:@"%lu",list.hid]]) {
                //cell.isInWishlist.userInteractionEnabled = NO;
                cell.likeStatusImage.image = [UIImage imageNamed:@"ico_likefill"];
                cell.likeStatusImage.tag = 1;
            } else {
                cell.likeStatusImage.image = [UIImage imageNamed:@"ico_like"];
                cell.likeStatusImage.tag = 0;
            }
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        return;
    } else {
        ShowHouseViewController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"showHouseScene"];
        RMBHouseList *list = [self.dataArray objectAtIndex:indexPath.row-1];
        controller.hid = list.hid;
        controller.himageData = [imagePath objectAtIndex:indexPath.row-1];
        controller.uimageData = [uimageArr objectAtIndex:indexPath.row-1];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        return 60.0;
    } else {
        return 240.0;
    }
}

//更多选项接口 跳转到新vc
- (void)link2chooseMoreDetails {
    UIViewController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"moreOptionsScene"];
    [self.navigationController pushViewController:controller animated:YES];
}

//收藏房源接口 负责把喜欢的状态保存
- (void)changeLikeStatus:(NSInteger)status buttontag:(NSInteger)tag {
    if (0 == status) {
        [[RMBRequestManager sharedInstance] add2WishListWithHid:tag uid:[RMBDataSource sharedInstance].pass completionHandler:^(NSString *errMsg, id data) {
            if (data) {
                [self initData];
            }
        }];
    } else {
        [[RMBRequestManager sharedInstance] dtagWishList:tag uid:[RMBDataSource sharedInstance].pass completionHandler:^(NSString *errMsg, id data) {
            if (data) {
                [self initData];
            }
        }];
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

@implementation SetupOptionsCell

- (IBAction)getMoreDetails:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(link2chooseMoreDetails)]) {
        [_delegate link2chooseMoreDetails];
    }
}
@end

@implementation SearchResultCell

- (IBAction)likeAction:(UIButton *)sender {
    NSInteger tag = self.likeStatusImage.tag;
    if (0 == tag) {
        self.likeStatusImage.image = [UIImage imageNamed:@"ico_likefill"];
        self.likeStatusImage.tag = 1;
    } else {
        self.likeStatusImage.image = [UIImage imageNamed:@"ico_like"];
        self.likeStatusImage.tag = 0;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(changeLikeStatus:buttontag:)]) {
        [_delegate changeLikeStatus:tag buttontag:sender.tag];
    }
}
@end
