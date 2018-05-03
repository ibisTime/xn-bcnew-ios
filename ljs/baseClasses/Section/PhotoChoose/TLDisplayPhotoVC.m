//
//  TLDisplayPhotoVC.m
//  CityBBS
//
//  Created by  蔡卓越 on 2017/3/21.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "TLDisplayPhotoVC.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import <Photos/Photos.h>
#import "TLPhotoChooseItem.h"
#import "TLPhotoCell.h"
#import "TLChooseResultManager.h"
#import "ZipImg.h"

#import "TLAlert.h"

@interface TLDisplayPhotoVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray <PHAsset *> *assetRoom;
@property (nonatomic, strong) NSMutableArray <TLPhotoChooseItem *> *photoItems;

@end

@implementation TLDisplayPhotoVC
{
//    dispatch_group_t _group;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (self.navigationController) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complection)];
    }
    
    //1.请求权限后在加载图片
//    PHAuthorizationStatusNotDetermined  //还不确定
//    PHAuthorizationStatusRestricted, //拒绝受限制，可能是权限，或者家长控制
//    PHAuthorizationStatusDenied,   明确拒绝访问相册
//    PHAuthorizationStatusAuthorized // 允许访问
    
    switch ([PHPhotoLibrary authorizationStatus]) {
            
        case PHAuthorizationStatusNotDetermined: {
        
            
        }
        break;
            
        case PHAuthorizationStatusRestricted: {
            //提示用户打开相册，并返回
            
            [TLAlert alertWithTitle:nil msg:@"您尚未允许链接社访问您的相册" confirmMsg:@"设置" cancleMsg:@"取消" maker:self.navigationController cancle:^(UIAlertAction *action) {
                
                
            } confirm:^(UIAlertAction *action) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            
            return;

            
        }
            
        break;
            
        case PHAuthorizationStatusDenied: {
            //提示用户打开相册，并返回
//            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
            [TLAlert alertWithTitle:nil msg:@"您尚未允许链接社访问您的相册" confirmMsg:@"设置" cancleMsg:@"取消" maker:self.navigationController cancle:^(UIAlertAction *action) {
                
                
            } confirm:^(UIAlertAction *action) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            
            return;
        }
            
        break;
            
        case PHAuthorizationStatusAuthorized: {
            
            [self beginLoadPhoto];
            return;
            
        }
        break;
    }
    
    //如果是尚未确定是否能访问相册将调用该方法
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            switch ([PHPhotoLibrary authorizationStatus]) {
                case PHAuthorizationStatusNotDetermined: {
                    
                }
                    break;
                    
                case PHAuthorizationStatusRestricted: {
                    
                }
                    
                    break;
                    
                case PHAuthorizationStatusDenied: {
                    
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
                    break;
                    
                case PHAuthorizationStatusAuthorized: {
                    
                    //开始加载图片
                    [self beginLoadPhoto];
                    
                }
                    break;
            }
            
        });
       
        
    }];
    
    
   
    
}

#pragma mark- 开始加载图片
- (void)beginLoadPhoto {

    CGFloat w = (kScreenWidth - 2*3)/4.0;

    
//    _group = dispatch_group_create();
    self.assetRoom = [NSMutableArray array];
    self.photoItems = [NSMutableArray array];
    
    //第一格为相机
    TLPhotoChooseItem *cameraItem = [TLPhotoChooseItem new];
    cameraItem.isCamera = YES;
    [self.photoItems addObject:cameraItem];
 

    //----// 以下为获取图片
    
    
    //图片库
    //    PHPhotoLibrary *photoLibrary = [PHPhotoLibrary sharedPhotoLibrary];
    
    //一、  PHAsset 和 PHCollection 两种途径获取资源
    //二、  两个子类 1.PHCollectionList:文件夹  2.PHAssetCollection:相册
    //    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
    //        NSLog(@"获取权限");
    //    }];
    
//    //获取相册
//    PHFetchResult<PHAssetCollection *> *albumResult = [PHAssetCollection
//                                                       
//                                                       fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
//                                                       subtype:PHAssetCollectionSubtypeAny
//                                                       options:nil];
//    
//    //遍历相册
//    [albumResult enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        
//        if ([obj isKindOfClass:[PHAssetCollection class]]) {
//            
//            PHFetchOptions *assetsFetchOptions = [[PHFetchOptions alloc] init];
//            assetsFetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
//            
//            PHFetchResult<PHAsset *> *assetsResult =  [PHAsset fetchAssetsInAssetCollection:obj options:assetsFetchOptions];
//            
//            //遍历相册里的图片
//            [assetsResult enumerateObjectsUsingBlock:^(PHAsset * _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
//                
//                //只获取图片资源
//                if (asset.mediaType == PHAssetMediaTypeImage) {
//                    
//                    [self.assetRoom addObject:asset];
//                    
//                    TLPhotoChooseItem *photoItem = [TLPhotoChooseItem new];
//                    photoItem.thumbnailSize = CGSizeMake(w, w);
//                    photoItem.asset = asset;
//                    [self.photoItems addObject:photoItem];
//                    
//                    //比对已经选择的图片，进行展示
//                    if (self.replacePhotoItems) {
//                        
//                        [self.replacePhotoItems enumerateObjectsUsingBlock:^(TLPhotoChooseItem * _Nonnull replaceItem, NSUInteger idx, BOOL * _Nonnull stop) {
//                            
//                            if ([photoItem.asset.localIdentifier isEqualToString: replaceItem.asset.localIdentifier]) {
//                                
//                                photoItem.isSelected = YES;
//                            }
//                            
//                        }];
//                    }
//                }
//                
//            }];
//            *stop = YES;
//        }
//        
//    }];
    
    
    ///
    
    PHFetchOptions *assetsFetchOptions = [[PHFetchOptions alloc] init];
    assetsFetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult<PHAsset *> *assetsResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:assetsFetchOptions];
    [assetsResult enumerateObjectsUsingBlock:^(PHAsset * _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.assetRoom addObject:asset];
        
        TLPhotoChooseItem *photoItem = [TLPhotoChooseItem new];
        
        photoItem.thumbnailSize = CGSizeMake(w, w);
        photoItem.asset = asset;
        [self.photoItems addObject:photoItem];
        
        //比对已经选择的图片，进行展示
        if (self.replacePhotoItems) {
            
            [self.replacePhotoItems enumerateObjectsUsingBlock:^(TLPhotoChooseItem * _Nonnull replaceItem, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([photoItem.asset.localIdentifier isEqualToString: replaceItem.asset.localIdentifier]) {
                    
                    photoItem.isSelected = YES;
                }
                
            }];
        }
        
        
    }];
    
    //从相册中，获取图片资源
    
    //由 asset 获取图片
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    
    //带有缓存的取出图片 比PHImageManager 性能更好
    //什么时候缓存完成呢
    PHCachingImageManager *cachingImageManager = (PHCachingImageManager *)[PHCachingImageManager defaultManager];
    cachingImageManager.allowsCachingHighQualityImages = NO;
    [cachingImageManager startCachingImagesForAssets:self.assetRoom
                                          targetSize:CGSizeMake(w, w)
                                         contentMode:PHImageContentModeAspectFit
                                             options:imageRequestOptions];

    
    
    
    //
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 2;
    flowLayout.minimumInteritemSpacing = 2;
    
    flowLayout.itemSize = CGSizeMake(w, w);
    
    //
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor backgroundColor];
    
    //
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        
    }];
    
    [collectionView registerClass:[TLPhotoCell class] forCellWithReuseIdentifier:@"id"];
}

#pragma mark- 确定图片选择,
- (void)complection {
    
    NSMutableArray <UIImage *>*imgs = [NSMutableArray array];
    NSInteger count = [TLChooseResultManager manager].hasChooseItems.count;
    
//    //外界希望得到的应该是原图
//    [[TLChooseResultManager manager].hasChooseItems enumerateObjectsUsingBlock:^(TLPhotoChooseItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        
//        dispatch_group_enter(_group);
//        //异步获取
//        [[PHImageManager defaultManager] requestImageForAsset:obj.asset
//                                                   targetSize:PHImageManagerMaximumSize
//                                                  contentMode:PHImageContentModeAspectFill
//                                                      options:nil
//                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//            
////            NSLog(@"%@",result);
//           [imgs addObject:result];
//            NSLog(@"%ld",count - 1 -idx);
//                                                    
//           dispatch_group_leave(_group);
//            
//        }];
//        
//    }];
    
    imgs = nil;
    
    //判断方式有问题 ，注意
    if ( self.delegate && [self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingWithImages:chooseItems:)]) {
        
        [self.delegate imagePickerController:self.pickerCtrl didFinishPickingWithImages:imgs chooseItems:[TLChooseResultManager manager].hasChooseItems];
        
    }
    
  
    
}

- (void)cancel {
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        
//        [[TLChooseResultManager manager].hasChooseItems removeAllObjects];
        [self.delegate imagePickerControllerDidCancel:self.pickerCtrl];
        
    }
 
    
}

#pragma mark- imagePickerDelegate//拍照图片选择  选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *img = (UIImage *)info[@"UIImagePickerControllerOriginalImage"];
    
    ZipImg *zipImg = [[ZipImg alloc] init];

    [zipImg zipImg:img begin:^{
        
        
    } end:^(UIImage *img) {
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        //
        if ( self.delegate && [self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingWithImages: chooseItems:)]) {
            
            
            __block NSString *localIdentifier = nil;
            //
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                
                PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:img];
                
                //得到唯一标识符
                localIdentifier = req.placeholderForCreatedAsset.localIdentifier;
                
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                
                if (success && localIdentifier) {
                    
                    PHFetchResult <PHAsset *>*resulst =  [PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil];
                    
                    if (resulst.count > 0) {
                        
                        PHAsset *asset =  [resulst objectAtIndex:0];
                        
                        
                        TLPhotoChooseItem *photoItem = [[TLPhotoChooseItem alloc] init];
                        photoItem.asset = asset;
                        photoItem.thumbnailImg = img;
                        //添加到
                        [[TLChooseResultManager manager].hasChooseItems addObject:photoItem];
                        
                        //回到主线程
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.delegate imagePickerController:self.pickerCtrl didFinishPickingWithImages:nil chooseItems:[TLChooseResultManager manager].hasChooseItems];
                            
                        });
                        
                        
                        
                    }
                    
                    
                }
                
            }];
        }
    }];
    
}

//--//
//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
//
//
//}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.photoItems[indexPath.row].isCamera) { //拍照
        
        if ([TLChooseResultManager manager].hasChooseItems.count >= 9) {
            
            [TLAlert alertWithInfo:@"图片数量不能大于9"];
            return;
        }
        
        UIImagePickerController *cameraController = [[UIImagePickerController alloc] init];
        cameraController.delegate = self;
        cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:cameraController animated:YES completion:nil];
        
    } else {//选择图片
        
        
    }
    
}
#pragma mark- dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.photoItems.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TLPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"id" forIndexPath:indexPath];
    cell.photoItem = self.photoItems[indexPath.row];
    return cell;
    
}

@end
