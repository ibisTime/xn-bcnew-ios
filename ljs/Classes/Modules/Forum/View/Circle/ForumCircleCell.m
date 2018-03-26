//
//  ForumCircleCell.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ForumCircleCell.h"

//Category
#import <UIImageView+WebCache.h>
#import "NSString+Extension.h"
#import "NSString+Date.h"
#import "UIButton+EnLargeEdge.h"
//V
#import "LinkLabel.h"
#import "ReplyCommentView.h"

#define kHeadIconW 40

@interface ForumCircleCell()

//头像
@property (nonatomic, strong) UIImageView *photoIV;
//昵称
@property (nonatomic, strong) UILabel *nameLbl;
//时间
@property (nonatomic, strong) UILabel *timeLbl;
//评论
@property (nonatomic, strong) LinkLabel *contentLbl;
//点赞数
@property (nonatomic, strong) UILabel *zanNumLbl;
//回复
@property (nonatomic, strong) NSMutableArray <ReplyCommentView *>*replyArr;
//
@property (nonatomic, strong) ReplyCommentView *lastView;
//
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation ForumCircleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.replyArr = [NSMutableArray array];
        
        [self initSubviews];
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.isFirst = YES;
    //头像
    self.photoIV = [[UIImageView alloc] init];
    self.photoIV.layer.cornerRadius = kHeadIconW/2.0;
    self.photoIV.layer.masksToBounds = YES;
    self.photoIV.backgroundColor = kClearColor;
    self.photoIV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.photoIV];
    
    //昵称
    self.nameLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:kWhiteColor
                                      font:Font(14)
                                 textColor:kTextColor];
    [self addSubview:self.nameLbl];
    //时间
    self.timeLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:kClearColor
                                      font:Font(12)
                                 textColor:kTextColor2];
    [self addSubview:self.timeLbl];
    //点赞按钮
    self.zanBtn = [UIButton buttonWithImageName:@"未点赞"
                   ];
    
    self.zanBtn.contentMode = UIViewContentModeScaleAspectFit;
    [self.zanBtn setEnlargeEdge:10];
    
    [self addSubview:self.zanBtn];
    //点赞数
    self.zanNumLbl = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor
                                                  font:11.0];
    
    [self addSubview:self.zanNumLbl];
    //评论
    self.contentLbl = [[LinkLabel alloc] initWithFrame:CGRectZero];
    self.contentLbl.font = Font(15.0);
    self.contentLbl.textColor = [UIColor textColor];
    self.contentLbl.numberOfLines = 0;
    [self addSubview:self.contentLbl];
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}

- (void)setSubviewLayout {
    
    CGFloat leftMargin = 15;
    //头像
    [self.photoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@(leftMargin));
        make.width.height.equalTo(@(kHeadIconW));
    }];
    //昵称
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.photoIV.mas_top).offset(6);
        make.left.equalTo(self.photoIV.mas_right).offset(leftMargin);
    }];
    //时间
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameLbl.mas_bottom).offset(6);
        make.left.equalTo(self.nameLbl.mas_left);
    }];
    //点赞按钮
    [self.zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.centerY.equalTo(self.photoIV.mas_centerY);
        make.width.height.equalTo(@30);
    }];
    //点赞数
    [self.zanNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.zanBtn.mas_left);
        make.centerY.equalTo(self.zanBtn.mas_centerY).offset(3);
    }];
    //评论
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.height.lessThanOrEqualTo(@(MAXFLOAT));
        make.width.equalTo(@(kScreenWidth - 3*15 - kHeadIconW));
        make.top.equalTo(self.timeLbl.mas_bottom).offset(10);
    }];
    
    //移除所有回复
    [self.replyArr enumerateObjectsUsingBlock:^(ReplyCommentView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj removeFromSuperview];
    }];
    
    [self layoutSubviews];
    
    _commentModel.cellHeight = self.contentLbl.yy + 10;
    
    if (_commentModel.commentList.count == 0) {
        
        return ;
    }
    
    //刷新布局
    [self layoutIfNeeded];
    
    __block ReplyCommentView *lastView;
    
    [_commentModel.commentList enumerateObjectsUsingBlock:^(ForumCommentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat y = idx == 0 ? self.contentLbl.yy + 10: lastView.yy;
        
        ReplyCommentView *replyView = [[ReplyCommentView alloc] initWithFrame:CGRectMake(15, y, kScreenWidth - 30, 100)];
        
        replyView.forumCommentModel = obj;
        
        replyView.userInteractionEnabled = YES;
        replyView.tag = 1900 + idx;
        
        [self addSubview:replyView];
        
        [self.replyArr addObject:replyView];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickReply:)];
        
        [replyView addGestureRecognizer:tapGR];
        
        lastView = replyView;
    }];
    
    self.lastView = lastView;
    
    self.isFirst = NO;
    
    _commentModel.cellHeight = self.lastView.yy + 10;
}

#pragma mark - Events
- (void)clickReply:(UITapGestureRecognizer *)tapGR {
    
    NSInteger index = tapGR.view.tag - 1900;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReplyComment" object:@(index)];
}

#pragma mark - Setting
- (void)setCommentModel:(ForumCommentModel *)commentModel {
    
    _commentModel = commentModel;
    
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:[commentModel.photo convertImageUrl]]
                    placeholderImage:USER_PLACEHOLDER_SMALL];
    
    self.nameLbl.text = commentModel.nickname;
    self.timeLbl.text = [commentModel.publishDatetime convertToDetailDate];
    self.contentLbl.text = commentModel.content;
    self.zanNumLbl.text = [NSString stringWithFormat:@"%ld", commentModel.pointCount];
    
    NSString *zanImg = [commentModel.isPoint isEqualToString:@"1"] ? @"点赞": @"未点赞";
    [self.zanBtn setImage:kImage(zanImg) forState:UIControlStateNormal];
    
    //
    [self setSubviewLayout];
    
}

@end
