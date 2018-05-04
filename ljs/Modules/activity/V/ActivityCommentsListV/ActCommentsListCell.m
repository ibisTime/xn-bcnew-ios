//
//  ActCommentsListCell.m
//  ljs
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ActCommentsListCell.h"
//Category
#import <UIImageView+WebCache.h>
#import "NSString+Extension.h"
#import "NSString+Date.h"
#import "UIButton+EnLargeEdge.h"
//V
#import "LinkLabel.h"
#import "ReplyCommentView.h"
#import "UserPhotoView.h"
#define kHeadIconW 40


@interface ActCommentsListCell()
//头像
@property (nonatomic, strong) UserPhotoView *photoIV;
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

@implementation ActCommentsListCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
