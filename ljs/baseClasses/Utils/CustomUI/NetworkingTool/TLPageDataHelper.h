//
//  TLPageDataHelper.h
//  ljs
//
//  Created by  蔡卓越 on 2016/12/17.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>
//V
#import "TLTableView.h"
#import "BaseCollectionView.h"

@interface TLPageDataHelper : NSObject

@property (nonatomic,assign) NSInteger start;
@property (nonatomic,assign) NSInteger limit;

//网络请求的code
@property (nonatomic,copy) NSString *code;
@property (nonatomic,strong) UIView *showView; //hud展示superView
@property (nonatomic,assign) BOOL isDeliverCompanyCode; //是否展示警告信息
//列表查询
@property (nonatomic, assign) BOOL isList;
@property (nonatomic, assign) BOOL isActivity;

//账户
@property (nonatomic, assign) BOOL isCurrency;
@property (nonatomic,assign) BOOL refreshed;


//设置改值后外界只需要 调用reloadData
@property (nonatomic,weak) TLTableView *tableView;
@property (nonatomic, weak) BaseCollectionView *collectionView;

//对得到的每个数据模型进行加工
@property (nonatomic, copy) id(^dealWithPerModel)(id model);

//除start 和 limit 外的其它请求参数
@property (nonatomic,strong) NSMutableDictionary *parameters;
- (void)modelClass:(Class)className;


- (void)refresh:(void(^)(NSMutableArray *objs,BOOL stillHave))refresh failure:(void(^)(NSError *error))failure;

- (void)loadMore:(void(^)(NSMutableArray *objs,BOOL stillHave))loadMore failure:(void(^)(NSError *error))failure;

@end
