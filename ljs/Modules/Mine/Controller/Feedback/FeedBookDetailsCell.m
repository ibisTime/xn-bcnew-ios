//
//  FeedBookDetailsCell.m
//  Coin
//
//  Created by 郑勤宝 on 2019/5/20.
//  Copyright © 2019 chengdai. All rights reserved.
//

#import "FeedBookDetailsCell.h"

@implementation FeedBookDetailsCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        UILabel *nameLbl = [UILabel labelWithFrame:CGRectMake(15, 0, 90, 70) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:Font(14) textColor:nil];
        self.nameLbl = nameLbl;
        [self addSubview:nameLbl];
        
        UILabel *detailsLbl = [UILabel labelWithFrame:CGRectMake(nameLbl.xx , 0, SCREEN_WIDTH - nameLbl.xx - 15, 70) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:Font(14) textColor:nil];
        detailsLbl.numberOfLines = 2;
        self.detailsLbl = detailsLbl;
        [self addSubview:detailsLbl];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 69.5, SCREEN_WIDTH - 30, 0.5)];
//        [lineView theme_setBackgroundColorIdentifier:LineViewColor moduleName:ColorName];
        lineView.backgroundColor = kLineColor;
        self.lineView = lineView;
        [self addSubview:lineView];
        
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
