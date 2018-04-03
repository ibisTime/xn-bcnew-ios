//
//  MyCommentDetailTableView.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MyCommentDetailTableView.h"
//V
#import "MyCommentDetailCell.h"

@interface MyCommentDetailTableView()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation MyCommentDetailTableView

static NSString *infoCommentCellID = @"MyCommentDetailCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[MyCommentDetailCell class] forCellReuseIdentifier:infoCommentCellID];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.commentModel.commentList.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseWeakSelf;

    MyCommentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:infoCommentCellID forIndexPath:indexPath];
    
    InfoCommentModel *commentModel = indexPath.row == 0 ? self.commentModel: self.commentModel.commentList[indexPath.row - 1];
    
    cell.isReply = indexPath.row == 0 ? NO: YES;
    
    cell.backgroundColor = indexPath.row != 0 ? kBackgroundColor: kWhiteColor;
    cell.commentModel = commentModel;
    cell.zanBtn.tag = 1300 + indexPath.row + 1000*indexPath.section;
    
    [cell.zanBtn addTarget:self action:@selector(clickZan:) forControlEvents:UIControlEventTouchUpInside];
    
    __block NSIndexPath *idxPath = indexPath;
    
    cell.myReplyBlock = ^(NSInteger index) {
        
        if (weakSelf.refreshDelegate && [weakSelf.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
            
            [weakSelf.refreshDelegate refreshTableView:weakSelf didSelectRowAtIndexPath:idxPath];
        }
    };
    
    return cell;
}

- (void)clickZan:(UIButton *)sender {
    
    NSInteger index = sender.tag - 1300;
    
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
    
    return self.commentModel.cellHeight;
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
