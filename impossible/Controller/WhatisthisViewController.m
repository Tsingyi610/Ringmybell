//
//  WhatisthisViewController.m
//  impossible
//
//  Created by Blessed on 16/3/4.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "WhatisthisViewController.h"

@interface WhatisthisViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *_headerImage;
}
@end

@implementation WhatisthisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, -200.0, self.view.frame.size.width, 200)];
    self.tableview.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    _headerImage.contentMode = UIViewContentModeScaleAspectFill;
    _headerImage.image = [UIImage imageNamed:@"index_1"];
    [self.tableview addSubview:_headerImage];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cell *cell = [tableView dequeueReusableCellWithIdentifier:@"testCell" forIndexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    if (offset < -20) {
        CGRect frame = _headerImage.frame;
        frame.origin.y = offset;
        frame.size.height = -offset;
        _headerImage.frame = frame;
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

@implementation cell

@end
