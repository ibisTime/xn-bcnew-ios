//
//  TLPhotoChooseCell.m
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/12.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "TLPhotoChooseCell.h"

@interface TLPhotoChooseCell()

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIButton *addPhotoBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation TLPhotoChooseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.photoImageView = [[UIImageView alloc] init];
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.photoImageView];
        [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            
        }];
        
        //删除按钮
        UIButton *deleteBtn = [[UIButton alloc] init];
//        deleteBtn.backgroundColor = [UIColor orangeColor];
        self.deleteBtn = deleteBtn;
        [deleteBtn setImage:[UIImage imageNamed:@"搜索－删除"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:deleteBtn];
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
            make.top.equalTo(self.contentView.mas_top);
            make.right.equalTo(self.contentView.mas_right);
            
        }];
        
        //
        self.addPhotoBtn = [[UIButton alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:self.addPhotoBtn];
//        [self.addPhotoBtn addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
        [self.addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
        self.addPhotoBtn.userInteractionEnabled = NO;
        
    }
    return self;
}


- (void)setPhototItem:(TLPhotoChooseItem *)phototItem {

    _phototItem = phototItem;
    
    if (_phototItem.isAdd) {//添加按钮
        
        
        self.addPhotoBtn.hidden = NO;
        
        self.photoImageView.hidden = YES;
        self.deleteBtn.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        
    } else {//显示
        
        self.addPhotoBtn.hidden = YES;
        self.photoImageView.hidden = NO;
        self.deleteBtn.hidden = NO;
        self.photoImageView.image = _phototItem.thumbnailImg;
        
    }

}


//- (void)setPhototItem:(TLPhotoItem *)phototItem {
//
//    _phototItem = phototItem;
//    
//    if (_phototItem.isAdd) {//添加按钮
//        
//        
//        self.addPhotoBtn.hidden = NO;
//        
//        self.photoImageView.hidden = YES;
//        self.deleteBtn.hidden = YES;
//        self.backgroundColor = [UIColor whiteColor];
//    
//
//    } else {//显示
//
//        
//        self.addPhotoBtn.hidden = YES;
//        self.photoImageView.hidden = NO;
//        self.deleteBtn.hidden = NO;
//        self.photoImageView.image = _phototItem.img;
//        
//    }
//
//}


//- (void)addPhoto {
//
//    if (self.add) {
//        self.add();
//    }
//
//}

- (void)delete {

    if (self.deleteItem) {
        
        self.deleteItem(self.phototItem);
    }


}
@end
