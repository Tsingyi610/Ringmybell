//
//  MoreOptionsViewController.m
//  impossible
//
//  Created by Blessed on 16/4/20.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "MoreOptionsViewController.h"
#import "RMBRequestManager.h"
#import "RMBDataSource.h"
#import "UIColor+Extra.h"

@interface MoreOptionsViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSInteger number;
    NSMutableArray *roomArrangement;
    
}
@property (nonatomic, copy) NSArray *facilitiesArr;
@end

@implementation MoreOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    self.visitorsNumber.text = @"1位房客";
    self.reduceImage.image = [UIImage imageNamed:@"ico_removemin"];
    self.reduceBedNumberImage.image = [UIImage imageNamed:@"ico_removemin"];
    self.reduceBedroomImage.image = [UIImage imageNamed:@"ico_removemin"];
    self.reduceSanitationImage.image = [UIImage imageNamed:@"ico_removemin"];
    [[RMBRequestManager sharedInstance] getHouseConvenienceHandler:^(NSString *errMsg, id data) {
        self.facilitiesArr = data;
        [self.facilitiesTableView reloadData];
    }];
    self.priceSlider.value = 1000.0;
    roomArrangement = [NSMutableArray arrayWithObjects:@"0",@"0",@"0", nil];
    [self initChoosingTypeTapGesture];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//更改房客数量
- (IBAction)reduceVisitor:(id)sender {
    number = [[self.visitorsNumber.text substringFromIndex:0] integerValue];
    number = number - 1;
    if (0 == number) {
        return;
    }
    if (1 == number) {
        self.reduceImage.image = [UIImage imageNamed:@"ico_removemin"];
        self.visitorsNumber.text = @"1位房客";
    } else {
        self.visitorsNumber.text = [NSString stringWithFormat:@"%ld位房客",(long)number];
        self.addImage.image = [UIImage imageNamed:@"ico_add"];
    }
}
- (IBAction)addVisitor:(id)sender {
    number = [[self.visitorsNumber.text substringFromIndex:0] integerValue];
    number = number + 1;
    if (11 == number) {
        return;
    }
    if (10 == number) {
        self.addImage.image = [UIImage imageNamed:@"ico_addmax"];
        self.visitorsNumber.text = @"10位房客";
    } else {
        self.visitorsNumber.text = [NSString stringWithFormat:@"%ld位房客",(long)number];
        self.reduceImage.image = [UIImage imageNamed:@"ico_remove"];
    }
}

- (IBAction)changePrice:(UISlider *)sender {
    int intString = sender.value;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%d",intString];
    if (sender.value == 1000.0) {
        self.priceLabel.text = @"¥1000+";
    }
}

- (void)initChoosingTypeTapGesture {
    UITapGestureRecognizer *tap2wholeHouse = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2wholeHouse)];
    UITapGestureRecognizer *tap2singleHouse = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2singleHouse)];
    UITapGestureRecognizer *tap2sharedRoom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2sharedRoom)];
    [self.wholeHouseView addGestureRecognizer:tap2wholeHouse];
    [self.singleRoomView addGestureRecognizer:tap2singleHouse];
    [self.sharedRoomView addGestureRecognizer:tap2sharedRoom];
}

- (void)tap2wholeHouse {
    if (0 == self.wholeHouseView.tag) {
        self.wholeHouseLabel.textColor = [UIColor colorWithRGB:@"#7db3e5"];
        self.wholeHouseImageBorder.backgroundColor = [UIColor colorWithRGB:@"#7db3e5"];
        self.wholeHouseImage.image = [UIImage imageNamed:@"ico_wholehouse_selected"];
        self.wholeHouseView.tag = 1;
    } else {
        self.wholeHouseLabel.textColor = [UIColor colorWithRGB:@"#303030"];
        self.wholeHouseImageBorder.backgroundColor = [UIColor colorWithRGB:@"#303030"];
        self.wholeHouseImage.image = [UIImage imageNamed:@"ico_wholehouse"];
        self.wholeHouseView.tag = 0;
    }
}

- (void)tap2singleHouse {
    if (0 == self.singleRoomView.tag) {
        self.singleRoomLabel.textColor = [UIColor colorWithRGB:@"#7db3e5"];
        self.singleRoomImageBorder.backgroundColor = [UIColor colorWithRGB:@"#7db3e5"];
        self.singleRoomImage.image = [UIImage imageNamed:@"ico_door_selected"];
        self.singleRoomView.tag = 1;
    } else {
        self.singleRoomLabel.textColor = [UIColor colorWithRGB:@"#303030"];
        self.singleRoomImageBorder.backgroundColor = [UIColor colorWithRGB:@"#303030"];
        self.singleRoomImage.image = [UIImage imageNamed:@"ico_door"];
        self.singleRoomView.tag = 0;
    }
}

- (void)tap2sharedRoom {
    if (0 == self.sharedRoomView.tag) {
        self.sharedRoomLabel.textColor = [UIColor colorWithRGB:@"#7db3e5"];
        self.sharedRoomImageBorder.backgroundColor = [UIColor colorWithRGB:@"#7db3e5"];
        self.sharedRoomImage.image = [UIImage imageNamed:@"ico_share_selected"];
        self.sharedRoomView.tag = 1;
    } else {
        self.sharedRoomLabel.textColor = [UIColor colorWithRGB:@"#303030"];
        self.sharedRoomImageBorder.backgroundColor = [UIColor colorWithRGB:@"#303030"];
        self.sharedRoomImage.image = [UIImage imageNamed:@"ico_share"];
        self.sharedRoomView.tag = 0;
    }
}

//房间安排
- (IBAction)changeBedNumber:(UIButton *)sender {
    [self changeValue:sender.tag reduceImage:self.reduceBedNumberImage andAddImage:self.addBedNumberImage index:0 defaultDisplay:@"床位数量" andNormalDisplay:@"张床" andLabel:_bedNumber];
}
- (IBAction)changeBedroomNumber:(UIButton *)sender {
    [self changeValue:sender.tag reduceImage:self.reduceBedroomImage andAddImage:self.addBedroomImage index:1 defaultDisplay:@"卧室" andNormalDisplay:@"间卧室" andLabel:_bedroomNumber];
}
- (IBAction)changeSanitationNumber:(UIButton *)sender {
    [self changeValue:sender.tag reduceImage:self.reduceSanitationImage andAddImage:self.addSanitationImage index:2 defaultDisplay:@"卫生间" andNormalDisplay:@"间卫生间" andLabel:_sanitationNumber];
}

- (void)changeValue:(NSInteger)tag reduceImage:(UIImageView *)reduceImage andAddImage:(UIImageView *)addImage index:(NSInteger)index defaultDisplay:(NSString *)defualt andNormalDisplay:(NSString *)normal andLabel:(UILabel *)label {
    if (0 == tag) {
        if (1 == [[roomArrangement objectAtIndex:index] intValue]) {
            reduceImage.image = [UIImage imageNamed:@"ico_removemin.png"];
            label.text = defualt;
            [roomArrangement replaceObjectAtIndex:index withObject:@"0"];
        } else if (0 == [[roomArrangement objectAtIndex:index] intValue]) {
            return;
        } else {
            reduceImage.image = [UIImage imageNamed:@"ico_remove.png"];
            addImage.image = [UIImage imageNamed:@"ico_add.png"];
            int temp = [[roomArrangement objectAtIndex:index] intValue];
            temp--;
            label.text = [NSString stringWithFormat:@"%d%@",temp,normal];
            if (temp <= 1) {
                label.textColor = [UIColor colorWithRGB:@"#303030"];
            }
            [roomArrangement replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%d",temp]];
        }
    } else {
        if (10 == [roomArrangement[index] intValue]) {
            addImage.image = [UIImage imageNamed:@"ico_addmax.png"];
        } else {
            addImage.image = [UIImage imageNamed:@"ico_add.png"];
            reduceImage.image = [UIImage imageNamed:@"ico_remove.png"];
            int temp = [[roomArrangement objectAtIndex:index] intValue];
            temp++;
            label.text = [NSString stringWithFormat:@"%d%@",temp,normal];
            if (temp > 1) {
                label.textColor = [UIColor colorWithRGB:@"#7db3e5"];
            }
            [roomArrangement replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%d",temp]];
        }
    }
}

- (IBAction)resetAllSettings:(id)sender {
    
}


#pragma marks - UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.facilitiesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FacilitiesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"facilitiesCell" forIndexPath:indexPath];
    cell.facilitiesName.text = self.facilitiesArr[indexPath.row];
    cell.tag = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FacilitiesCell *cell = (FacilitiesCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.tag == 0) {
        [cell.facilitiesName setTextColor:[UIColor colorWithRGB:@"#7db3e5"]];
        cell.ifSelected.image = [UIImage imageNamed:@"ico_tick"];
        cell.tag = 1;
    } else {
        cell.facilitiesName.textColor = [UIColor colorWithRGB:@"#303030"];
        cell.ifSelected.image = [UIImage imageNamed:@"ico_round"];
        cell.tag = 0;
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

@implementation FacilitiesCell

@end
