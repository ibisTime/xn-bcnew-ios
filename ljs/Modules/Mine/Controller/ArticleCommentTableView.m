//
//  ArticleCommentTableView.m
//  ljs
//
//  Created by shaojianfei on 2018/5/19.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//
#import "InformationListCell.h"
#import "InformationListCell2.h"
#import "ArticleCommentTableView.h"
#import "ArticleCommentCell.h"
@interface ArticleCommentTableView()<UITableViewDelegate,UITableViewDataSource>


@end
@implementation ArticleCommentTableView
static NSString *informationListCell = @"ArticleCommentCell";
static NSString *informationListCell2 = @"InformationListCell2";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        self.infos = [NSMutableArray array];
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[ArticleCommentCell class] forCellReuseIdentifier:informationListCell];
        [self registerClass:[InformationListCell2 class] forCellReuseIdentifier:informationListCell2];
        
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.infos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ArticleCommentModel *info = self.infos[indexPath.row];
    
    
        ArticleCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:informationListCell forIndexPath:indexPath];
        //shuju
        cell.infoModel = info;
        
        return cell;
    
    

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ArticleCommentModel *info = self.infos[indexPath.row];
    
    
        return 130;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}


@end
