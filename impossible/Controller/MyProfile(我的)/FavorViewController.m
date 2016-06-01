//
//  FavorViewController.m
//  impossible
//
//  Created by Blessed on 16/4/16.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "FavorViewController.h"
#import "RMBDataSource.h"
#import "RMBRequestManager.h"
#import "RMBAFNetworking.h"
#import "Masonry.h"
#import "CollectionListViewController.h"
#import "MRProgress.h"

@interface FavorViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary *imagePath;
}
@end

@implementation FavorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"我的收藏"];
    [self footerView:self.tableView];
    [self initLongGesture];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initData];
}

- (void)initData {
    [[RMBRequestManager sharedInstance] myDefaultCollection:[RMBDataSource sharedInstance].pass completionHandler:^(NSString *errMsg, id data) {
        if (data) {
            [[RMBRequestManager sharedInstance] myCustomCollection:[RMBDataSource sharedInstance].pass completionHandler:^(NSString *errMsg, id data) {
                if (data) {
                    imagePath = [NSMutableDictionary dictionaryWithCapacity:0];
                    [[RMBRequestManager sharedInstance] getCollectionCoverImage:[RMBDataSource sharedInstance].pass completionHandler:^(NSString *errMsg, id data) {
                        if (errMsg) {
                            [self.tableView reloadData];
                            return;
                        } else {
                            for (NSDictionary *element in [RMBDataSource sharedInstance].coverImage) {
                                [[RMBAFNetworking sharedInstance] downloadHouseImage:[element objectForKey:@"image"] completionHandler:^(NSString *errMsg, id filePath) {
                                    if (filePath) {
                                        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
                                        [imagePath setObject:fileData forKey:[element objectForKey:@"ucid"]];
                                        [self.tableView reloadData];
                                    }
                                }];
                            }
                        }
                    }];
                }
            }];
        }
    }];
}

- (void)initLongGesture {
    UILongPressGestureRecognizer *tap2delete = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(changeDtag:)];
    tap2delete.minimumPressDuration = 0.5;
    [self.tableView addGestureRecognizer:tap2delete];
}

- (void)changeDtag:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [gesture locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        if (indexPath) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if ([cell isKindOfClass:[FavorCell class]]) {
                if (0 == indexPath.row) {
                    return;
                } else {
                    NSString *cname = [[[RMBDataSource sharedInstance].customCollection objectAtIndex:indexPath.row-1] objectForKey:@"cname"];
                    UIAlertController *sure2dtag = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确认删除 %@ 收藏清单吗？",cname] message:@"该操作会将该收藏清单下所有收藏房源全部清空" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction *destructAction = [UIAlertAction actionWithTitle:@"确定删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        [MRProgressOverlayView showOverlayAddedTo:self.view title:@"正在删除..." mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
                        [[RMBRequestManager sharedInstance] dtagCustomCollection:[[[[RMBDataSource sharedInstance].customCollection objectAtIndex:indexPath.row-1] objectForKey:@"ucid"] integerValue] creater:[RMBDataSource sharedInstance].pass completionHandler:^(NSString *errMsg, id data) {
                            if (data) {
                                [MRProgressOverlayView dismissOverlayForView:self.view animated:YES completion:^{
                                    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"删除成功" mode:MRProgressOverlayViewModeCheckmark animated:YES];
                                    [self initData];
                                    dispatch_time_t delay_time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC));
                                    dispatch_after(delay_time, dispatch_get_main_queue(), ^{
                                        [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
                                    });
                                }];
                            }
                        }];
                    }];
                    
                    [sure2dtag addAction:destructAction];
                    [sure2dtag addAction:cancelAction];
                    
                    [self presentViewController:sure2dtag animated:YES completion:nil];
                }
            } else {
                NSLog(@"this is add cell");
            }
        }
    }
}

#pragma mark - uitableview delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [RMBDataSource sharedInstance].customCollection.count+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        FavorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favorCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.collectionNum.text = [NSString stringWithFormat:@"%lu个房源",[RMBDataSource sharedInstance].defaultCollection.count];
        return cell;
    } else if (1 <= indexPath.row && [RMBDataSource sharedInstance].customCollection.count >= indexPath.row) {
        FavorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favorCell"forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.collectionName.text = [[[RMBDataSource sharedInstance].customCollection objectAtIndex:indexPath.row-1] objectForKey:@"cname"];
        cell.collectionNum.text = [NSString stringWithFormat:@"%lu个房源",[[[[RMBDataSource sharedInstance].customCollection objectAtIndex:indexPath.row-1] objectForKey:@"count"]integerValue]];
        if (imagePath.count == 0) {
            cell.collectionImage.image = [UIImage imageNamed:@"houseAvatar"];
        } else {
            cell.collectionImage.image = [UIImage imageWithData:[imagePath objectForKey:[[[RMBDataSource sharedInstance].customCollection objectAtIndex:indexPath.row-1] objectForKey:@"ucid"]]];
        }
        cell.collectionImage.contentMode = UIViewContentModeScaleAspectFill;
        return cell;
    } else {
        AddCell *addCell = [tableView dequeueReusableCellWithIdentifier:@"addCell" forIndexPath:indexPath];
        return addCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionListViewController *listVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"collectionListScene"];
    if (0 == indexPath.row) {
        listVC.ucid = 0;
        [self.navigationController pushViewController:listVC animated:YES];
    } else if (1 <= indexPath.row && [RMBDataSource sharedInstance].customCollection.count >= indexPath.row) {
        listVC.ucid = [[[[RMBDataSource sharedInstance].customCollection objectAtIndex:indexPath.row-1] objectForKey:@"ucid"] integerValue];
        [self.navigationController pushViewController:listVC animated:YES];
    } else {
        UIAlertController *createCustomCollectionController = [UIAlertController alertControllerWithTitle:@"新建一个收藏清单" message:@"新建的清单会在我的收藏中显示" preferredStyle:UIAlertControllerStyleAlert];
        [createCustomCollectionController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
           textField.placeholder = @"输入清单名称（不超过8个汉字）";
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        }];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定创建" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *getListName = createCustomCollectionController.textFields.firstObject.text;
            [MRProgressOverlayView showOverlayAddedTo:self.view title:@"正在创建..." mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
            [[RMBRequestManager sharedInstance] addCollection:getListName uid:[RMBDataSource sharedInstance].pass completionHandler:^(NSString *errMsg, id data) {
                if (data) {
                    [MRProgressOverlayView dismissOverlayForView:self.view animated:YES completion:^{
                        [MRProgressOverlayView showOverlayAddedTo:self.view title:@"创建成功" mode:MRProgressOverlayViewModeCheckmark animated:YES];
                        [self initData];
                        dispatch_time_t delay_time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC));
                        dispatch_after(delay_time, dispatch_get_main_queue(), ^{
                            [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
                            
                        });
                    }];
                }
            }];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        }];
        
        confirmAction.enabled = NO;
        [createCustomCollectionController addAction:confirmAction];
        [createCustomCollectionController addAction:cancelAction];
        
        [self presentViewController:createCustomCollectionController animated:YES completion:nil];
    }
    
}

- (void)alertTextFieldDidChange:(NSNotification *)notification {
    UIAlertController *createCCController = (UIAlertController *)self.presentedViewController;
    if (createCCController) {
        UITextField *listName = createCCController.textFields.firstObject;
        UIAlertAction *confirmAction = createCCController.actions.firstObject;
        if (listName.hasText && listName.text.length<=8) {
            confirmAction.enabled = YES;
        } else {
            confirmAction.enabled = NO;
        }
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

@implementation FavorCell

@end

@implementation AddCell

@end