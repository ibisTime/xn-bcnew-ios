//
//  TLPhotoCell.h
//  CityBBS
//
//  Created by  蔡卓越 on 2017/3/21.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLPhotoChooseItem.h"

@interface TLPhotoCell : UICollectionViewCell

@property (nonatomic, strong) TLPhotoChooseItem *photoItem;

//@property (nonatomic, copy) void(^chooseHandle)(TLPhotoChooseItem *item,BOOL isChoose);

@end
