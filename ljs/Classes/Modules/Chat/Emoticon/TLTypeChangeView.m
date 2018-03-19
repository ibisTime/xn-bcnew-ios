//
//  TLTypeChangeView.m
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/5.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "TLTypeChangeView.h"

#define UN_SELECTED_COLOR [UIColor whiteColor]
#define SELECTED_COLOR [[UIColor colorWithHexString:@"#bfbfbf"] colorWithAlphaComponent:0.5]


@interface TLTypeChangeView()

@property (nonatomic, strong) NSMutableArray *btns;

@end


@implementation TLTypeChangeView
{
    UIButton *_lastBtn;
    NSMutableArray *_btns;

}

- (NSMutableArray *)btns {

    if (!_btns) {
        
        _btns = [NSMutableArray array];
    }
    
    return _btns;

}
- (void)setTypeNames:(NSArray *)typeNames {

    if (_typeNames) {
        return;
    }
    
    _typeNames = typeNames;
    CGFloat w = 120;
    self.backgroundColor = [[UIColor colorWithHexString:@"#bfbfbf"] colorWithAlphaComponent:0.2];
//    self.frame.size.width/_typeNames.count;
    
    [_typeNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(idx*w, 0, w, self.height)];
        [btn setTitle:obj forState:UIControlStateNormal];
        btn.backgroundColor = UN_SELECTED_COLOR;
        [btn setTitleColor:[UIColor colorWithHexString:@"#484848"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + idx;
        [self addSubview:btn];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        if (idx == 0) {
            _lastBtn = btn;
            btn.backgroundColor = SELECTED_COLOR;
        }
        
        [self.btns addObject:btn];
        
    }];

}

- (void)change:(UIButton *)btn {

    if ([_lastBtn isEqual:btn]) {
        return;
    }
    
    if (self.changeType) {
        self.changeType(btn.tag - 100);
        
    }
    
    _lastBtn.backgroundColor = UN_SELECTED_COLOR;
    btn.backgroundColor = SELECTED_COLOR;
    _lastBtn = btn;
    
}

- (void)changeTypeByIdx:(NSInteger)idx {

    UIButton *btn = self.btns[idx];
    
    if ([btn isEqual:_lastBtn]) {
        return;
    }

    [_lastBtn setBackgroundColor:UN_SELECTED_COLOR forState:UIControlStateNormal];
    [btn setBackgroundColor:SELECTED_COLOR forState:UIControlStateNormal];
    _lastBtn = btn;

}

@end
