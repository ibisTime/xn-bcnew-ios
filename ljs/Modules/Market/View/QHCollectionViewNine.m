//
//  QHCollectionViewNine.m
//  Collection
//
//  Created by qh on 16/5/24.
//  Copyright © 2016年 qh. All rights reserved.
//

#import "QHCollectionViewNine.h"
#import "AppColorMacro.h"
#import "AddSearchCell.h"
#import "AddSearchBottomCell.h"
@interface QHCollectionViewNine ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) UICollectionViewFlowLayout *Layout;
@end
@implementation QHCollectionViewNine
static NSString *identifierCell = @"AddSearchCell";
static NSString *bottomIdentifierCell = @"AddSearchBottomCell";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout withImage:(NSArray *)image {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        _imageArr = image;
        _Layout = (UICollectionViewFlowLayout *)layout;
        self.pagingEnabled = NO;
        _Layout.minimumLineSpacing      = 8.f;
        _Layout.minimumInteritemSpacing = 8.f;
        _Layout.scrollDirection         = UICollectionViewScrollDirectionVertical;
        self.allowsSelection = YES;
        self.allowsMultipleSelection = YES;
//        self.bounces = NO;
        self.backgroundColor = kBackgroundColor;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[AddSearchCell class] forCellWithReuseIdentifier:identifierCell];
        [self registerClass:[AddSearchBottomCell class] forCellWithReuseIdentifier:bottomIdentifierCell];

    }
    return self;
}
#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.type == SearchTypeTop) {
        return self.titles.count + 1;

    }else{
        
        return self.bottomtitles.count;

    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.type == SearchTypeTop) {
        AddSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
        if (indexPath.row == 0) {
            [cell.selectedBtn setTitle:@"全部" forState:(UIControlStateNormal)];
        }else
        {
            cell.toptitle = self.titles[indexPath.row - 1];
        }
        

        return cell;
    }else{
        AddSearchBottomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bottomIdentifierCell forIndexPath:indexPath];
        cell.title = self.bottomtitles[indexPath.row];
        return cell;
    }
    
 
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
