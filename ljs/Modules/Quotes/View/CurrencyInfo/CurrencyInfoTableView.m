//
//  CurrencyInfoTableView.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyInfoTableView.h"

//Category
#import "NSString+Check.h"
#import "NSString+Date.h"
//M
#import "CurrencyInfoCell1.h"
#import "CurrencyInfoCell2.h"

@interface CurrencyInfoTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation CurrencyInfoTableView

static NSString *idCell1 = @"CurrencyInfoCell1";
static NSString *idCell2 = @"CurrencyInfoCell2";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[CurrencyInfoCell1 class] forCellReuseIdentifier:idCell1];
        [self registerClass:[CurrencyInfoCell2 class] forCellReuseIdentifier:idCell2];

    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 6;
    } else if (section == 1) {
        
        return 1;
    } else if (section == 2) {
        
        return 4;
    }
    return 3;
}

- (NSString *)vaildString:(NSString *)string {
    
    if (string == nil || [string isKindOfClass:[NSNull class]]) {
        
        return @"-";
    }
    
    return string;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if (indexPath.section == 0) {
        
        NSArray *titleArr = @[@[@"中文", @"英文名"], @[@"类型", @"发行时间"], @[@"流通量", @"总发行量"], @[@"流通市值", @"总市值"], @[@"上架交易所", @"前十交易所"], @[@"钱包类型", @""]];
        //中文
        NSString *cname = [self vaildString:self.platform.coin.cname];
        //英文
        NSString *ename = [self vaildString:self.platform.coin.ename];
        //类型
        NSString *type = [self vaildString:self.platform.coin.type] ;
        //发行时间
        NSString *publishTime = [self vaildString:[self.platform.coin.publishDatetime convertDate]];
        //流通量
        NSString *totalSupply = [self vaildString:[self.platform getNumWithVolume:@([self.platform.coin.totalSupply doubleValue])]];
        //总发行量
        NSString *maxSupply = [self vaildString:[self.platform getNumWithVolume:@([self.platform.coin.maxSupply doubleValue])]];
        //流通市值
        NSString *totalSupplyMarket = [self vaildString:[self.platform getNumWithVolume:@([self.platform.coin.totalSupplyMarket doubleValue])]];
        //总市值
        NSString *maxSupplyMarket = [self vaildString:[self.platform getNumWithVolume:@([self.platform.coin.maxSupplyMarket doubleValue])]];
        //上架交易所
        NSString *putExchange = [self vaildString:self.platform.coin.putExchange];
        //前十交易所
        NSString *topExchange = [self vaildString:self.platform.coin.topExchange];
        //钱包类型
        NSString *walletType = [self vaildString:self.platform.coin.walletType];
        
        NSArray *contentArr = @[@[cname, ename], @[type, publishTime], @[totalSupply, maxSupply], @[totalSupplyMarket, maxSupplyMarket], @[putExchange, topExchange], @[walletType, @""]];
        
        CurrencyInfoCell1 *cell = [tableView dequeueReusableCellWithIdentifier:idCell1 forIndexPath:indexPath];
        
        cell.titleArr = titleArr[indexPath.row];
        cell.contentArr = contentArr[indexPath.row];
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        CurrencyInfoCell2 *cell = [tableView dequeueReusableCellWithIdentifier:idCell2 forIndexPath:indexPath];
        
        cell.titleLbl.text = @"官网";
        cell.contentLbl.text = self.platform.coin.webUrl;
        
        return cell;
    } else if (indexPath.section == 2) {
        
        NSArray *titleArr = @[@"ico时间", @"ico成本", @"募集资金", @"代币分配"];
        
        //ico时间
        NSString *icoTime = [self vaildString:[self.platform.coin.icoDatetime convertDate]];
        //ico成本
        NSString *icoCost = [self vaildString:self.platform.coin.icoCost];
        //募集资金
        NSString *raiseAmount = [self vaildString:self.platform.coin.raiseAmount];
        //代币分配
        NSString *tokenDist = [self vaildString:self.platform.coin.tokenDist];
        
        NSArray *contentArr = @[icoTime, icoCost, raiseAmount, tokenDist];

        CurrencyInfoCell2 *cell = [tableView dequeueReusableCellWithIdentifier:idCell2 forIndexPath:indexPath];
        
        cell.titleLbl.text = titleArr[indexPath.row];
        cell.contentLbl.text = contentArr[indexPath.row];
        
        return cell;
        
    } else if (indexPath.section == 3) {
        
        NSArray *titleArr = @[@[@"最新提交", @"总提交"], @[@"总贡献", @"粉丝数"], @[@"关注度", @"复制数"]];
        //最新提交
        NSString *lastCommitCount = [self vaildString:self.platform.coin.lastCommitCount];
        //总提交
        NSString *totalCommitCount = [self vaildString:self.platform.coin.totalCommitCount];
        //总贡献
        NSString *totalDist = [self vaildString:self.platform.coin.totalDist];
        //粉丝数
        NSString *fansCount = [self vaildString:self.platform.coin.fansCount];
        //关注度
        NSString *keepCount = [self vaildString:self.platform.coin.keepCount];
        //复制数
        NSString *copyCount = [self vaildString:self.platform.coin.cpCount];
        
        NSArray *contentArr = @[@[lastCommitCount, totalCommitCount], @[totalDist, fansCount], @[keepCount, copyCount]];
        CurrencyInfoCell1 *cell = [tableView dequeueReusableCellWithIdentifier:idCell1 forIndexPath:indexPath];
        
        cell.titleArr = titleArr[indexPath.row];
        cell.contentArr = contentArr[indexPath.row];
        
        return cell;
    }
    
    CurrencyInfoCell1 *cell = [tableView dequeueReusableCellWithIdentifier:idCell1 forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 0.1;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return [UIView new];
    }
    
    NSArray *titleArr = @[@"链接", @"公募信息", @"项目简介"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headerView.backgroundColor = kHexColor(@"#f5f5f9");
    
    [self addSubview:headerView];
    //简介
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor3
                                                    font:12.0];
    textLbl.text = titleArr[section-1];
    
    [headerView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(@0);
        make.left.equalTo(@15);
    }];
    
    return headerView;
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
