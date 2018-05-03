//
//  TLPhotoItem.h
//  CityBBS
//
//  Created by  蔡卓越 on 2017/3/21.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface TLPhotoChooseItem : NSObject

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) UIImage *thumbnailImg;
@property (nonatomic, assign) CGSize thumbnailSize;

//只有在选择完成之后展示才有效
@property (nonatomic, assign) BOOL isAdd;

//是否为相机拍摄
@property (nonatomic, assign) BOOL isCamera;

//是否为选中已经选中的图片
@property (nonatomic, assign) BOOL isSelected;


@end
