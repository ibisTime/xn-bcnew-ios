//
//  DetailActModel.h
//  ljs
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface DetailActModel : BaseModel
@property (nonatomic,copy) NSString * advPic;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * price;

@property (nonatomic,copy) NSString * address;
@property (nonatomic,copy) NSString * readCount;

@property (nonatomic,copy) NSString * startDatetime;
@property (nonatomic,copy) NSString * endDatetime;

@property (nonatomic,assign) NSInteger  toApproveCount;
@property (nonatomic,assign) NSInteger  approveCount;

@property (nonatomic,copy) NSString * contactMobile;
@property (nonatomic,copy) NSString * photo;
@property (nonatomic,copy) NSString * isEnroll;
@property (nonatomic,copy) NSString * isCollect;


@property (nonatomic,copy) NSString * content;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic,copy) NSString * latitude;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *collectCount;
@property (nonatomic, copy) NSString *pointCount;
@property (nonatomic, copy) NSString *commentCount;
@property (nonatomic, copy) NSString *enrollCount;



@end
