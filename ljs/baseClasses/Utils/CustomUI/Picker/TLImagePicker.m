//
//  TLImagePicker.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/16.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLImagePicker.h"

#import "YYImageClipViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface TLImagePicker ()<YYImageClipDelegate>

@property (nonatomic,strong) UIViewController *vc;

@end

@implementation TLImagePicker

- (instancetype)initWithVC:(UIViewController *)ctrl{
    
    if (self = [super init]) {
        
        self.vc = ctrl;
        
    }
    return self;
    
}

- (void)picker {
    
    UIImagePickerController *pickCtrl = [[UIImagePickerController alloc] init];
    pickCtrl.delegate = self;
    pickCtrl.allowsEditing = self.allowsEditing;
    
    UIAlertController *chooseImageCtrl = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (self.imageType != ImageTypePhoto) {
        
        UIAlertAction *action00 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            pickCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self.vc.navigationController presentViewController:pickCtrl animated:YES completion:nil];
            
        }];
        
        [chooseImageCtrl addAction:action00];
    }
    
    if (self.imageType != ImageTypeCamera) {
        
        UIAlertAction *action01 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            pickCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self.vc presentViewController:pickCtrl animated:YES completion:nil];
            
        }];
        
        [chooseImageCtrl addAction:action01];
    }
    
    UIAlertAction *action02 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [chooseImageCtrl addAction:action02];
    [self.vc presentViewController:chooseImageCtrl animated:YES completion:nil];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        YYImageClipViewController *imgCropperVC = [[YYImageClipViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, kScreenWidth, self.clipHeight) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        
        [picker pushViewController:imgCropperVC animated:NO];
        
        return ;
    }
    //相册
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.pickFinish) {
        
        _pickFinish(nil, info);
    }
}

#pragma mark - YYImageCropperDelegate
- (void)imageCropper:(YYImageClipViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
    
    if (self.pickFinish) {
        
        _pickFinish(editedImage, nil);
    }
}

- (void)imageCropperDidCancel:(YYImageClipViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 修改拍照底部button文字
- (UIView *)findView:(UIView *)aView withName:(NSString *)name{
    
    Class cl = [aView class];
    
    NSString *desc = [cl description];
    
    if ([name isEqualToString:desc])
        
        return aView;
    
    for (NSUInteger i = 0; i < [aView.subviews count]; i++) {
        
        UIView *subView = [aView.subviews objectAtIndex:i];
        
        subView = [self findView:subView withName:name];
        
        if (subView)
            
            return subView;
    }
    
    return nil;
    
}

- (void)addSomeElements:(UIViewController *)viewController {
    
    UIView *PLCropOverlay = [self findView:viewController.view withName:@"PLCropOverlay"];
    
    [PLCropOverlay setValue:@"裁剪" forKey:@"_defaultOKButtonTitle"];
    
    UIView *PLCropOverlayBottomBar = [self findView:PLCropOverlay withName:@"PLCropOverlayBottomBar"];
    
    UIView *PLCropOverlayPreviewBottomBar = [self findView:PLCropOverlayBottomBar withName:@"PLCropOverlayPreviewBottomBar"];
    
    UIButton *userButton = PLCropOverlayPreviewBottomBar.subviews.lastObject;
    
    [userButton setTitle:@"裁剪" forState:UIControlStateNormal];
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [self addSomeElements:viewController];
    
}

@end

