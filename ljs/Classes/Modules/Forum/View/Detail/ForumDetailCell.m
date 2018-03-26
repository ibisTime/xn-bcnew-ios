//
//  ForumDetailCell.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ForumDetailCell.h"

@interface ForumDetailCell()

@end

@implementation ForumDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //text
    self.textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor
                                                font:16.0];
    [self addSubview:self.textLbl];
    //content
    self.contentLbl = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kTextColor
                                                   font:16.0];
    self.contentLbl.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:self.contentLbl];
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    CGFloat leftMargin = 15;
    //text
    [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(leftMargin));
        make.centerY.equalTo(@0);
    }];
    //content
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-leftMargin));
        make.centerY.equalTo(@0);
    }];
    
}

@end
