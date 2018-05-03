//
//  TLComposeToolBar.m
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/6.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "TLComposeToolBar.h"

@implementation TLComposeToolBar
{
   BOOL _isEmoticon;

}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
        //三个按钮
        NSArray *imgNames = @[@"compose_toolbar_picture@2x.png",
                              @"compose_mentionbutton_background@2x.png",
                              @"compose_emoticonbutton_background@2x.png"];
        
        UIButton *btn;
        _isEmoticon = NO;
        CGFloat w = frame.size.width/imgNames.count;
        
        for (NSInteger i = 0; i < imgNames.count ; i ++) {
            
            btn = [[UIButton alloc] initWithFrame:CGRectMake(i*w, 0, w, TOOLBAR_EFFECTIVE_HEIGHT - 0)];
            [btn setImage:[UIImage imageNamed:imgNames[i]] forState:UIControlStateNormal];
            [self addSubview:btn];
            btn.tag = 100 + i;
            btn.backgroundColor = [UIColor whiteColor];
            [btn addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
            if (i == imgNames.count - 1) {
                
       
            }
            
        }
        
        //line
        UIView *line0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        line0.backgroundColor = [UIColor colorWithHexString:@"#bfbfbf"];
        [self addSubview:line0];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, btn.yy - 1, kScreenWidth, 1)];
        line.backgroundColor = [[UIColor colorWithHexString:@"#bfbfbf"] colorWithAlphaComponent:0.5];
        [self addSubview:line];
       
    }
    return self;
}

- (void)changeType:(UIButton *)btn {

    ChangeType type = 0;
    switch (btn.tag) {
        case 100: {
            type = ChangeTypePhoto;
        }
        break;
            
        case 101: {
            type = ChangeTypeAt;
        }
        break;
            
        case 102: {
            
            type = ChangeTypeEmoticon;
            NSString *imgName = nil;
            if (_isEmoticon) {
                
                imgName = @"compose_emoticonbutton_background@2x.png";

                
            } else {
            
                imgName = @"compose_keyboardbutton_background@2x.png";


            }
            _isEmoticon = !_isEmoticon;
            [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        }
        break;
    }
    
    if (self.changeType) {
        
        self.changeType(type);
        
    }
    
}
@end
