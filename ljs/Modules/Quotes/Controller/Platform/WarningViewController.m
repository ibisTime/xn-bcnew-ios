//
//  WarningViewController.m
//  ljs
//
//  Created by zhangfuyu on 2018/5/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "WarningViewController.h"
#import "WarningTirleView.h"
#import "WarningCurrencyView.h"
#import "TLAlert.h"
#import "PlatformWarningModel.h"
@interface WarningViewController ()<WarningCurrencyViewDelegate>

@property (nonatomic , strong)NSMutableArray *addWarningArry;
@end

@implementation WarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"预警";
    
    self.addWarningArry = [NSMutableArray arrayWithCapacity:0];
    
    [self getcurrentList];
    
    [self addtopInfoView];
    
    
}
- (void)getcurrentList
{
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628395";
    http.showView = self.view;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    http.parameters[@"exchangeEname"] = self.platform.exchangeCname;
    http.parameters[@"symbol"] = self.platform.symbol;
    http.parameters[@"toSymbol"] = self.platform.toSymbol;
    http.parameters[@"status"] = @"0";
    http.parameters[@"start"] = @"1";
    http.parameters[@"limit"] = @"10";
    http.parameters[@"id"] = self.platform.ID;


    
    [http postWithSuccess:^(id responseObject) {
        NSLog(@"--->%@",responseObject);
        NSArray *arry = responseObject[@"data"][@"list"];
        for (NSInteger index = 0 ; index < arry.count; index ++) {
            PlatformWarningModel *model = [PlatformWarningModel mj_objectWithKeyValues:(NSDictionary *)[arry objectAtIndex:index]];
            [self.addWarningArry addObject:model];
        }

    } failure:^(NSError *error) {
        NSLog(@"---->%@",error.localizedDescription);
    }];

}
- (void)addtopInfoView
{
    WarningTirleView *titleinfoView = [[WarningTirleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 74)];
    titleinfoView.platform = self.platform;
    [self.view addSubview:titleinfoView];
    
    WarningCurrencyView *currencyview = [[WarningCurrencyView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleinfoView.frame), kScreenWidth, 180)];
    currencyview.delegate = self;
    [self.view addSubview:currencyview];
}
#pragma mark - WarningCurrencyViewDelegate
- (void)addWarning:(NSString *)text isRmb:(BOOL)isRMB isUp:(BOOL)isup
{
    
    NSString *messagetitle = @"";
    
    BOOL isMiss = NO;
    
    if (isRMB) {
        if (isup) {
            if ([text floatValue] < [self.platform.lastCnyPrice floatValue]) {
                messagetitle = @"上涨不能低于当前人民币价格";
                isMiss = YES;
            }
        }
        else
        {
            if ([text floatValue] > [self.platform.lastCnyPrice floatValue]) {
                messagetitle = @"下跌不能高于当前人民币价格";
                isMiss = YES;
            }
        }
    }
    else
    {
        if (isup) {
            if ([text floatValue] < [self.platform.lastUsdPrice floatValue]) {
                messagetitle = @"上涨不能低于当前美元价格";
                isMiss = YES;
            }
        }
        else
        {
            if ([text floatValue] > [self.platform.lastUsdPrice floatValue]) {
                messagetitle = @"下跌不能高于当前美元价格";
                isMiss = YES;
            }
        }
    }
    
    if (isMiss) {
        [TLAlert alertWithTitle:@"警告" message:messagetitle confirmMsg:@"确定" confirmAction:^{
            
            
        }];
    }
    
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628390";
    http.showView = self.view;
    http.parameters[@"userId"] = [TLUser user].userId;

    http.parameters[@"exchangeEname"] = self.platform.exchangeCname;
    http.parameters[@"symbol"] = self.platform.symbol;
    http.parameters[@"toSymbol"] = self.platform.toSymbol;

    http.parameters[@"warnDirection"] = isup ? @"0" : @"1";
    http.parameters[@"warnCurrency"] = isRMB ? @"CNY" : @"USD";

    http.parameters[@"warnPrice"] = text;
    http.parameters[@"warnContent"] = @"赶紧卖";

    [http postWithSuccess:^(id responseObject) {
        
        NSLog(@"--->%@",responseObject);
        
    } failure:^(NSError *error) {
        
    }];
    
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
