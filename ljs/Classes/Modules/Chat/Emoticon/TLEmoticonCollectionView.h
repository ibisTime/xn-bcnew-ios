//
//  TLEmoticonCollectionView.h
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/7.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TLEmoticon;

@interface TLEmoticonCollectionView : UICollectionView

@property (nonatomic, strong) UIImageView *magnifyImageView;
@property (nonatomic, strong) UIImageView *magnifyContent;

@property (nonatomic, copy) void (^editAction)(BOOL isDelete,TLEmoticon *emoticon);

@end
