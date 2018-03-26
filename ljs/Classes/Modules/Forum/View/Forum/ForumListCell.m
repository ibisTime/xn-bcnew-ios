//
//  ForumListCell.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ForumListCell.h"

@interface ForumListCell()

//吧名
@property (nonatomic, strong) UILabel *postBarNameLbl;
//关注量
@property (nonatomic, strong) UILabel *followNumLbl;
//发帖量
@property (nonatomic, strong) UILabel *postNumLbl;
//更贴数
@property (nonatomic, strong) UILabel *updatePostNumLbl;
//排名
@property (nonatomic, strong) UIImageView *rankIV;
//
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation ForumListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    _isFirst = YES;
    //吧名
    self.postBarNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor
                                                       font:17.0];
    [self addSubview:self.postBarNameLbl];
    //关注量
    self.followNumLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kTextColor2
                                                     font:15.0];
    [self addSubview:self.followNumLbl];
    //发帖量
    self.postNumLbl = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kTextColor2
                                                   font:15.0];
    [self addSubview:self.postNumLbl];
    //更贴数
    self.updatePostNumLbl = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kTextColor2
                                                   font:15.0];
    [self addSubview:self.updatePostNumLbl];
    //关注
    self.followBtn = [UIButton buttonWithTitle:@"关注"
                                    titleColor:kWhiteColor
                               backgroundColor:kAppCustomMainColor
                                     titleFont:15.0
                                  cornerRadius:4];
    self.followBtn.layer.borderWidth = 1;
    self.followBtn.layer.borderColor = kAppCustomMainColor.CGColor;
    
    [self addSubview:self.followBtn];
}

- (void)setSubviewsLayout {
    
    if (!_isFirst) {
        
        return ;
    }
    if (!_isAllPost && _forumModel.isTopThree) {
        
        //排名
        self.rankIV = [[UIImageView alloc] initWithImage:kImage(_forumModel.rankImage)];
        
        [self addSubview:self.rankIV];
        [self.rankIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@10);
            make.top.equalTo(@15);
            make.width.height.equalTo(@26);
        }];
        //吧名
        [self.postBarNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.rankIV.mas_right).offset(10);
            make.centerY.equalTo(self.rankIV.mas_centerY);
        }];
    } else {
        
        //吧名
        [self.postBarNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@15);
            make.top.equalTo(@13);
        }];
    }
    
    //关注量
    [self.followNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(self.postBarNameLbl.mas_bottom).offset(13);
    }];
    //发帖量
    [self.postNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.equalTo(self.followNumLbl.mas_centerY);
        make.left.equalTo(@(kScreenWidth/3.0));
    }];
    //更贴数
    [self.updatePostNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.equalTo(self.followNumLbl.mas_centerY);
        make.left.equalTo(@(2*kScreenWidth/3.0));
    }];
    //关注
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.equalTo(self.postBarNameLbl.mas_centerY);
        make.right.equalTo(@(-15));
        make.width.equalTo(@80);
        make.height.equalTo(@35);
    }];
    
    _isFirst = NO;
}

#pragma mark - Setting
- (void)setForumModel:(ForumModel *)forumModel {
    
    _forumModel = forumModel;
    
    self.postBarNameLbl.text = [NSString stringWithFormat:@"#%@#", forumModel.name];
    self.followNumLbl.text = [NSString stringWithFormat:@"关注量:%ld", forumModel.keepCount];
    self.postNumLbl.text = [NSString stringWithFormat:@"发帖量:%ld", forumModel.postCount];
    self.updatePostNumLbl.text = [NSString stringWithFormat:@"今日更贴:%ld", forumModel.dayCommentCount];
    if ([forumModel.isKeep isEqualToString:@"1"]) {
        
        [self.followBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self.followBtn setBackgroundColor:kAppCustomMainColor forState:UIControlStateNormal];
        [self.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
    } else {
        
        [self.followBtn setTitleColor:kAppCustomMainColor forState:UIControlStateNormal];
        [self.followBtn setBackgroundColor:kWhiteColor forState:UIControlStateNormal];
        [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
    
    //布局
    [self setSubviewsLayout];
}

@end
