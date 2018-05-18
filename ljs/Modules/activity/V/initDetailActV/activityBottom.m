//
//  activityBottom.m
//  ljs
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "activityBottom.h"
//VC
#import "FillInRegistrationFormVC.h"
#import "ActivityCommentsVC.h"
@interface activityBottom ()
//
@property (nonatomic, strong) UILabel *signUpButTitle;
@property (nonatomic, strong) NSString *signUpButTitleColor;
@property (nonatomic, strong) NSString *signUpButTitleBackgColor;

@property (nonatomic, strong) UIButton *signUpBut;
@property (nonatomic, strong) UIButton *commentsBut;

@property (nonatomic, strong) UIButton *phoneCallBut;


@property (nonatomic, assign) int SignState;// 1已报名待通过 2 未报名 3 已通过

@property (nonatomic, strong) UIButton * collectionBut;

@end

@implementation activityBottom

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
//    self.signUpBut = [UIButton buttonWithTitle:self.signUpButTitle.text titleColor:[UIColor colorNamed:self.signUpButTitleColor] backgroundColor:[UIColor colorNamed:self.signUpButTitleBackgColor] titleFont:17];
     self.signUpBut = [UIButton buttonWithTitle:@"立即报名" titleColor:kWhiteColor  backgroundColor:kpigColor titleFont:17];
    [self addSubview:self.signUpBut];
    [self.signUpBut addTarget:self action:@selector(openSignUp) forControlEvents:UIControlEventTouchUpInside];
    [self.signUpBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
          make.top.offset(0);
        make.bottom.offset(0);

        
        make.width.equalTo(@180);
        
    }];
    
    //2
    self.commentsBut = [UIButton buttonWithImageName:@"留言2"];
    [self addSubview:self.commentsBut];
    [self.commentsBut addTarget:self action:@selector(openComment) forControlEvents:UIControlEventTouchUpInside];
    [self.commentsBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.signUpBut.mas_right).offset(32);
        make.top.offset(10);
        
        
        make.height.equalTo(@24);

        make.width.equalTo(@24);
        
    }];
    
    //3
    self.phoneCallBut = [UIButton buttonWithImageName:@"活动详情电话"];
    [self addSubview:self.phoneCallBut];
    [self.phoneCallBut addTarget:self action:@selector(openPhoneCallBut) forControlEvents:UIControlEventTouchUpInside];
    [self.phoneCallBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentsBut.mas_right).offset(36);
        make.top.offset(10);
        
        
        make.height.equalTo(@24);
        
        make.width.equalTo(@24);
        
    }];
    
    //4
    self.collectionBut = [UIButton buttonWithImageName:@"未收藏" selectedImageName:@"收藏"];
    [self addSubview:self.collectionBut];
    [self.collectionBut addTarget:self action:@selector(openCollectionBut) forControlEvents:UIControlEventTouchUpInside];
    [self.collectionBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneCallBut.mas_right).offset(32);
        make.top.offset(10);
        
        
        make.height.equalTo(@24);
        
        make.width.equalTo(@24);
        
    }];
    
    
    
    
}


#pragma mark - sourse
-(void)setDetailActModel:(DetailActModel *)detailActModel
{
    _detailActModel = detailActModel;
    self.content = detailActModel.content;
    self.code = detailActModel.code;
    
    if ([detailActModel.isEnroll isEqualToString:@"1"]) {
        //申请报名中
        [self.signUpBut setTitle:@"报名申请中" forState:UIControlStateDisabled];
        [self.signUpBut setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
        self.signUpBut.enabled = NO;
    }
    else if ([detailActModel.isEnroll isEqualToString:@"2"])
    {
        //报名成功
        self.signUpBut.enabled = NO;
        [self.signUpBut setTitle:@"已通过请注意查看短信" forState:UIControlStateDisabled];
        [self.signUpBut setBackgroundColor:kpigColor forState:UIControlStateDisabled];
        }
    else
    {
        //未报名
        [self.signUpBut setTitle:@"立即报名" forState:UIControlStateDisabled];
        [self.signUpBut setBackgroundColor:kpigColor forState:UIControlStateDisabled];
        self.signUpBut.enabled = YES;
    }
    //    self.users.text = [NSString stringWithFormat:(@"已报名申请个数(%ld)/已通过(%ld)"),detailActModel.toApproveCount,detailActModel.approveCount];
//    [self.userImg sd_setImageWithURL:[NSURL URLWithString:detailActModel.photo] placeholderImage:[UIImage imageNamed:@"用户名"]];
    
   
    
    

}


#pragma mark - event
-(void)openSignUp{
    NSLog(@"openSignUp");
    FillInRegistrationFormVC * fillInRegistrationFormVC = [[FillInRegistrationFormVC alloc] init];
    fillInRegistrationFormVC.code = self.code;
    NSLog(@"%@",self.code);
    MJWeakSelf;
    
    fillInRegistrationFormVC.signUpSucessClock = ^(BOOL index) {
        if (index ==1) {
            weakSelf.signUpBut.enabled = NO;
        };
    };
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signSucessUp) name:@"SignSucess" object:nil];
    [self.viewController.navigationController pushViewController:fillInRegistrationFormVC animated:YES];
}
-(void)openComment{
     NSLog(@"openComment");
    ActivityCommentsVC *commentListVC = [ActivityCommentsVC new];
    
    commentListVC.objectCode = self.code;
    commentListVC.content = self.content;
    [self.viewController.navigationController pushViewController:commentListVC animated:YES];
}
-(void)openPhoneCallBut{
   
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"openPhoneCallBut" object:nil];
 
}
-(void)openCollectionBut : (UIButton*)btn {
    
  
    [[NSNotificationCenter defaultCenter]postNotificationName:@"openCollectionBut" object:btn];

    
  
}

-(void)signSucessUp
{
    self.SignState = 1;
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"SignState"];
    
    [self.signUpBut setTitle:@"报名申请中" forState:UIControlStateDisabled];
    [self.signUpBut setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
    self.signUpBut.enabled = NO;

    
    
}
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
