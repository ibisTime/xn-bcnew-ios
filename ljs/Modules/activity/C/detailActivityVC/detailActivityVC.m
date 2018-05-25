//
//  detailActivityVC.m
//  ljs
//
//  Created by apple on 2018/5/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//
#import "AppColorMacro.h"

#import "detailActivityVC.h"
//v
#import "initDetailActMap.h"
#import "initDetailActHead.h"
#import "signUpUser.h"
#import "activeContent.h"
#import "activityBottom.h"
//m
#import "DetailActModel.h"

@interface detailActivityVC ()
@property (nonatomic, strong) DetailActModel *detailActModel;
//v
@property (nonatomic, strong) initDetailActHead *detailActHead;
@property (nonatomic, strong) initDetailActMap *detailActMap;
@property (nonatomic, strong) signUpUser *signUpUseres;
@property (nonatomic, strong) activeContent *activeCon;
@property (nonatomic, strong) activityBottom *activityBott;

@property (nonatomic, copy) NSString  *isCollent;

@end

@implementation detailActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动详情";
    self.view.backgroundColor =kHexColor(@"#FAFCFF");
 
    [self initDetailAct];
    
    [self requestDetailAct];
    
  //
    [self addNSNotification];
    
}
-(void)addNSNotification
{
    //接收通知监听收藏按钮的点击
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openCollectionBut) name:@"openCollectionBut" object:nil];
    //接收通知监听收藏按钮的点击
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openPhoneCallBut) name:@"openPhoneCallBut" object:nil];
}

#pragma mark - init
-(void)initDetailAct{
    UIScrollView * contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight-44)];
    contentScrollView.tag = 100086;
  
    [self.view addSubview:contentScrollView];
    
    //头部
    self. detailActHead = [[initDetailActHead alloc ]initWithFrame:CGRectMake(0, 0, kScreenWidth, 280)];
   self. detailActHead.backgroundColor = kMineBackGroundColor;
    [contentScrollView  addSubview:self.detailActHead];
   //2
    
   self. detailActMap = [[initDetailActMap alloc] initWithFrame:CGRectMake(0, 280+10, kScreenWidth, 146)];
    self.detailActMap.backgroundColor = kMineBackGroundColor;
    [contentScrollView addSubview:self.detailActMap];

    //3
    self.signUpUseres = [[signUpUser alloc] initWithFrame:CGRectMake(0, 280+10+146+10, kScreenWidth, 101)];
    self.signUpUseres.code = self.code;
    self.signUpUseres.backgroundColor = kMineBackGroundColor;
    [contentScrollView addSubview:self.signUpUseres];
    
    //4
   self.activeCon = [[activeContent alloc] initWithFrame:CGRectMake(0, 280+10+146+10+101+10, kScreenWidth, 570)];
    self.activeCon.backgroundColor = kMineBackGroundColor;

    [contentScrollView addSubview:self.activeCon];
    
    
   self.activityBott = [[activityBottom alloc] initWithFrame:CGRectMake(0, kScreenHeight-44-64, kScreenWidth, 44)];
    self.activityBott.backgroundColor =kHexColor(@"#FBFBFB");
//    activityBott.backgroundColor =kYellowColor;
    [self.view addSubview:self.activityBott];
    BaseWeakSelf;
    self.activityBott.collectionButBlock = ^(NSInteger index) {
        //点击收藏
        NSLog(@"点击收藏");
        weakSelf.detailActModel.isCollect = weakSelf.isCollent;
//        [self collectionInfo:index];
        UIButton * btn = [weakSelf.activityBott viewWithTag:7352];
        [weakSelf openCollectionBut:btn];
    };
        contentScrollView.contentSize = CGSizeMake(kScreenWidth, 280+10+146+10+570);
    
    

    
    
    
}



- (void)requestDetailAct {
    
    
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628508";
    http.showView = self.view;
    http.parameters[@"code"] = self.code;
    http.parameters[@"userId"] = [TLUser user].userId;

    [http postWithSuccess:^(id responseObject) {
        
        self.detailActModel = [DetailActModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        self.detailActHead.detailActModel= self.detailActModel;
         self.detailActMap.detailActModel= self.detailActModel;
         self.signUpUseres.detailActModel= self.detailActModel;
         self.activeCon.detailActModel= self.detailActModel;
        
        CGSize size = CGSizeMake(kScreenWidth - 30, MAXFLOAT);//设置高度宽度的最大限度
        
        CGRect rect = [[NSString filterHTML:self.detailActModel.content] boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
        
        self.activeCon.height =rect.size.height +50;
        UIScrollView *contentScrollView = (UIScrollView *)[self.view viewWithTag:100086];
        contentScrollView.contentSize = CGSizeMake(kScreenWidth, 280+10+146+10+rect.size.height + 160);

        
         self.activityBott.detailActModel= self.detailActModel;
        self.isCollent = self.detailActModel.isCollect;
        
        

        

        
    } failure:^(NSError *error) {
        
        
        
    }];
}


#pragma mark - event
//收藏活动

///**
// 收藏资讯
// */
- (void)collectionInfo:(UIButton *)sender {

    BaseWeakSelf;

    [self checkLogin:^{
        //刷新收藏状态
        TLNetworking *http = [TLNetworking new];

        http.code = @"628512";
        weakSelf;
        http.parameters[@"code"] = self.detailActModel.code;
        http.parameters[@"userId"] = [TLUser user].userId;

        [http postWithSuccess:^(id responseObject) {

          

        } failure:^(NSError *error) {

        }];
    } event:^{

    }];
}

-(void)openCollectionBut: (UIButton *)btn
{
    [self checkLogin:^{
        
    }];
    if (![TLUser user].userId) {
        return;
    }
     BaseWeakSelf;
    NSLog(@"openCollectionBut");
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"628512";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"code"] = self.detailActModel.code;
    
    [http postWithSuccess:^(id responseObject) {
        UIImage *image =[UIImage imageNamed: @"收藏"];
        UIImage *imageNo =[UIImage imageNamed: @"未收藏"];

        if ([weakSelf.detailActModel.isCollect isEqualToString:@"0"]) {
            [TLAlert alertWithSucces:@"收藏成功"];
            [btn setImage:image forState:UIControlStateNormal];
            weakSelf.isCollent = @"1";

        }else{
            [TLAlert alertWithSucces:@"取消收藏成功"];
            [btn setImage:imageNo forState:UIControlStateNormal];
            weakSelf.isCollent = @"0";

        }
//        weakSelf.detailActModel
        
        [[TLUser user] updateUserInfo];
        
    } failure:^(NSError *error) {
        [TLAlert alertWithError:error.description];
        
    }];
}

//打电话
-(void)openPhoneCallBut
{  NSLog(@"openPhoneCallBut");
   UIApplication * app =  [UIApplication sharedApplication];
    //传一个电话号码
    if (self.detailActModel.contactMobile.length > 0) {
        NSString *str = [NSString stringWithFormat:@"telprompt:%@",self.detailActModel.contactMobile];
        [app openURL:[NSURL URLWithString:str]];
    }

}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
