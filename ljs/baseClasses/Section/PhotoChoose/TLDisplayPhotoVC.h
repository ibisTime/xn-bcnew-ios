//
//  TLDisplayPhotoVC.h
//  CityBBS
//
//  Created by  蔡卓越 on 2017/3/21.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLImagePickerControllerDelegate.h"

@class TLPhotoChooseItem;

@protocol TLImagePickerControllerDelegate ;

@interface TLDisplayPhotoVC : UIViewController

@property (nonatomic, weak) id<TLImagePickerControllerDelegate> delegate;
@property (nonatomic, weak) TLImagePickerController *pickerCtrl;

@property (nonatomic, copy) NSArray <TLPhotoChooseItem *>*replacePhotoItems;

@end
