//
//  TLImagePickerControllerDelegate.h
//  CityBBS
//
//  Created by  蔡卓越 on 2017/3/21.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

//#import <Foundation/Foundation.h>
@class TLImagePickerController;
@class TLPhotoChooseItem;
@protocol TLImagePickerControllerDelegate <NSObject>

- (void)imagePickerControllerDidCancel:(TLImagePickerController *)picker;

- (void)imagePickerController:(TLImagePickerController *)picker didFinishPickingWithImages:(NSArray <UIImage *> *)imgs chooseItems:(NSArray <TLPhotoChooseItem *> *)itesm;

@end
