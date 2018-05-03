//
//  signUpUsersListCell.m
//  ljs
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "signUpUsersListCell.h"


@interface signUpUsersListCell()
@property (nonatomic, strong) UIImageView *userImg;
@property (nonatomic, strong) UILabel *userText;
@end
@implementation signUpUsersListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //活动图片
    self.userImg = [[UIImageView alloc] init];
    [self addSubview:self.userImg];
    //
    [self.userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(15);
        make.left.offset(15);
        
        make.height.equalTo(@40);
        make.width.equalTo(@40);

      
    }];
    
    
    
    self.userText = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#818181") font:15.0];
    self.userText.text = @"已通过";
    
    [self addSubview:self.userText];

    //
    [self.userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(15);
        make.right.offset(-15);
        
        
        
          }];
}

-(void)setApprovedList:(signUpUsersListModel *)approvedList{
    _approvedList = approvedList;
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:approvedList.photo] placeholderImage:[UIImage imageNamed:@"用户名"]];
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
