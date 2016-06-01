//
//  WishListViewController.m
//  impossible
//
//  Created by Blessed on 16/2/19.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "WishListViewController.h"
#import "ShowHouseViewController.h"
#import "RMBDataSource.h"
#import "RMBRequestManager.h"
#import "RMBAFNetworking.h"

@interface WishListViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *imagePath;
}
@end

@implementation WishListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self footerView:self.tableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initStatusBar];
    [self initData];
}

- (void)initStatusBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)initData {
    [[RMBRequestManager sharedInstance] myWishlist:[RMBDataSource sharedInstance].pass completionHandler:^(NSString *errMsg, id data) {
        if (errMsg) {
            self.noDataDisplay.hidden = NO;
            self.tableView.hidden = YES;
        } else {
            self.noDataDisplay.hidden = YES;
            self.tableView.hidden = NO;
            [self initImage];
        }
    }];
}

- (void)initImage {
    imagePath = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *element in [RMBDataSource sharedInstance].wishlist) {
        [[RMBAFNetworking sharedInstance] downloadHouseImage:[element objectForKey:@"himage"] completionHandler:^(NSString *errMsg, id filePath) {
            if (filePath) {
                NSData *fileData = [NSData dataWithContentsOfFile:filePath];
                [imagePath addObject:fileData];
                if (imagePath.count == [RMBDataSource sharedInstance].wishlist.count) {
                    [self.tableView reloadData];
                }
            }
        }];
    }
}

#pragma marks - UITableView methods:

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [RMBDataSource sharedInstance].wishlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WishListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wishListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.hname.text = [[[RMBDataSource sharedInstance].wishlist objectAtIndex:indexPath.row] objectForKey:@"hname"];
    cell.hcity.text = [[[RMBDataSource sharedInstance].wishlist objectAtIndex:indexPath.row] objectForKey:@"city"];
    cell.price_per.text = [NSString stringWithFormat:@"%@",[[[RMBDataSource sharedInstance].wishlist objectAtIndex:indexPath.row] objectForKey:@"price_per"]];
    cell.wishListImage.image = [UIImage imageWithData:[imagePath objectAtIndex:indexPath.row]];
    cell.wishListImage.contentMode = UIViewContentModeScaleAspectFill;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowHouseViewController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"showHouseScene"];
    controller.hid = [[[[RMBDataSource sharedInstance].wishlist objectAtIndex:indexPath.row] objectForKey:@"hid"] integerValue];
    controller.himageData = [imagePath objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - no data action
- (IBAction)noDataAction2Search:(id)sender {
    UIViewController *searchVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"searchScene"];
    [self.navigationController pushViewController:searchVC animated:YES];
}



@end

@implementation WishListCell

@end
