//
//  CustomPickerView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/12.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectBlock)(NSInteger index);

@interface CustomPickerView : UIPickerView

@property (nonatomic,copy) DidSelectBlock selectBlock;
//数据
@property (nonatomic,copy) NSArray *tagNames;
//中间title
@property (nonatomic, strong) NSString *title;

- (void)show;

- (void)hide;

@end
