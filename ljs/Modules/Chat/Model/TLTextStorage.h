//
//  TLTextStorage.h
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/7.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLTextStorage : NSTextStorage

// NSTextStorage 保存着文本信息
// Text storage管理者一系列的NSLayoutManager对象
// NSTextContainer描述了文本在屏幕上显示时的几何区域
@property (nonatomic, strong) UITextView *textView;

@end
