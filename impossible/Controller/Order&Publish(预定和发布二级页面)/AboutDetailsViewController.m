//
//  AboutDetailsViewController.m
//  impossible
//
//  Created by Blessed on 16/5/1.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "AboutDetailsViewController.h"
#import "OptionalTextInputViewController.h"

@interface AboutDetailsViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSArray *aboutTitleArr;
    NSArray *aboutContentDefaultArr;
}
@end

@implementation AboutDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self footerView:self.tableView];
    [self changeNavigationLightVersion:@"详情"];
    aboutTitleArr = @[@"房客使用权限",@"街区概述",@"出行",@"房屋守则",@"其他注意事项"];
    aboutContentDefaultArr = @[@"房客可以使用什么便利设施？",@"您喜欢您所在的街道的什么方面？",@"出行交通是否便利？",@"您期望房客有什么样的言行举止？",@"还有什么其他信息需要分享？"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return aboutTitleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AboutDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutCell" forIndexPath:indexPath];
    cell.aboutTitle.text = aboutTitleArr[indexPath.row];
    cell.aboutContent.text = [aboutContentDefaultArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OptionalTextInputViewController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"optionalTextInputScene"];
    controller.selectTag = indexPath.row;
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

@end

@implementation AboutDetailCell

@end
