//
//  ActivityListV.m
//  ljs
//
//  Created by apple on 2018/5/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ActivityListV.h"
#import "ActivityListCell.h"
#import "detailActivityVC.h"

//Category 响应者链
#import "UIView+Responder.h"

@interface ActivityListV () <UITableViewDataSource,UITableViewDelegate>

//v
@property (nonatomic, strong) ActivityListCell *cell;
@property (nonatomic, strong) detailActivityVC* detOfActVC;
@end

@implementation ActivityListV

static NSString *identifierCell = @"activityListCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = kClearColor;

        [self registerClass:[ActivityListCell class] forCellReuseIdentifier:identifierCell];
        
        
        //适配
        if (@available(iOS 11.0, *)) {
            
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.activities.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     self.cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    
    activityModel *new = self.activities[indexPath.section];
    self.activitiesTemp = [NSMutableArray array];
    //    new.isShowDate = [self isShowDateWithIndexPath:indexPath];
    
    self.cell.actModel = new;
   
    return self.cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    detailActivityVC* detOfActVC = [[detailActivityVC alloc ] init ];
    self.detOfActVC = detOfActVC;
//    detOfActVC.code = self.cell.actModel.code;

//    if (0 == indexPath.section) {
        activityModel *model = self.activities[indexPath.section];
        detOfActVC.code = model.code;

        
//    }else if (1 == indexPath.section)
////    {
//        activityModel *model = self.activities[indexPath.section];
//
//       detOfActVC.code = model.code;

//
//    }
//
    //
//    localMapManager *detOfActVC = [[localMapManager alloc] init];
    [self.viewController.navigationController pushViewController:detOfActVC animated:YES];
//    [self.viewController presentViewController:detOfActVC animated:YES completion:^{
//
//    } ];

    
    
}

#pragma mark - 编辑模式

//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    NSMutableArray *actionArr = @[].mutableCopy;
//
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//
////        [self deleteCurrencyWithIndex:indexPath.row];
//    }];
//
//    deleteAction.backgroundColor = kHexColor(@"#FF4545");
//
//    [actionArr addObject:deleteAction];
//
//    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//
////        [self topCurrencyWithIndex:indexPath.row];
//    }];
//
//    editAction.backgroundColor = kHexColor(@"#C3C3C3");
//
//    [actionArr addObject:editAction];
//
//    return actionArr;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//        return [self.cell cellRowHeight];
    
#warning 变化
    return  307;
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

//#pragma mark - Events
//- (void)clickShare:(UIButton *)sender {
//
//    NSInteger index = sender.tag - 2000;
//
//    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:button:selectRowAtIndex:)]) {
//
//        [self.refreshDelegate refreshTableViewButtonClick:self button:sender selectRowAtIndex:index];
//    }
//}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
