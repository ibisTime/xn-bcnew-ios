//
//  TLTopCollectionView.h
//  ljs
//
//  Created by shaojianfei on 2018/6/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseCollectionView.h"
#import "PlateMineModel.h"
@interface TLTopCollectionView : BaseCollectionView
@property (nonatomic, strong) NSMutableArray <PlateMineModel *>*models;
//@property (nonatomic, strong) NSMutableArray <CurrencyTitleModel *>*resultTitleList;


/**
 *  @frame: collectionView的frame
 *
 *  @layout: UICollectionViewFlowLayout的属性 这次放在外界设置了，比较方便
 *
 *  @image: 本地图片数组(NSArray<UIImage *> *) 或者网络url的字符串(NSArray<NSString *> *)
 *
 */
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout withImage:(NSArray *)image;
@end
