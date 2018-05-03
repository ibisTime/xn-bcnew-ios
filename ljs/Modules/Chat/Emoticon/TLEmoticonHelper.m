//
//  TLEmoticonHelper.m
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/5.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "TLEmoticonHelper.h"
#import "TLEmoticonGroup.h"
#import "TLTextAttachment.h"

NSInteger const kOnePageCount = 20;//每页表情数量

@implementation TLEmoticonHelper

+ (instancetype)shareHelper {

    static TLEmoticonHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        helper = [[TLEmoticonHelper alloc] init];
        [helper initData];
        
    });
    
    return helper;

}

#pragma mark- 加载全部表情
- (NSMutableArray *)emoticonGroups {
    
    if (!_emoticonGroups) {
        
        _emoticonGroups = [[NSMutableArray alloc] initWithCapacity:2];
        //默认
        NSString *plistPath0 = [NSString stringWithFormat:@"%@/Info.plist",[TLEmoticonHelper defaultEmoticonPath]];
        TLEmoticonGroup *defaultGroup = [TLEmoticonGroup tl_objectWithDictionary:[NSDictionary dictionaryWithContentsOfFile:plistPath0]];
//        defaultGroup.path = [TLEmoticonHelper defaultEmoticonPath];
        
        [defaultGroup.emoticons enumerateObjectsUsingBlock:^(TLEmoticon * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.directory = [TLEmoticonHelper defaultEmoticonPath];
        }];
        
        //小花
        NSString *plistPath1 = [NSString stringWithFormat:@"%@/Info.plist",[TLEmoticonHelper lxhEmoticonPath]];
        TLEmoticonGroup *lxhGroup = [TLEmoticonGroup tl_objectWithDictionary:[NSDictionary dictionaryWithContentsOfFile:plistPath1]];
        lxhGroup.path = [TLEmoticonHelper lxhEmoticonPath];
        [lxhGroup.emoticons enumerateObjectsUsingBlock:^(TLEmoticon * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            obj.directory = [TLEmoticonHelper lxhEmoticonPath];
            
        }];
        
        //添加
        [_emoticonGroups addObject:defaultGroup];
        [_emoticonGroups addObject:lxhGroup];
        
        
    }
    return _emoticonGroups;
    
}

- (void)initData {

    NSMutableArray <NSNumber *>*pageArray = [[NSMutableArray alloc] init];
    NSMutableArray <NSNumber *>*startPageArray = [[NSMutableArray alloc] init];
    
    //计算多少组
    __block NSInteger lastPageCount = 0;
    
    __block NSInteger totalPageCount = 0;
    [self.emoticonGroups enumerateObjectsUsingBlock:^(TLEmoticonGroup * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //计算产生多少组
        NSInteger emoticonCount = obj.emoticons.count;
        
        //预计组数
        NSInteger pageCount = emoticonCount/kOnePageCount;
        
        //实际组数
        NSInteger rePageCount = emoticonCount%kOnePageCount == 0 ? pageCount : pageCount + 1;
        
        
        totalPageCount += rePageCount;
        
        [pageArray addObject:@(rePageCount)];
        
        [startPageArray addObject:@(lastPageCount)];
        
        lastPageCount += rePageCount;
        
    }];
    
    self.totalPageCount = totalPageCount;
    self.startPageArray = startPageArray;
    self.pageCountArray = pageArray;

}

- (NSInteger)getCurrentGroupBySection:(NSInteger)section {

    NSInteger currentGroup = 0;
    for (NSInteger i = 0; i < self.emoticonGroups.count; i ++) {
        
        if (i == 0) {
            
            if (section < [self.startPageArray[1] integerValue]) {
                currentGroup = 0;
                break;
            }
            
        } else if (i == self.emoticonGroups.count - 1) {
            
            if (section >= [[self.startPageArray lastObject] integerValue]) {
                currentGroup = self.startPageArray.count - 1;
            }
            
        } else {
            
            if (section >= [self.startPageArray[i] integerValue] && section < [self.startPageArray[i + 1] integerValue]) {
                currentGroup = i;
                break;
            }
            
        }
        
    }
    
    return currentGroup;


}


- (TLEmoticon *)getTransformEmoticonByIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger currentGroup = [self getCurrentGroupBySection:indexPath.section];


    
    
    //当前页，位于当前表情类型的相对页数
    NSInteger currentEmoticonPageCount = 0;
    if (currentGroup > 0) {
        
        currentEmoticonPageCount = indexPath.section - [self.startPageArray[currentGroup] integerValue];
        
    } else {
        
        currentEmoticonPageCount = indexPath.section;
        
    }
    
    //
    NSInteger reIndex = indexPath.row/3 + (indexPath.row%3)*7;
    
    //
    NSInteger indexNum = currentEmoticonPageCount*kOnePageCount + reIndex;
    
    //
    if (indexNum < self.emoticonGroups[currentGroup].emoticons.count) {
        
        return self.emoticonGroups[currentGroup].emoticons[indexNum];
        
    } else {
        
        return nil;
        
    }
    
    
}


+ (NSAttributedString *)convertEmoticonStrToAttributedString:(NSString *)normalStr {

    if (!normalStr || normalStr.length == 0) {
        return nil;
    }
    
    //正序匹配
    NSArray<NSTextCheckingResult *> *result = [[self regexEmoticon] matchesInString:normalStr options:NSMatchingWithTransparentBounds range:NSMakeRange(0, normalStr.length)];
    
    
    if (result.count <= 0) {
        return [[NSMutableAttributedString alloc] initWithString:normalStr];
    }
    
    //数组逆序
    result = [[result reverseObjectEnumerator] allObjects];
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithString:normalStr];
    
    [result enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull checkingResult, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //取出字符串
        NSString *findStr = [normalStr substringWithRange:checkingResult.range];
        
        if (findStr.length <= 2) {
            
            return ;
            
        }
        
        __block TLEmoticon *findEmoticon = nil;
        [[TLEmoticonHelper shareHelper].emoticonGroups enumerateObjectsUsingBlock:^(TLEmoticonGroup * _Nonnull emoticonGroups , NSUInteger idx, BOOL * _Nonnull stop) {
            
            __block BOOL outStop = NO;
            [emoticonGroups.emoticons enumerateObjectsUsingBlock:^(TLEmoticon * _Nonnull emoticon, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([emoticon.chs isEqualToString:findStr]) {
                    *stop = YES;
                    outStop = YES;
                    findEmoticon = emoticon;
                    
                    UIImage *img = [[UIImage alloc] initWithContentsOfFile:[findEmoticon.directory stringByAppendingPathComponent:findEmoticon.png]];
                    
                    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                    textAttachment.image = img;
                    textAttachment.bounds = CGRectMake(0, -2.7, [FONT(14) lineHeight], [FONT(14) lineHeight]);
                    [mutableAttr deleteCharactersInRange:checkingResult.range];
                    [mutableAttr insertAttributedString: [NSAttributedString attributedStringWithAttachment:textAttachment] atIndex:checkingResult.range.location];
                    
                }
                
            }];
            
            *stop = outStop;
            
        }];
        
        
    }];


    return mutableAttr;
}


+ (NSAttributedString *)convertEmoticonStrToNormalString:(NSString *)normalStr {

    if (!normalStr || normalStr.length == 0) {
        return nil;
    }
    
    //正序匹配
    NSArray<NSTextCheckingResult *> *result = [[self regexEmoticon] matchesInString:normalStr options:NSMatchingWithTransparentBounds range:NSMakeRange(0, normalStr.length)];
    
    
    if (result.count <= 0) {
        return [[NSMutableAttributedString alloc] initWithString:normalStr];
    }
    
    //数组逆序
    result = [[result reverseObjectEnumerator] allObjects];
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithString:normalStr];
    
    [result enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull checkingResult, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //取出字符串
        NSString *findStr = [normalStr substringWithRange:checkingResult.range];
        
        if (findStr.length <= 2) {
            
            return ;
            
        }
        
        __block TLEmoticon *findEmoticon = nil;
        [[TLEmoticonHelper shareHelper].emoticonGroups enumerateObjectsUsingBlock:^(TLEmoticonGroup * _Nonnull emoticonGroups , NSUInteger idx, BOOL * _Nonnull stop) {
            
            __block BOOL outStop = NO;
            [emoticonGroups.emoticons enumerateObjectsUsingBlock:^(TLEmoticon * _Nonnull emoticon, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([emoticon.chs isEqualToString:findStr]) {
                    *stop = YES;
                    outStop = YES;
                    findEmoticon = emoticon;
                    
                    UIImage *img = [[UIImage alloc] initWithContentsOfFile:[findEmoticon.directory stringByAppendingPathComponent:findEmoticon.png]];
                    
                    TLTextAttachment *textAttachment = [[TLTextAttachment alloc] init];
                    textAttachment.emoticon = findEmoticon;
                    textAttachment.image = img;
                    textAttachment.bounds = CGRectMake(0, -3, 13.8, 13.8);
                    [mutableAttr deleteCharactersInRange:checkingResult.range];
                    [mutableAttr insertAttributedString: [NSAttributedString attributedStringWithAttachment:textAttachment] atIndex:checkingResult.range.location];
                    
                }
                
            }];
            
            *stop = outStop;
            
        }];
        
        
    }];
    
    
    return mutableAttr;
}


///-----////
+ (NSString *)emoticonsBundlePath {

    static NSString *path = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        path = [self emoticonsBundle].bundlePath;
        
    });
    
    return path;

}

+ (NSString *)lxhEmoticonPath {

    
    static NSString *path = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        path = [NSString stringWithFormat:@"%@/com.sina.lxh",[self emoticonsBundle].bundlePath];

    });
    
    return path;

}

+ (NSString *)defaultEmoticonPath {
    
    static NSString *path = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
      path = [NSString stringWithFormat:@"%@/com.sina.default",[self emoticonsBundle].bundlePath];
        
    });
    
    return path;
    
}

+ (NSBundle *)emoticonsBundle {

    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Emoticons" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:path];
        
    });
    
    return bundle;

}

+ (NSRegularExpression *)regexEmoticon {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSRegularExpression *)regexAt {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 微博的 At 只允许 英文数字下划线连字符，和 unicode 4E00~9FA5 范围内的中文字符，这里保持和微博一致。。
        // 目前中文字符范围比这个大
        regex = [NSRegularExpression regularExpressionWithPattern:@"@[-_a-zA-Z0-9\u4E00-\u9FA5]+" options:kNilOptions error:NULL];
    });
    return regex;
}

@end
