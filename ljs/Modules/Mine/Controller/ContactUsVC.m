//
//  ContactUsVC.m
//  ljs
//
//  Created by shaojianfei on 2018/6/16.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ContactUsVC.h"
#import "UILabel+Extension.h"
@interface ContactUsVC ()

@end

@implementation ContactUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleStr = @"联系我们";
    UILabel *contentLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:18];
    [self.view addSubview:contentLab];
    contentLab.textAlignment = NSTextAlignmentCenter;
    contentLab.text = @"如有问题请加链接社 QQ:676573836";
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@30);
        make.left.right.equalTo(@0);
        
        
    }];
  
    // Do any additional setup after loading the view.
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
