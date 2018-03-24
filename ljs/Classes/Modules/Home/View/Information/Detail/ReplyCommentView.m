//
//  ReplyCommentView.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ReplyCommentView.h"
//M
#import "UILabel+Extension.h"
//评论人
//回复内容
@interface ReplyCommentView()
//评论人
@property (nonatomic, strong) UILabel *commenterLbl;
//回复内容
@property (nonatomic, strong) UILabel *contentLbl;

@end

@implementation ReplyCommentView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.backgroundColor = kHexColor(@"F6F6F6");
    //评论人
    self.commenterLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kTextColor
                                                     font:16.0];
    
    [self addSubview:self.commenterLbl];
    [self.commenterLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@10);
    }];
    //回复内容
    self.contentLbl = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kTextColor
                                                   font:16.0];
    [self addSubview:self.contentLbl];
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commenterLbl.mas_left);
        make.top.equalTo(self.commenterLbl.mas_bottom).offset(8);
    }];
}

#pragma mark - Setting
- (void)setCommentModel:(InfoCommentModel *)commentModel {
    
    _commentModel = commentModel;
    
    if ([commentModel.isTop isEqualToString:@"0"]) {
        
        NSString *text = [NSString stringWithFormat:@"%@ 回复 %@:", commentModel.nickname, commentModel.parentNickName];
        
        [self.commenterLbl labelWithString:text title:@"回复" font:Font(16.0) color:kTextColor2];
        
    } else {
        
        self.commenterLbl.text = [NSString stringWithFormat:@"%@:", commentModel.nickname];
    }
    self.contentLbl.text = commentModel.content;
    
    [self layoutIfNeeded];

//    [self layoutSubviews];
    
    self.height = self.contentLbl.yy + 10;
}

@end
