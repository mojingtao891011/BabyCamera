//
//  AccountManagerTableViewController.m
//  Babycamera
//
//  Created by bear on 15/2/2.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import "AccountManagerTableViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "AppDelegate.h"
#import "LoginService.h"
#import "Macro.h"


@interface AccountManagerTableViewController ()<UINavigationControllerDelegate , UIImagePickerControllerDelegate , UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation AccountManagerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self _initUI];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark-UI
- (void)_initUI
{
    self.tableView.contentInset = UIEdgeInsetsMake(-40, 0, 0, 0);
    
    self.userNameLabel.text = USER_NAME ;
    
    self.userImgView.layer.cornerRadius = self.userImgView.bounds.size.width / 2.0 ;
    self.userImgView.clipsToBounds = YES ;
}
#pragma mark
#pragma mark-Action
- (IBAction)signOutAction:(id)sender {
    
    AppDelegate *dele = [UIApplication sharedApplication].delegate ;
    ShareType loginType ;
    if (dele.loginType != Normal)
    {
        
        switch (dele.loginType) {
            case weixinLogin:
                loginType = ShareTypeWeixiSession ;
                break;
            case weiboLogin:
                
                loginType = ShareTypeSinaWeibo ;
                break;
            case QQLogin:
                
                loginType = ShareTypeQQSpace ;
                break;
                
            default:
                break;
        }
        
    }
    else{
        dele.loginType = Normal ;
        loginType = ShareTypeAny ; //用户名和密码登陆
    }
    
    [LoginService handleSignOutRequest:loginType];

}

- (IBAction)cameraAction:(UIButton *)sender {
    
    [[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"本地相册", nil] showInView:self.view];
    
}

#pragma mark
#pragma mark-UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerControllerSourceType sourceType ; //照片类型（是结构体）
    if (buttonIndex == 0) {
        //判断是否有摄像头
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
             [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"摄像头不能使用" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show];
            return ;
        }
        sourceType = UIImagePickerControllerSourceTypeCamera ;
    }else if (buttonIndex == 1){
        //用户相册
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary ;
        
    }else if (buttonIndex == 2){
        //取消
        return ;
    }
    UIImagePickerController  *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = sourceType ;//UIImagePickerControllerSourceTypeCamera
    imagePicker.delegate = self ;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}
#pragma mark
#pragma mark-UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _userImgView.image = info[@"UIImagePickerControllerOriginalImage"];
    
    //设置image的尺寸
    CGSize imagesize = _userImgView.image.size;
    imagesize.height =100;
    imagesize.width =100;
    //对图片大小进行压缩--
    _userImgView.image = [self imageWithImage:_userImgView.image scaledToSize:imagesize];
   // NSData *imgData = UIImageJPEGRepresentation(_userImgButton.imageView.image, 0.00001);
    //  NSLog(@"%d  , %f , %f" , [imgData length]/1024 , _userImage.size.width , _userImage.size.height );
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
   
}
//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
@end
