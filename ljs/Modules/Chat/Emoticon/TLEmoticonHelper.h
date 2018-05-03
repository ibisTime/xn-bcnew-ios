//
//  TLEmoticonHelper.h
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/5.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLEmoticonGroup.h"

@class TLEmoticon;

@interface TLEmoticonHelper : NSObject

+ (instancetype)shareHelper;

//每一种表情所占页数
@property (nonatomic, strong) NSMutableArray <NSNumber *>*pageCountArray;

//每一种表情开始的页数 : --- 每页0开始
@property (nonatomic, strong) NSMutableArray <NSNumber *>*startPageArray;

//表情总页数
@property (nonatomic, assign ) NSInteger totalPageCount;


@property (nonatomic, strong) NSMutableArray <TLEmoticonGroup *>*emoticonGroups;


- (TLEmoticon *)getTransformEmoticonByIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)getCurrentGroupBySection:(NSInteger)section;


+ (NSAttributedString *)convertEmoticonStrToAttributedString:(NSString *)normalStr;


+ (NSAttributedString *)convertEmoticonStrToNormalString:(NSString *)normalStr;


/**
 表情的bundle
 */
+ (NSString *)emoticonsBundlePath;

+ (NSBundle *)emoticonsBundle;

+ (NSString *)lxhEmoticonPath;

+ (NSString *)defaultEmoticonPath;


// [微笑] 正则
+ (NSRegularExpression *)regexEmoticon;

+ (NSRegularExpression *)regexAt;

    
@end

FOUNDATION_EXTERN NSInteger const kOnePageCount;

