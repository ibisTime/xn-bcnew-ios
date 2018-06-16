//
//  CustomTitleButton.m
//  ljs
//
//  Created by shaojianfei on 2018/6/16.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CustomTitleButton.h"
#define ImageW  2

@implementation CustomTitleButton

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
        //设置图片显示的样式
        self.imageView.contentMode = UIViewContentModeScaleToFill;
    }
    return self;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleW = contentRect.size.width-ImageW;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(0, 0, titleW, titleH);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW = ImageW;
    CGFloat imageH = contentRect.size.height;
    CGFloat imageX = contentRect.size.width-ImageW;
    //self.imageView.contentMode = UIViewContentModeCenter;
    return CGRectMake(imageX,0, imageW, imageH);
}

-(void)setHighlighted:(BOOL)highlighted{
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
