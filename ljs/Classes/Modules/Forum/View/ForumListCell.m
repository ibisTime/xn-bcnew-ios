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
    
    
}

#pragma mark - Setting
- (void)setForumModel:(ForumModel *)forumModel {
    
    _forumModel = forumModel;
    
}

@end
