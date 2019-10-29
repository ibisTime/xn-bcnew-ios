//
//  TLTopCollectionView.m
//  ljs
//
//  Created by shaojianfei on 2018/6/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTopCollectionView.h"
#import "AppColorMacro.h"
#import "AddSearchCell.h"
#import "TLPlateCell.h"
@interface TLTopCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) UICollectionViewFlowLayout *Layout;
@end

@implementation TLTopCollectionView
static NSString *identifierCell = @"TLPlateCell";
static NSString *bottomIdentifierCell = @"AddSearchBottomCell";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout withImage:(NSArray *)image {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        _imageArr = image;
        _Layout = (UICollectionViewFlowLayout *)layout;
        self.pagingEnabled = NO;
//        _Layout.minimumLineSpacing      = 8.f;
//        _Layout.minimumInteritemSpacing = 8.f;
        _Layout.scrollDirection         = UICollectionViewScrollDirectionVertical;
        self.allowsSelection = YES;
        self.allowsMultipleSelection = YES;
        //        self.bounces = NO;
        self.backgroundColor = kWhiteColor;
        self.delegate = self;
        self.dataSource = self;
//        self.userInteractionEnabled = NO;
//        self.scrollEnabled = NO;

        [self registerClass:[TLPlateCell class] forCellWithReuseIdentifier:identifierCell];
        
    }
    return self;
}
#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
        return self.models.count;
        
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    TLPlateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    cell.model = self.models[indexPath.row];
    return cell;
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld分区---%ldItem", indexPath.section, indexPath.row);
    if ([self.refreshDelegate respondsToSelector:@selector(refreshCollectionView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshCollectionView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __FUNCTION__);
    return YES;
}


@end
