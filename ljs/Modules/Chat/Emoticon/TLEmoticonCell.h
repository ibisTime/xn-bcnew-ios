//
//  TLEmoticonCell.h
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/4.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLEmoticon.h"

@interface TLEmoticonCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) TLEmoticon *emoticon;
@property (nonatomic, assign) BOOL isDelete;


@end
