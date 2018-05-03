//
//  TLPhotoChooseCell.h
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/12.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TLPhotoItem.h"
#import "TLPhotoChooseItem.h"

@interface TLPhotoChooseCell : UICollectionViewCell

@property (nonatomic, copy) void(^deleteItem)(TLPhotoChooseItem *photoItem);
//@property (nonatomic, copy) void(^add)();


//
//@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, strong) TLPhotoChooseItem *phototItem;



@end
