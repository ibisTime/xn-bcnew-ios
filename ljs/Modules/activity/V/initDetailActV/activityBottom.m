//
//  activityBottom.m
//  ljs
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "activityBottom.h"
@interface activityBottom ()
@property (nonatomic, strong) UILabel *users;
@property (nonatomic, strong) UIImageView *userImg;

@property (nonatomic, strong) UIButton * moreButt;

@end

@implementation activityBottom

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.backgroundColor = kWhiteColor;
        
//        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    //1
    self.users = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#3A3A3A") font:15];
    
    [self addSubview:self.users];
    [self.users mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(15);
        
    }];
    //2
    self.userImg = [[UIImageView alloc] init];
    [self addSubview:self.userImg];
    
    [self.userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-10);
        make.left.offset(15);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
        
    }];
    
    //3
    self.moreButt = [UIButton buttonWithImageName:@"更多" selectedImageName:@"更多"];
    [self addSubview:self.moreButt];
    [self.moreButt addTarget:self action:@selector(openMor) forControlEvents:UIControlEventTouchUpInside];
    [self.moreButt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userImg.mas_centerY);
        make.right.offset(-15);
        make.height.equalTo(@14);
        make.width.equalTo(@14);
        
    }];
    
    
    
    
    
    
}


#pragma mark - sourse
-(void)setDetailActModel:(DetailActModel *)detailActModel
{
    _detailActModel = detailActModel;
    self.users.text = [NSString stringWithFormat:(@"已报名申请个数(%ld)/已通过(%ld)"),detailActModel.toApproveCount,detailActModel.approveCount];
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:detailActModel.photo] placeholderImage:[UIImage imageNamed:@"用户名"]];
    
    
}


#pragma mark - event
-(void)openMor{
    
//    signUpUsersListVC * signUpUsersVC = [[signUpUsersListVC alloc] init];
//    signUpUsersVC.code = self.code;
//    [self.viewController.navigationController pushViewController:signUpUsersVC animated:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
