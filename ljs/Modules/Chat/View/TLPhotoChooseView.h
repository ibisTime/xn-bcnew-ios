//
//  TLPhotoChooseView.h
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/12.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLPhotoChooseItem.h"

@interface TLPhotoChooseView : UIView

- (void)getImgs:(void(^)(NSArray <UIImage *>*imgs))imgsBLock;

@property (nonatomic, copy, readonly, getter=getPhotoItems) NSArray <TLPhotoChooseItem *>*currentPhotoItems;


@property (nonatomic, copy) void(^addAction)();


- (void)finishChooseWithImgs:(NSArray <TLPhotoChooseItem *>*)imgs;


@end
