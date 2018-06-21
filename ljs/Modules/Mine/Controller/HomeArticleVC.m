//
//  HomeArticleVC.m
//  ljs
//
//  Created by shaojianfei on 2018/6/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "HomeArticleVC.h"
//Category
#import "NSString+Extension.h"
//Extension
#import <UIImageView+WebCache.h>
//M
#import "MyCommentModel.h"
//V
#import "HomePageHeaderView.h"
#import "HomePageInfoTableView.h"
//C
#import "MyCommentDetailVC.h"
#import "InfoDetailVC.h"
#import "ArticleModel.h"
#import "ArticleCommentModel.h"
#import "TLPlaceholderView.h"
@interface HomeArticleVC ()<RefreshDelegate>
//头部
@property (nonatomic, strong) HomePageHeaderView *headerView;
//
@property (nonatomic, strong) HomePageInfoTableView *tableView;
//数据
@property (nonatomic, strong) NSArray <MyCommentModel *>*pageModels;
@property (nonatomic, strong) ArticleModel *articleModel;
@property (nonatomic, strong) ArticleCommentModel *articleCommentModel;
@property (nonatomic, strong) NSArray <ArticleCommentModel *>*infos;

@property (nonatomic, strong) TLPlaceholderView *holderView;
@end

@implementation HomeArticleVC

- (void)viewDidLoad {
    [super viewDidLoad];
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
