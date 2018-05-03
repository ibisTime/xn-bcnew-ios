//
//  TLEmoticonInputView.m
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/4.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "TLEmoticonInputView.h"
#import "TLEmoticonCell.h"
#import "TLEmoticonGroup.h"
#import "TLEmoticonHelper.h"
#import "TLTypeChangeView.h"
#import "TLEmoticonCollectionView.h"

NSString *const kEmoticonCellId = @"emoticonCellId";

#define PAGE_CONTROL_HEIGHT 18
#define PAGE_CONTROL_BOOTOM_MARGIN 10
//#define TYPE_CHANGE_HEIGHT 37

#define FACE_HEIGHT 150

#define BACKGROUND_COLOR [UIColor colorWithHexString:@"#f9f9f9"]


@interface TLEmoticonInputView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIPageControl *pageCtrl;
@property (nonatomic, strong) TLEmoticonCollectionView *emoticonViews;

@property (nonatomic, strong) TLTypeChangeView *typeChangeView;



@end

@implementation TLEmoticonInputView

+ (instancetype)shareView {
    
    static TLEmoticonInputView *view;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [[TLEmoticonInputView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 216)];
        view.userInteractionEnabled = YES;
    });
    
    return view;

}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
        self.backgroundColor = BACKGROUND_COLOR;
        
        //表情
        [self addSubview:self.emoticonViews];
//        self.emoticonViews.userInteractionEnabled = NO;
        __weak typeof(self) weakself = self;
        self.emoticonViews.editAction = ^(BOOL isDelete,TLEmoticon *emoticon){
        
            if (weakself.editAction) {
                weakself.editAction(isDelete,emoticon);
            }
        
        };
        
        //pageControl
        [self addSubview:self.pageCtrl];
        
        //页数
        self.pageCtrl.numberOfPages = [[TLEmoticonHelper shareHelper].pageCountArray[0] integerValue];

        //切换按钮
        [self addSubview:self.typeChangeView];

        NSMutableArray <TLEmoticonGroup *> *arr =  [TLEmoticonHelper shareHelper].emoticonGroups;
        
        NSMutableArray *types = [[NSMutableArray alloc] initWithCapacity:arr.count];
        [arr enumerateObjectsUsingBlock:^(TLEmoticonGroup * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [types addObject:obj.group_name_cn];
        }];
        
        self.typeChangeView.typeNames = types;
        
        self.typeChangeView.changeType = ^(NSInteger idx) {
        
          NSInteger start = [[TLEmoticonHelper shareHelper].startPageArray[idx] integerValue];
            [weakself.emoticonViews setContentOffset:CGPointMake(start*weakself.emoticonViews.width, 0) animated:NO];
        
        };
        
    }
    
    return self;
    
}



#pragma mark- collectionViewDelegate
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    TLEmoticonCell *cell = (TLEmoticonCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    if (self.editAction && !(cell.emoticon == nil && cell.isDelete == NO)) {
//        
//        self.editAction(cell.isDelete,cell.emoticon);
//    }
//
//}

#pragma mark- scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    //
    NSInteger currentPage = scrollView.contentOffset.x/self.frame.size.width;
    
    TLEmoticonHelper *helper = [TLEmoticonHelper shareHelper];
    
    //判断位于哪一组
    NSInteger currentGroup = [helper getCurrentGroupBySection:currentPage];
    
    [self.typeChangeView changeTypeByIdx:currentGroup];
    
    if (currentPage == [helper.startPageArray[currentGroup] integerValue]) {
        
        self.pageCtrl.numberOfPages = [helper.pageCountArray[currentGroup] integerValue];
        self.pageCtrl.currentPage = 0;

        
    } else if(currentPage == [helper.pageCountArray[currentGroup] integerValue] - 1) {
     
        self.pageCtrl.numberOfPages = [helper.pageCountArray[currentGroup] integerValue];
        self.pageCtrl.currentPage = [helper.pageCountArray[currentGroup] integerValue] - 1 ;
    
    } else { //大于
    
        
       self.pageCtrl.currentPage = currentPage - [helper.startPageArray[currentGroup] integerValue];
    
    }
    
    

    
}

- (TLTypeChangeView *)typeChangeView {

    if (!_typeChangeView) {
        
        _typeChangeView = [[TLTypeChangeView alloc] initWithFrame:CGRectMake(0, self.pageCtrl.yy + PAGE_CONTROL_BOOTOM_MARGIN, self.width, self.height - FACE_HEIGHT - PAGE_CONTROL_HEIGHT - PAGE_CONTROL_BOOTOM_MARGIN)];
    }
    return _typeChangeView;

}

- (UIPageControl *)pageCtrl {

    if (!_pageCtrl) {
        
        UIPageControl *pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emoticonViews.frame), self.frame.size.width, PAGE_CONTROL_HEIGHT)];
        [self addSubview:pageCtrl];
        pageCtrl.numberOfPages = 10;
        pageCtrl.pageIndicatorTintColor = [UIColor grayColor];
        pageCtrl.currentPageIndicatorTintColor = [UIColor orangeColor];
        pageCtrl.userInteractionEnabled = NO;
        _pageCtrl = pageCtrl;
    }
    
    return _pageCtrl;

}


- (TLEmoticonCollectionView *)emoticonViews {

    if (!_emoticonViews) {
    
        CGRect frame = CGRectMake(0, 0, self.width, FACE_HEIGHT);
        //布局对象
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //
        CGFloat w = (self.frame.size.width - 20)/7.0;
        CGFloat h = frame.size.height/3.0;
        
        flowLayout.itemSize = CGSizeMake(w, h);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        //
        _emoticonViews = [[TLEmoticonCollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _emoticonViews.backgroundColor = BACKGROUND_COLOR;
        _emoticonViews.delegate = self;
        _emoticonViews.dataSource = self;
        _emoticonViews.pagingEnabled = YES;
        _emoticonViews.showsVerticalScrollIndicator = NO;
        _emoticonViews.showsHorizontalScrollIndicator = NO;
        _emoticonViews.clipsToBounds = NO;
        _emoticonViews.canCancelContentTouches = NO;
        _emoticonViews.multipleTouchEnabled = NO;
        
        //注册
        [_emoticonViews registerClass:[TLEmoticonCell class] forCellWithReuseIdentifier:kEmoticonCellId];
//
    }
    return _emoticonViews;
}

//每页20个表情
//3行
#pragma mark- DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return  [TLEmoticonHelper shareHelper].totalPageCount;
    
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return kOnePageCount + 1;
  
}

//
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    TLEmoticonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kEmoticonCellId forIndexPath:indexPath];
//    cell.backgroundColor = RandomColor;
    
    //
    TLEmoticon *emoticon = [[TLEmoticonHelper shareHelper] getTransformEmoticonByIndexPath:indexPath];
    
    if (indexPath.row == kOnePageCount) {
        
        //先设置
        cell.isDelete = YES;
        cell.emoticon = nil;

    } else {
    
        cell.isDelete = NO;
        cell.emoticon = emoticon;

    }
    
    return cell;
    
}






//--
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return  YES;
    
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    
    
}

//
//- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
//    //判断手势状态
//    switch (longGesture.state) {
//            
//            //1.开始移动
//        case UIGestureRecognizerStateBegan:{
//            //判断手势落点位置是否在路径上
//            NSIndexPath *indexPath = [self.emoticonViews indexPathForItemAtPoint:[longGesture locationInView:self.emoticonViews]];
//            if (indexPath == nil) {
//                break;
//            }
//            //在路径上则开始移动该路径上的cell
//            [self.emoticonViews beginInteractiveMovementForItemAtIndexPath:indexPath];
//        }
//            break;
//            
//            //2.移动过程当中随时更新cell位置
//        case UIGestureRecognizerStateChanged: {
//            
//            [self.emoticonViews updateInteractiveMovementTargetPosition:[longGesture locationInView:self.emoticonViews]];
//        }
//            break;
//            
//            //3.移动结束后关闭cell移动
//        case UIGestureRecognizerStateEnded: {
//            
//            [self.emoticonViews endInteractiveMovement];
//            
//        }
//            break;
//            
//        default:
//            [self.emoticonViews cancelInteractiveMovement];
//            break;
//    }
//}

@end








