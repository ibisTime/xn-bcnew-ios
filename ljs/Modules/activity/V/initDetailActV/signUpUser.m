//
//  signUpUser.m
//  ljs
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "signUpUser.h"
#import "signUpUsersListVC.h"

@interface signUpUser ()
@property (nonatomic, strong) UILabel *users;
@property (nonatomic, strong) UIImageView *userImg;

@property (nonatomic, strong) UIButton * moreButt;

@end
@implementation signUpUser

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.backgroundColor = kWhiteColor;
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    //1
    self.users = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#3A3A3A") font:15];
    
//    self.userImg.clipsToBounds = YES;
   
    
    [self addSubview:self.users];
    [self.users mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(15);
        
    }];
    //2
    self.userImg = [[UIImageView alloc] init];
    [self addSubview:self.userImg];
    self.userImg.layer.masksToBounds = YES;
    
    self.userImg.layer.cornerRadius = 20;
    [self.userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-10);
        make.left.offset(15);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
        
    }];
    
//    3
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

-(void)setSignUpUsersListM:(NSArray<signUpUsersListModel *> *)signUpUsersListM
{
    int j = 15;
    _signUpUsersListM = signUpUsersListM;
    if (_signUpUsersListM.count>1) {
        for (int i = 0; i <_signUpUsersListM.count; i++) {
            if (j>0) {
                j+= 15;
            }
            UIImageView *imageView = [[UIImageView alloc] init];
            [self addSubview:imageView];
            imageView.layer.masksToBounds = YES;
            imageView.hidden = NO;

           imageView.layer.cornerRadius = 20;
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.offset(-10);
                make.left.offset(j);
                make.height.equalTo(@40);
                make.width.equalTo(@40);
                
            }];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[signUpUsersListM[i].photo convertImageUrl]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        }
        
    }else{
        signUpUsersListModel *listModel = signUpUsersListM[0];
         self.users.text = [NSString stringWithFormat:(@"已报名用户(%@)/已通过(%ld)"),_detailActModel.enrollCount,_detailActModel.approveCount];
        if (self.signUpUsersListM.count == 1) {

             [self.userImg sd_setImageWithURL:[NSURL URLWithString:[listModel.photo convertImageUrl]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        }
    }
    
}

#pragma mark - sourse
-(void)setDetailActModel:(DetailActModel *)detailActModel
{
    if (_signUpUsersListM.count > 1) {
        
        self.users.text = [NSString stringWithFormat:(@"已报名用户(%@)/已通过(%ld)"),detailActModel.enrollCount,detailActModel.approveCount];
    }else{
        _detailActModel = detailActModel;
    self.users.text = [NSString stringWithFormat:(@"已报名用户(%@)/已通过(%ld)"),detailActModel.enrollCount,detailActModel.approveCount];
   
    }

}


#pragma mark - event
-(void)openMor{
    
    signUpUsersListVC * signUpUsersVC = [[signUpUsersListVC alloc] init];
    signUpUsersVC.signUpUsersListM = self.signUpUsersListM;
    
    signUpUsersVC.code = self.code;
    [self.viewController.navigationController pushViewController:signUpUsersVC animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
