//
//  ForumListTableView.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ForumListTableView.h"
//V
#import "ForumListCell.h"

@interface ForumListTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ForumListTableView

static NSString *identifierCell = @"ForumListCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[ForumListCell class] forCellReuseIdentifier:identifierCell];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.forums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ForumModel *forumModel = self.forums[indexPath.row];
    
    forumModel.rank = [NSString stringWithFormat:@"%ld", indexPath.row+1];
    ForumListCell *cell = [tableView  dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.backgroundColor = indexPath.row%2 == 0 ? kBackgroundColor: kWhiteColor;

    cell.postType = self.postType;
    cell.forumModel = forumModel;
    cell.followBtn.tag = 2300 + indexPath.row;
    
    [cell.followBtn addTarget:self action:@selector(clickForum:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)clickForum:(UIButton *)sender {
    
    NSInteger index = sender.tag - 2300;
    
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:button:selectRowAtIndex:)]) {
        
        [self.refreshDelegate refreshTableViewButtonClick:self button:sender selectRowAtIndex:index];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 86;
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
