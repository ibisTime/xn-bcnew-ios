//
//  MyCollectionCell.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MyCollectionCell.h"

//Framework
//Category
#import "NSString+Check.h"

@interface MyCollectionCell()
//标题
@property (nonatomic, strong) UILabel *titleLbl;
//作者
@property (nonatomic, strong) UILabel *authorLbl;

@end

@implementation MyCollectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //标题
    self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor
                                            textColor:kHexColor(@"#3A3A3A")
                                                 font:17.0];
    self.titleLbl.numberOfLines = 0;
    
    [self addSubview:self.titleLbl];
    //作者
    self.authorLbl = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor2
                                                  font:15.0];
    
    [self addSubview:self.authorLbl];
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    //标题
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@15);
        make.width.equalTo(@(kScreenWidth - 30));
    }];
    //作者
    [self.authorLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.top.equalTo(self.titleLbl.mas_bottom).offset(6);
    }];
}

#pragma mark - Setting
- (void)setCollectionModel:(MyCollectionModel *)collectionModel {
    
    _collectionModel = collectionModel;
    
    self.titleLbl.text = collectionModel.title;
    //如果有值则选@"作者: %@"  否则 @"作者: - -"
    NSString *author = [collectionModel.auther valid] ? [NSString stringWithFormat:@"作者: %@", collectionModel.auther] : @"作者: - -";
    
    self.authorLbl.text = author;
    //
    [self layoutSubviews];
    
    collectionModel.cellHeight = self.authorLbl.yy + 15;
}

@end
