//
//  TLComposeArticleItem.h
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/25.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <Realm/Realm.h>

/**
 图片模型
 */
@interface TLComposeImgItem : RLMObject

@property  NSString *code;
@property  NSData *imgData;
@property  NSString *shortUrl;
/**
 图片上传成功进行赋值
 */
@property  NSString *uploadSuccessUrl;

@end

RLM_ARRAY_TYPE(TLComposeImgItem)


@interface TLComposeArticleItem : RLMObject

@property  NSString *code;

@property  NSString *title;
@property  NSString *contentText;
@property  NSString *plateCode;       //板块编号
@property  RLMArray<TLComposeImgItem *><TLComposeImgItem> *imgs;

@end
