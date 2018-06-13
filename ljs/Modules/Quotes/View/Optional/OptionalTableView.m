//
//  OptionalTableView.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "OptionalTableView.h"
//V
#import "OptionalCell.h"
#import "TLAlert.h"
#import "TLNetworking.h"

@interface OptionalTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation OptionalTableView

static NSString *identifierCell = @"OptionalCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[OptionalCell class] forCellReuseIdentifier:identifierCell];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.optionals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OptionalCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.backgroundColor = indexPath.row%2 == 0 ? kBackgroundColor: kWhiteColor;
    
    cell.optional = self.optionals[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OptionalListModel *model = self.optionals[indexPath.row];
    self.selectBlock(model.ID);
    
    
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

#pragma mark - 编辑模式

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *actionArr = @[].mutableCopy;
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self deleteCurrencyWithIndex:indexPath.row];
    }];
    
    deleteAction.backgroundColor = kHexColor(@"#FF4545");
    
    [actionArr addObject:deleteAction];

    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self topCurrencyWithIndex:indexPath.row];
    }];
    
    editAction.backgroundColor = kHexColor(@"#C3C3C3");
    
    [actionArr addObject:editAction];

    return actionArr;
}

/**
 删除自选币种
 */
- (void)deleteCurrencyWithIndex:(NSInteger)index {
    
    OptionalListModel *optional = self.optionals[index];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628332";
    http.showView = self;
    http.parameters[@"id"] = optional.choiceId;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        //删除数据源中的数据
        [self.optionals removeObjectAtIndex:index];
        
        [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [TLAlert alertWithSucces:@"删除成功"];
        //当自选数为0时，刷新界面
        if (self.optionals.count == 0) {
            
            if (self.refreshBlock) {
                
                self.refreshBlock();
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self reloadData];
        });
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 置顶
 */
- (void)topCurrencyWithIndex:(NSInteger)index {
    
    OptionalListModel *optional = self.optionals[index];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628331";
    http.showView = self;
    http.parameters[@"id"] = optional.ID;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        NSIndexPath *resultIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        //置顶数据源中的数据
        [self.optionals removeObjectAtIndex:index];
        [self.optionals insertObject:optional atIndex:0];
        
        [self moveRowAtIndexPath:indexPath toIndexPath:resultIndexPath];
        
        [TLAlert alertWithSucces:@"置顶成功"];
        
        [self reloadRowsAtIndexPaths:@[resultIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self reloadData];
        });
        
    } failure:^(NSError *error) {
        
    }];
}

@end
