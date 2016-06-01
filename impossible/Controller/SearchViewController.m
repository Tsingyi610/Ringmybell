//
//  SearchViewController.m
//  impossible
//
//  Created by Blessed on 16/4/17.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultViewController.h"
#import "RMBDataSource.h"
#import "RMBRequestManager.h"

@interface SearchViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
{
    NSArray *cityArr;
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchInput.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.navigationController.navigationBar.hidden = YES;
    [self initHotCity];
}

- (void)initHotCity {
    [[RMBRequestManager sharedInstance] getLatestHotCityListCompletionHandler:^(NSString *errMsg, id data) {
        if (data) {
            cityArr = [RMBDataSource sharedInstance].hotCity;
            [self.hotCollectionView reloadData];
        }
    }];
}

- (IBAction)resetSearchInput:(id)sender {
    self.searchInput.text = @"";
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma marks - UICollectionView DataSource & Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HotCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotPlace" forIndexPath:indexPath];
    cell.cityLabel.text = cityArr[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return cityArr.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultViewController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"searchResultScene"];
    [[RMBRequestManager sharedInstance] updateHotCity:cityArr[indexPath.row] completionHandler:^(NSString *errMsg, id data) {
        if (data) {
            controller.keyWord = cityArr[indexPath.row];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    SearchResultViewController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"searchResultScene"];
    [[RMBRequestManager sharedInstance] updateHotCity:textField.text completionHandler:^(NSString *errMsg, id data) {
        if (errMsg) {
            [self showHintViewWithTitle:@"该城市暂时不支持" onView:self.view withFrame:100];
        } else {
            controller.keyWord = textField.text;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
    return YES;
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

@implementation HotCollectionCell

@end
