//
//  TLImagePickerController.h
//  CityBBS
//
//  Created by  蔡卓越 on 2017/3/21.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//  拍过照后，会把图片存在相册
//  

#import <UIKit/UIKit.h>

#import "TLImagePickerControllerDelegate.h"
#import "TLPhotoChooseItem.h"

@class TLImagePickerController;

@interface TLImagePickerController : UINavigationController

//- (instancetype)initWithDelegate:(id<TLImagePickerControllerDelegate>)pickerDelegate;


@property (nonatomic, weak) id<TLImagePickerControllerDelegate> pickerDelegate;


/**
 重选时填入此模型，进行比对
 */
@property (nonatomic, copy) NSArray <TLPhotoChooseItem *>*replacePhotoItems;

//
@end
