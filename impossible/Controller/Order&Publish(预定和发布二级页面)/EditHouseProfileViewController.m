//
//  EditHouseProfileViewController.m
//  impossible
//
//  Created by Blessed on 16/4/28.
//  Copyright © 2016年 ringmybell. All rights reserved.
//
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)

#import "EditHouseProfileViewController.h"
#import "ReusedTextFieldViewController.h"
#import "OptionalViewController.h"
#import "RMBAFNetworking.h"
#import "RMBRequestManager.h"
#import "RMBDataSource.h"
#import "AFURLResponseSerialization.h"
#import "UIColor+Extra.h"

@interface EditHouseProfileViewController () <UITableViewDelegate,UITableViewDataSource,UploadImageDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CallbackDelegate>
{
    NSArray *titleArr;
    NSArray *descArr;
    UIImage *displayImage;
    NSString *sandboxPath;
    NSArray *arguments;
    NSMutableDictionary *content;
    NSData *houseimage;
    NSString *houseimagename;
}
@end

@implementation EditHouseProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersionWithoutBack:@"完善空间细节"];
    [self footerView:self.tableview];
    [self initData];
    [self constructImageName];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    arguments = @[@"hname",@"hdesc",@"hlocation",@"price_per"];
    titleArr = @[@"撰写标题",@"编辑描述",@"设置地址",@"设置价格"];
    descArr = @[@"为您的房源撰写一个描述性的标题",@"总结您房源的亮点",@"只有已确认预定的房客才能看到您的地址",@"您可以设置一个令人惊喜的价格"];
    content = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([[RMBDataSource sharedInstance].himage  isEqual: @"houseAvatar.png"]) {
        houseimage = nil;
        return;
    }
    [[RMBAFNetworking sharedInstance] downloadHouseImage:[RMBDataSource sharedInstance].himage completionHandler:^(NSString *errMsg, id filePath) {
        if (filePath) {
            NSData *fileData = [NSData dataWithContentsOfFile:filePath];
            houseimage = fileData;
            [self.tableview reloadData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.changeButton) {
        [self.delayButton setTitle:self.changeButton forState:UIControlStateNormal];
        [self.publishedButton setTitle:@"确定修改" forState:UIControlStateNormal];
    }
    [self.tableview reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        UploadImageCell *upload = [tableView dequeueReusableCellWithIdentifier:@"uploadImageCell" forIndexPath:indexPath];
        upload.selectionStyle = UITableViewCellSelectionStyleNone;
//        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[RMBDataSource sharedInstance].himage];
//        
//        BOOL imageCheck = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
//        if (!imageCheck) {
//            upload.visualCover.hidden = YES;
//            upload.emptyImageDisplay.hidden = YES;
//        } else {
//            NSData *fileData = [NSData dataWithContentsOfFile:fullPath];
//            upload.houseImage.image = [UIImage imageWithData:fileData];
//            upload.houseImage.contentMode = UIViewContentModeScaleToFill;
//            upload.visualCover.hidden = YES;
//            upload.emptyImageDisplay.hidden = YES;
//        }
        if (!houseimage) {
            upload.visualCover.hidden = NO;
            upload.emptyImageDisplay.hidden = NO;
        } else {
            upload.houseImage.image = [UIImage imageWithData:houseimage];
            upload.houseImage.contentMode = UIViewContentModeScaleToFill;
            upload.visualCover.hidden = YES;
            upload.emptyImageDisplay.hidden = YES;
        }
        
        upload.delegate = self;
        return upload;
    } else {
        FillHouseCell *detail = [tableView dequeueReusableCellWithIdentifier:@"fillHouseProfileCell" forIndexPath:indexPath];
        detail.selectionStyle = UITableViewCellSelectionStyleNone;
        if (1 == indexPath.row) {
            if ([[RMBDataSource sharedInstance].hname isEqual:@""] || [detail.completedContent.text isEqualToString:@""]) {
                detail.need2completeTitle.text = titleArr[indexPath.row-1];
                detail.need2completeContent.text = descArr[indexPath.row-1];
                detail.need2completeTitle.hidden = NO;
                detail.need2completeContent.hidden = NO;
                [content setObject:@"" forKey:@"hname"];
            } else {
                detail.need2completeTitle.hidden = YES;
                detail.need2completeContent.hidden = YES;
                detail.completedContent.hidden = NO;
                detail.completedContent.text = [RMBDataSource sharedInstance].hname;
                [content setObject:@"1" forKey:@"hname"];
            }
        } else if (2 == indexPath.row) {
            if ([[RMBDataSource sharedInstance].hdesc isEqual:@""] || [detail.completedContent.text isEqualToString:@""]) {
                detail.need2completeTitle.text = titleArr[indexPath.row-1];
                detail.need2completeContent.text = descArr[indexPath.row-1];
                detail.need2completeTitle.hidden = NO;
                detail.need2completeContent.hidden = NO;
                [content setObject:@"" forKey:@"hdesc"];
            } else {
                detail.need2completeTitle.hidden = YES;
                detail.need2completeContent.hidden = YES;
                detail.completedContent.hidden = NO;
                detail.completedContent.text = [RMBDataSource sharedInstance].hdesc;
                [content setObject:@"1" forKey:@"hdesc"];
            }
        } else if (3 == indexPath.row) {
            if ([[RMBDataSource sharedInstance].hlocation isEqual:@""] || [detail.completedContent.text isEqualToString:@""]) {
                detail.need2completeTitle.text = titleArr[indexPath.row-1];
                detail.need2completeContent.text = descArr[indexPath.row-1];
                detail.need2completeTitle.hidden = NO;
                detail.need2completeContent.hidden = NO;
                [content setObject:@"" forKey:@"hlocation"];
            } else {
                detail.need2completeTitle.hidden = YES;
                detail.need2completeContent.hidden = YES;
                detail.completedContent.hidden = NO;
                detail.completedContent.text = [RMBDataSource sharedInstance].hlocation;
                [content setObject:@"1" forKey:@"hlocation"];
            }
        } else if (4 == indexPath.row) {
            if ([RMBDataSource sharedInstance].price_per == 0 || [detail.completedContent.text isEqualToString:@""]) {
                detail.need2completeTitle.text = titleArr[indexPath.row-1];
                detail.need2completeContent.text = descArr[indexPath.row-1];
                detail.need2completeTitle.hidden = NO;
                detail.need2completeContent.hidden = NO;
                [content setObject:@"" forKey:@"price"];
            } else {
                detail.need2completeTitle.hidden = YES;
                detail.need2completeContent.hidden = YES;
                detail.completedContent.hidden = NO;
                detail.completedContent.text = [NSString stringWithFormat:@"%lu 元/晚",[RMBDataSource sharedInstance].price_per];
                [content setObject:@"1" forKey:@"price"];
            }
        }
        if (5 == indexPath.row) {
            detail.need2completeTitle.hidden = YES;
            detail.need2completeContent.hidden = YES;
            detail.otherInfoView.hidden = NO;
            detail.backgroundColor = [UIColor clearColor];
        }
        return detail;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        return;
    } else if (5 == indexPath.row){
        OptionalViewController *optionalScene = [[self storyboard] instantiateViewControllerWithIdentifier:@"optionalScene"];
        [self.navigationController pushViewController:optionalScene animated:YES];
    } else {
        ReusedTextFieldViewController *editDetailVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"reusedTFScene"];
        editDetailVC.delegate = self;
        editDetailVC.navTitleTag = indexPath.row-1;
        editDetailVC.typeArr = titleArr;
        editDetailVC.arg = arguments[indexPath.row-1];
        [self.navigationController pushViewController:editDetailVC animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        return 200;
    } else {
        return 60;
    }
}

#pragma mark - Callback Delegate

- (void)callbackData:(NSString *)data andTag:(NSInteger)tag {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag+1 inSection:0];
    NSArray *indexArr = [NSArray arrayWithObjects:indexPath, nil];
    //FillHouseCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
    FillHouseCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"fillHouseProfileCell" forIndexPath:indexPath];
    cell.completedContent.hidden = NO;
    cell.completedContent.text = data;
    
    cell.need2completeTitle.hidden = YES;
    cell.need2completeContent.hidden = YES;
    [self.tableview reloadRowsAtIndexPaths:indexArr withRowAnimation:UITableViewRowAnimationNone];
}


//图片上传
- (void)uploadImage {
    if (iOS8) {
        UIAlertController *imageAlert = [UIAlertController alertControllerWithTitle:@"选择图片获取方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        [imageAlert addAction:albumAction];
        [imageAlert addAction:cancelAction];
        
        [self presentViewController:imageAlert animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *getImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *fullImageName = [[self constructImageName]stringByAppendingString:@".png"];
    [self saveImage:getImage withName:fullImageName];
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fullImageName];
    NSData *data = [NSData dataWithContentsOfFile:fullPath];
    houseimage = data;
    sandboxPath = fullPath;
    houseimagename = fullImageName;
    [self.tableview reloadData];
}

- (NSString*)constructImageName {
    NSDate *now = [[NSDate alloc] init];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyyMMddHHmmss"];
    NSString *now_str = [format stringFromDate:now];
    NSString *imageName = [now_str stringByAppendingString:[NSString stringWithFormat:@"%lu",[RMBDataSource sharedInstance].pass]];
    NSString *finalName = [imageName stringByAppendingString:[NSString stringWithFormat:@"%lu",[RMBDataSource sharedInstance].hid]];
    
    return finalName;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//保存图片至sandbox
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)name {
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    NSString *sandbox = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:name];
    sandboxPath = sandbox;
    [imageData writeToFile:sandbox atomically:NO];
}

- (UIImage*)getImageWithName:(NSString*)name {
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:name];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    sandboxPath = fullPath;
    return savedImage;
}

//- (void)initGesture {
//    UITapGestureRecognizer *tap2upload = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadImage)];
//    self.
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)confirm2publish:(id)sender {
    
}

- (IBAction)upload2server:(id)sender {
    if ([[content objectForKey:@"hname"] isEqualToString:@""] || [[content objectForKey:@"hdesc"] isEqualToString:@""] || [[content objectForKey:@"hlocation"] isEqualToString:@""] || [[content objectForKey:@"price"] isEqualToString:@""]) {
        [self showHintViewWithTitle:@"房源基础信息需填写" onView:self.view withFrame:90];
        return;
    }
    if (sandboxPath) {
        [[RMBAFNetworking sharedInstance] saveImageToServerWithFileName:houseimagename url:[kImageUploadPath stringByAppendingString:@"/houses"] method:@"POST" andPath:sandboxPath completionHandler:^(NSString *errMsg, id data) {
            if (data) {
                [[RMBRequestManager sharedInstance] updateHouseMinor:[RMBDataSource sharedInstance].hid arg:@"himage" andValue:houseimagename completionHandler:^(NSString *errMsg, id data) {
                    if (data) {
                        [[RMBRequestManager sharedInstance] updatePublishStatus:[RMBDataSource sharedInstance].hid completionHandler:^(NSString *errMsg, id data) {
                            if (data) {
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }
                        }];
                    }
                }];
            }
        }];
    } else {
        return;
    }
}
- (IBAction)notPublished:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

@implementation UploadImageCell

- (IBAction)click2upload:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(uploadImage)]) {
        [_delegate uploadImage];
    }
}
@end

@implementation FillHouseCell

@end