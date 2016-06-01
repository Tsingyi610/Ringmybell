//
//  PersonalInfoViewController.m
//  impossible
//
//  Created by Blessed on 16/3/5.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "EditProfileViewController.h"
#import "RMBRequestManager.h"
#import "RMBDataSource.h"
#import "RMBAFNetworking.h"
#import "RMBUserInfo.h"
#import "Masonry.h"

@interface PersonalInfoViewController () <UITableViewDataSource,UITableViewDelegate,EditProfileDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *normalArray;
    NSArray *gender;
    NSString *selectedGender;
    NSString *sandboxPath;
    NSData *imageData;
}
@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationLightVersion:@"个人资料"];
    normalArray = @[@"姓名",@"性别",@"联系电话",@"常用邮箱",@"个人简介"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self initHeadImage];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initHeadImage {
    [[RMBAFNetworking sharedInstance] downloadUserHeadImage:[self.dataArr objectAtIndex:5] completionHandler:^(NSString *errMsg, id filePath) {
        if (filePath) {
            NSData *fileData = [NSData dataWithContentsOfFile:filePath];
            imageData = fileData;
            [self.tableView reloadData];
        }
    }];
}

- (void)changeInfomation:(NSString *)content andTag:(NSInteger)tag {
    [self.dataArr replaceObjectAtIndex:tag-1 withObject:content];
    [self.tableView reloadData];
    //[self.tableView reloadRowsAtIndexPaths:indexArr withRowAnimation:UITableViewRowAnimationNone];
}

#pragma marks - uitableview methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return normalArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        HeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headCell" forIndexPath:indexPath];
        cell.headImage.clipsToBounds = YES;
        cell.headImage.layer.cornerRadius = cell.headImage.frame.size.height/2;
        cell.headImage.image = [UIImage imageWithData:imageData];
        return cell;
    } else {
        NormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell" forIndexPath:indexPath];
        cell.normalLabel.text = normalArray[indexPath.row-1];
        cell.normalDetailLabel.text = self.dataArr[indexPath.row-1];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        return 70.0f;
    } else {
        return 44.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EditProfileViewController *editProfileScene = [self.storyboard instantiateViewControllerWithIdentifier:@"editProfileScene"];
    editProfileScene.delegate = self;
    if (0 == indexPath.row) {
        [self callAlertActionSheet2UploadHeadImage];
    } else if (5 == indexPath.row) {
        [self.navigationController pushViewController:editProfileScene animated:YES];
        editProfileScene.selectedTag = indexPath.row;
        editProfileScene.editTarget = self.dataArr[4];
    } else {
        [self.navigationController pushViewController:editProfileScene animated:YES];
        editProfileScene.editTargetLabel = normalArray[indexPath.row-1];
        editProfileScene.editTarget = self.dataArr[indexPath.row-1];
        editProfileScene.selectedTag = indexPath.row;
    }
}

- (void)callAlertActionSheet2UploadHeadImage {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"通过两种方式上传头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *uploadFromAlbum = [UIAlertAction actionWithTitle:@"从相册上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
            imagePicker.edgesForExtendedLayout = UIRectEdgeNone;
        }
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *uploadFromCamera = [UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        BOOL isSupportCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if (isSupportCamera) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
                imagePicker.edgesForExtendedLayout = UIRectEdgeNone;
            }
            [self presentViewController:imagePicker animated:YES completion:nil];
        } else {
            NSLog(@"该设备不支持照相机功能");
        }
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [controller addAction:uploadFromAlbum];
    [controller addAction:uploadFromCamera];
    [controller addAction:cancel];
    
    [self presentViewController:controller animated:YES completion:nil];
    
}

//save to sandbox

- (void)saveImage:(UIImage *)currentImage withName:(NSString *)name {
    NSData *imageDataJPEG = UIImageJPEGRepresentation(currentImage, 0.5);
    NSString *sandbox = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:name];
    sandboxPath = sandbox;
    [imageDataJPEG writeToFile:sandbox atomically:NO];
}


#pragma mark - uiimagepickercontroller delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSDate *now = [NSDate new];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMddHHmmss"];
    NSString *date = [format stringFromDate:now];
    NSString *imageName = [[date stringByAppendingString:[_dataArr objectAtIndex:2]] stringByAppendingString:@".png"];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage *origin = [info objectForKey:UIImagePickerControllerOriginalImage];
        //UIImage *edited = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImageWriteToSavedPhotosAlbum(origin, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        UIImage *getOriginImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self saveImage:getOriginImage withName:imageName];
        if (sandboxPath) {
            [[RMBAFNetworking sharedInstance] saveImageToServerWithFileName:imageName url:kImageUploadUserPath method:@"POST" andPath:sandboxPath completionHandler:^(NSString *errMsg, id data) {
                if (data) {
                    [[RMBRequestManager sharedInstance] changeHeadImage:[RMBDataSource sharedInstance].pass withImageName:imageName completionHandler:^(NSString *errMsg, id data) {
                        if (data) {
                            NSData *fileData = [NSData dataWithContentsOfFile:sandboxPath];
                            imageData = fileData;
                            [self dismissViewControllerAnimated:YES completion:nil];
                            [self.tableView reloadData];
                        }
                    }];
                }
            }];
        }
    } else {
        UIImage *getOriginImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self saveImage:getOriginImage withName:imageName];
        if (sandboxPath) {
            [[RMBAFNetworking sharedInstance] saveImageToServerWithFileName:imageName url:kImageUploadUserPath method:@"POST" andPath:sandboxPath completionHandler:^(NSString *errMsg, id data) {
                if (data) {
                    [[RMBRequestManager sharedInstance] changeHeadImage:[RMBDataSource sharedInstance].pass withImageName:imageName completionHandler:^(NSString *errMsg, id data) {
                        if (data) {
                            NSData *fileData = [NSData dataWithContentsOfFile:sandboxPath];
                            imageData = fileData;
                            [self dismissViewControllerAnimated:YES completion:nil];
                            [self.tableView reloadData];
                        }
                    }];
                }
            }];
        }
    }
}

#pragma mark - uinavigationcontroller delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([navigationController isKindOfClass:[UIImagePickerController class]]) {
        viewController.navigationController.navigationBar.translucent = NO;
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if(!error){
        NSLog(@"savesuccess");
    }else{
        NSLog(@"savefailed");
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

@implementation HeadCell

@end

@implementation NormalCell

@end
