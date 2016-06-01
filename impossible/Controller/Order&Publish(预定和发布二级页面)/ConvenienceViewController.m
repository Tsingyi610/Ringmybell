//
//  ConvenienceViewController.m
//  impossible
//
//  Created by Blessed on 16/5/1.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "ConvenienceViewController.h"
#import "RMBRequestManager.h"
#import "RMBDataSource.h"
#import "UIColor+Extra.h"

@interface ConvenienceViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableDictionary *selectedConvenience;
}
@property (nonatomic, copy) NSArray *convenienceArr;

@end

@implementation ConvenienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"选择便利设施"];
    [self footerView:self.tableView];
    [[RMBRequestManager sharedInstance] getHouseConvenienceHandler:^(NSString *errMsg, id data) {
        self.convenienceArr = data;
        [self.tableView reloadData];
    }];
    selectedConvenience = [NSMutableDictionary dictionaryWithCapacity:0];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - uitableview delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.convenienceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConvenienceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"convenienceCell" forIndexPath:indexPath];
    cell.convenienceLabel.text = [self.convenienceArr objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ConvenienceCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.tag == 0) {
        [cell.convenienceLabel setTextColor:[UIColor colorWithRGB:@"#7db3e5"]];
        cell.convenienceImage.image = [UIImage imageNamed:@"ico_tick"];
        cell.tag = 1;
        [selectedConvenience setObject:[NSString stringWithFormat:@"%lu",indexPath.row+1] forKey:[NSString stringWithFormat:@"%lu",indexPath.row+1]];
    } else {
        cell.convenienceLabel.textColor = [UIColor colorWithRGB:@"#303030"];
        cell.convenienceImage.image = [UIImage imageNamed:@"ico_round"];
        cell.tag = 0;
        [selectedConvenience removeObjectForKey:[NSString stringWithFormat:@"%lu",indexPath.row+1]];
    }
}
- (IBAction)confirmButton:(id)sender {
    NSArray *values = [selectedConvenience allValues];
    NSString *new_values = @"";
    for (int i=0; i<values.count; i++) {
        if (i == 0) {
            NSString *element = [values objectAtIndex:i];
            NSString *append = [NSString stringWithFormat:@"%@",element];
            new_values = [new_values stringByAppendingString:append];
        } else {
            NSString *element = [values objectAtIndex:i];
            NSString *append = [NSString stringWithFormat:@".%@",element];
            new_values = [new_values stringByAppendingString:append];
        }
    }
    [[RMBRequestManager sharedInstance] updateHouseMinor:[RMBDataSource sharedInstance].hid arg:@"hconvenience" andValue:new_values completionHandler:^(NSString *errMsg, id data) {
        if (data) {
            [RMBDataSource sharedInstance].convenienceArray = values;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
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

@implementation ConvenienceCell

@end
