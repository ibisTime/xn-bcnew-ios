//
//  activityBottom.m
//  ljs
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "activityBottom.h"
//VC
#import "NSString+Extension.h"
#import "NSString+Date.h"
#import "TLUserLoginVC.h"

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
@property (nonatomic, strong) UILabel *comentCountLab;


@property (nonatomic, assign) int SignState;// 1已报名待通过 2 未报名 3 已通过


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
    self.commentsBut = [UIButton buttonWithImageName:@"留言"];
    [self addSubview:self.commentsBut];
    [self.commentsBut setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.commentsBut addTarget:self action:@selector(openComment) forControlEvents:UIControlEventTouchUpInside];
    [self.commentsBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.signUpBut.mas_right).offset(32);
        make.top.offset(10);
        
        
        make.height.equalTo(@24);

        make.width.equalTo(@24);
        
    }];
    self.comentCountLab = [[UILabel alloc] init];
    [self addSubview:self.comentCountLab];
    self.comentCountLab.font = [UIFont systemFontOfSize:11];
    self.comentCountLab.textColor = kHexColor(@"#FF4747");
   
    [self.comentCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentsBut.mas_right).offset(-5);
        make.top.offset(5);
        
        
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
    self.collectionBut.tag = 7352;
    [self.collectionBut addTarget:self action:@selector(openCollection:) forControlEvents:UIControlEventTouchUpInside];
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
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    //当前时间格式
    formatter.dateFormat = @"yyyy/MM/dd/HH:mm";
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    NSString *str = [detailActModel.startDatetime convertDate];
    NSString *strEnd = [detailActModel.endDatetime convertDate];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd/HH:mm"];
    NSDate *date1 = [dateFormatter dateFromString:str];
    NSDate *dateEnd = [dateFormatter dateFromString:strEnd];

    NSComparisonResult result = [date compare:date1];
    NSComparisonResult result1 = [date compare:dateEnd];

    NSLog(@"date1 : %@, date2 : %@", date, date1);
    if (result == NSOrderedDescending  ) {
        if (result1 == NSOrderedDescending) {
            [self.signUpBut setTitle:@"活动已结束" forState:UIControlStateDisabled];
            [self.signUpBut setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
            self.signUpBut.enabled = NO;
        }else{
        NSLog(@"活动时间小于当前时间");
        [self.signUpBut setTitle:@"活动已开始" forState:UIControlStateDisabled];
        [self.signUpBut setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
        self.signUpBut.enabled = NO;
        }
    }
    else if (result == NSOrderedAscending){
        //当前时间小于返回时间
        NSLog(@"活动时间大于当前时间");
        
    }else{
        
        NSLog(@"当前时间等于活动时间");
        
    }
    self.comentCountLab.text = detailActModel.commentCount;
    if ([detailActModel.isCollect isEqualToString:@"1"]) {
        self.collectionBut.selected = YES;
    }else{
        self.collectionBut.selected = NO;

    }
   
    
    

}


#pragma mark - event
-(void)openSignUp{
    [self.detailVc checkLogin:^{
        
    }];
    if ([TLUser user].isLogin == NO) {
        return;
    }
//    if (self.TakeButBlock) {
//        self.TakeButBlock(1);
//    }
    NSLog(@"openSignUp");
    FillInRegistrationFormVC * fillInRegistrationFormVC = [FillInRegistrationFormVC new];
    fillInRegistrationFormVC.code = self.code;
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
    [self.detailVc checkLogin:^{
        
    }];
    if ([TLUser user].isLogin == NO) {
        return;
    }
     NSLog(@"openComment");
    ActivityCommentsVC *commentListVC = [ActivityCommentsVC new];
    
    commentListVC.objectCode = self.code;
    commentListVC.content = self.content;
    [self.viewController.navigationController pushViewController:commentListVC animated:YES];
}
-(void)openPhoneCallBut{
   
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"openPhoneCallBut" object:nil];
 
}
-(void)openCollection: (UIButton*)btn {
//
    [self.detailVc checkLogin:^{
        
    }];
    if ([TLUser user].isLogin == NO) {
    
        return;
    }

//
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"openCollectionBut" object:btn];
    self.collectionBut.selected = !btn.selected;

    self.collectionButBlock(btn.tag);
  
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
