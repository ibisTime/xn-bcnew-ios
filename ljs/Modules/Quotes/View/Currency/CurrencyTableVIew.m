//
//  CurrencyTableVIew.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyTableVIew.h"

//V
#import "CurrencyPriceCell.h"
#import "NewCurrencyCell.h"
#import "CurrencyCell.h"

@interface CurrencyTableVIew()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation CurrencyTableVIew

static NSString *currencyPriceCell = @"CurrencyPriceCell";
static NSString *newCurrencyCell = @"NewCurrencyCell";
static NSString *currencyCell = @"CurrencyCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        //币价
        [self registerClass:[CurrencyPriceCell class] forCellReuseIdentifier:currencyPriceCell];
        //新币
        [self registerClass:[NewCurrencyCell class] forCellReuseIdentifier:newCurrencyCell];
        //具体币种
        [self registerClass:[CurrencyCell class] forCellReuseIdentifier:currencyCell];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.type == CurrencyTypePrice) {
        
        return self.currencyPrices.count;
    }
    
    return self.currencyPrices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (self.type == CurrencyTypePrice) {
//
//        CurrencyPriceModel *currency = self.currencyPrices[indexPath.row];
//
//        CurrencyPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:currencyPriceCell forIndexPath:indexPath];
//
//        cell.currency = currency;
//        cell.backgroundColor = indexPath.row%2 == 0 ? kBackgroundColor: kWhiteColor;
//
//        return cell;
//
//    } else if (self.type == CurrencyTypeNewCurrency) {
//
//        CurrencyModel *currency = self.currencys[indexPath.row];
//
//        NewCurrencyCell *cell = [tableView dequeueReusableCellWithIdentifier:newCurrencyCell forIndexPath:indexPath];
//
//        cell.currency = currency;
//        cell.backgroundColor = indexPath.row%2 == 0 ? kBackgroundColor: kWhiteColor;
//
//        return cell;
//    }
    
    CurrencyPriceModel *currency = self.currencyPrices[indexPath.row];

    CurrencyCell *cell = [tableView dequeueReusableCellWithIdentifier:currencyCell forIndexPath:indexPath];
    
    cell.currency = currency;
    cell.backgroundColor = indexPath.row%2 == 0 ? kBackgroundColor: kWhiteColor;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CurrencyPriceModel *currency = self.currencyPrices[indexPath.row];
    self.selectBlock(currency.ID);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (self.type == CurrencyTypePrice) {
//
//        return 76;
//    }
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

@end
