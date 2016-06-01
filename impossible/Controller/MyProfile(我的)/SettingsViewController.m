//
//  SettingsViewController.m
//  impossible
//
//  Created by Blessed on 16/4/16.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSArray *staticArr;
}
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"设置"];
    staticArr = @[@"推送消息设置",@"修改登录密码",@"向我们反馈",@"当前版本",@"关于Ringmybell"];
    [self footerView:self.tableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma marks - UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return staticArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell" forIndexPath:indexPath];
    cell.staticLabel.text = [staticArr objectAtIndex:indexPath.row];
    cell.switchControl.hidden = YES;
    cell.versionLabel.hidden = YES;
    if (0 == indexPath.row) {
        cell.switchControl.hidden = NO;
        cell.indicator.hidden = YES;
    } else if (3 == indexPath.row) {
        cell.indicator.hidden = YES;
        cell.versionLabel.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (1 == indexPath.row) {
        UIViewController *resetPwd = [[self storyboard] instantiateViewControllerWithIdentifier:@"resetPasswordScene"];
        [self.navigationController pushViewController:resetPwd animated:YES];
    }
    if (2 == indexPath.row) {
        UIViewController *feedback = [[self storyboard] instantiateViewControllerWithIdentifier:@"feedbackScene"];
        [self.navigationController pushViewController:feedback animated:YES];
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

@implementation SettingsCell


@end
