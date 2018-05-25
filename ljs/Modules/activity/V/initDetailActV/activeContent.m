//
//  activeContent.m
//  ljs
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "activeContent.h"
#import "NSString+Extension.h"
@interface activeContent ()
@property (nonatomic, strong) UILabel *users;
@property (nonatomic, strong) UILabel *userImg;

@property (nonatomic, strong) UIButton * moreButt;

@end
@implementation activeContent

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
    
    [self addSubview:self.users];
    [self.users mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(10);
        make.width.offset(kScreenWidth-20);
        make.height.offset(23);


    }];
    //2
    self.userImg = [[UILabel alloc] init];
    [self addSubview:self.userImg];
    self.userImg.textAlignment = NSTextAlignmentLeft;
    self.userImg.numberOfLines = 0;
    [self.userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.users.mas_bottom).offset(10);
        make.right.offset(-15);

        make.left.offset(15);
        make.height.offset(kScreenHeight/2);

        
    }];
    
    //3
    //    self.moreButt = [UIButton buttonWithImageName:@"更多" selectedImageName:@"更多"];
    //    [self addSubview:self.moreButt];
    //    [self.moreButt addTarget:self action:@selector(openMor) forControlEvents:UIControlEventTouchUpInside];
    //    [self.moreButt mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(self.userImg.mas_centerY);
    //        make.right.offset(-15);
    //        make.height.equalTo(@14);
    //        make.width.equalTo(@14);
    //
    //    }];
    
    
    
    
    
    
}


#pragma mark - sourse
-(void)setDetailActModel:(DetailActModel *)detailActModel
{
    _detailActModel = detailActModel;
    self.users.text =@"活动详情";
   NSString *str = [NSString filterHTML:detailActModel.content];
    self.userImg.text = str;
    
    
}





@end
