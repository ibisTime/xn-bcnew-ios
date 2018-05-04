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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openCollectionBut) name:@"openCollectionBut" object:nil];
    //接收通知监听收藏按钮的点击
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openPhoneCallBut) name:@"openPhoneCallBut" object:nil];
}

#pragma mark - init
-(void)initDetailAct{
    UIScrollView * contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight-44)];
  
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
   self. activeCon = [[activeContent alloc] initWithFrame:CGRectMake(0, 280+10+146+10+101+10, kScreenWidth, 570)];
    self.activeCon.backgroundColor = kMineBackGroundColor;

    [contentScrollView addSubview:self.activeCon];
    
    
   self.activityBott = [[activityBottom alloc] initWithFrame:CGRectMake(0, kScreenHeight-44-64, kScreenWidth, 44)];
    self.activityBott.backgroundColor =kHexColor(@"#FBFBFB");
//    activityBott.backgroundColor =kYellowColor;
    [self.view addSubview:self.activityBott];

        contentScrollView.contentSize = CGSizeMake(kScreenWidth, 280+10+146+10+570);
    
    

    
    
    
}



- (void)requestDetailAct {
    
    
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628508";
    http.showView = self.view;
    http.parameters[@"code"] = self.code;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.detailActModel = [DetailActModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        self.detailActHead.detailActModel= self.detailActModel;
         self.detailActMap.detailActModel= self.detailActModel;
         self.signUpUseres.detailActModel= self.detailActModel;
         self.activeCon.detailActModel= self.detailActModel;
         self.activityBott.detailActModel= self.detailActModel;
        
        
        

        

        
    } failure:^(NSError *error) {
        
        
        
    }];
}


#pragma mark - event
-(void)openCollectionBut
{
    NSLog(@"openCollectionBut");
    
}


-(void)openPhoneCallBut
{  NSLog(@"openPhoneCallBut");
   UIApplication * app =  [UIApplication sharedApplication];
    //传一个电话号码
    [ app openURL:[NSURL URLWithString:@"tel://10086"]];
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
