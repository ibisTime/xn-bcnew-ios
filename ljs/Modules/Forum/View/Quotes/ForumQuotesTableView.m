//
//  ForumQuotesTableView.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ForumQuotesTableView.h"
//V
#import "PlatformCell.h"
#import "ForumQuotesCurrencyCell.h"

@interface ForumQuotesTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ForumQuotesTableView

static NSString *platformCell = @"PlatformCell";
static NSString *currencyCell = @"ForumQuotesCurrencyCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        //平台
        [self registerClass:[PlatformCell class] forCellReuseIdentifier:platformCell];
        //具体币种
        [self registerClass:[ForumQuotesCurrencyCell class] forCellReuseIdentifier:currencyCell];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (self.type == ForumQuotesTypePlatform) {
//
//        return self.platforms.count;
//    }
    
    return self.currencys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.type == ForumQuotesTypePlatform) {

        CurrencyModel *currency = self.currencys[indexPath.row];

        PlatformCell *cell = [tableView dequeueReusableCellWithIdentifier:platformCell forIndexPath:indexPath];

        cell.currency = currency;
        cell.backgroundColor = indexPath.row%2 == 0 ? kBackgroundColor: kWhiteColor;

        return cell;
    }
    
    CurrencyModel *currency = self.currencys[indexPath.row];
    
    ForumQuotesCurrencyCell *cell = [tableView dequeueReusableCellWithIdentifier:currencyCell forIndexPath:indexPath];
    
    cell.currency = currency;
    cell.backgroundColor = indexPath.row%2 == 0 ? kBackgroundColor: kWhiteColor;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 68;
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

#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat scrollOffset = scrollView.contentOffset.y;

    if (!self.vcCanScroll) {
        //处理tableview和scrollView同时滚的问题（当vc不能滚动时，设置scrollView偏移量为0）
        scrollView.contentOffset = CGPointZero;

    }
    //滚动结束时offset会等于0，tableview会滚回到顶部，所以这里判断小于0
    if (scrollOffset < 0) {

        //偏移量小于等于零说明tableview到顶了
        self.vcCanScroll = NO;

        scrollView.contentOffset = CGPointZero;

        [[NSNotificationCenter defaultCenter] postNotificationName:@"SubVCLeaveTop" object:nil];
    }

}

//tableview和scrollView可以同时滚动,解决手势冲突问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

@end
