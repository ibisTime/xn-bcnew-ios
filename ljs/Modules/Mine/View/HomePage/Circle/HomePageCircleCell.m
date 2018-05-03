//
//  HomePageCircleCell.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "HomePageCircleCell.h"
//
#import "TLUser.h"
//Category
#import <UIImageView+WebCache.h>
#import "NSString+Extension.h"
#import "NSString+Date.h"
#import "UIButton+EnLargeEdge.h"
#import "UILabel+Extension.h"
//V
#import "LinkLabel.h"
#import "UserPhotoView.h"

#define kHeadIconW 40

@interface HomePageCircleCell()

//昵称
@property (nonatomic, strong) UILabel *nameLbl;
//回复的人
@property (nonatomic, strong) UILabel *replyNameLbl;
//时间
@property (nonatomic, strong) UILabel *timeLbl;
//评论
@property (nonatomic, strong) LinkLabel *contentLbl;
//
@property (nonatomic, strong) UIView *articleView;
//标题
@property (nonatomic, strong) UILabel *titleLbl;
//
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation HomePageCircleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.isFirst = YES;
    //昵称
    self.nameLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:kWhiteColor
                                      font:Font(14)
                                 textColor:kTextColor];
    [self addSubview:self.nameLbl];
    //回复我的
    self.replyNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kTextColor2
                                                     font:12.0];
    
    [self addSubview:self.replyNameLbl];
    //时间
    self.timeLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:kClearColor
                                      font:Font(14.0)
                                 textColor:kTextColor2];
    [self addSubview:self.timeLbl];
    //评论
    self.contentLbl = [[LinkLabel alloc] initWithFrame:CGRectZero];
    self.contentLbl.font = Font(16.0);
    self.contentLbl.textColor = [UIColor textColor];
    self.contentLbl.numberOfLines = 0;
    [self addSubview:self.contentLbl];
    //圈子
    self.articleView = [[UIView alloc] init];
    
    self.articleView.backgroundColor = kHexColor(@"#F6F6F6");
    self.articleView.userInteractionEnabled = YES;
    self.articleView.layer.cornerRadius = 4;
    self.articleView.clipsToBounds = YES;
    
    [self addSubview:self.articleView];
    //标题
    self.titleLbl = [UILabel labelWithBackgroundColor:kHexColor(@"#F6F6F6")
                                            textColor:kTextColor
                                                 font:14.0];
    self.titleLbl.numberOfLines = 2;
    
    [self.articleView addSubview:self.titleLbl];
    
}

- (void)setSubviewLayout {
    
    CGFloat leftMargin = 15;
    
    //时间
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@(leftMargin));
    }];
    //回复我的
    [self.replyNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.timeLbl.mas_top).offset(0);
        make.left.equalTo(self.timeLbl.mas_right).offset(leftMargin);
    }];
    //评论
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.timeLbl.mas_left);
        make.height.lessThanOrEqualTo(@(MAXFLOAT));
        make.right.equalTo(@(-leftMargin));
        make.top.equalTo(self.timeLbl.mas_bottom).offset(10);
    }];
    
    //
    [self.articleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.timeLbl.mas_left);
        make.right.equalTo(@(-leftMargin));
        make.top.equalTo(self.contentLbl.mas_bottom).offset(10);
    }];
    //标题
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}

#pragma mark - Setting
- (void)setCommentModel:(CircleCommentModel *)commentModel {
    
    _commentModel = commentModel;
    
    self.timeLbl.text = [commentModel.commentDatetime convertToDetailDate];
    
    NSString *replyStr = [commentModel.isMyComment isEqualToString:@"1"]? @"评论了":[NSString stringWithFormat:@"%@进行回复", commentModel.nickname];
    
    self.replyNameLbl.text = replyStr;
    self.contentLbl.text = commentModel.content;
    [self.titleLbl labelWithTextString:commentModel.post.content lineSpace:5];
    //
    [self setSubviewLayout];
    //
    [self layoutSubviews];
    
    commentModel.cellHeight = self.articleView.yy + 15;
}

@end
