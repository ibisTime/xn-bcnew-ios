//
//  MovieAddComment.m
//  qukan43
//
//  Created by yang on 15/12/3.
//  Copyright © 2015年 ReNew. All rights reserved.
//

#import "MovieAddComment.h"

@implementation MovieAddComment

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MovieAddComment1"
                                                       owner:self
                                                     options:nil];
        
        _imageViewArray = @[self.img_star1, self.img_star2, self.img_star3, self.img_star4, self.img_star5];
        
        self.v_addcomment = [array objectAtIndex:0];
        
        [self cleamCount];
        [self addSubview:self.v_addcomment];

        self.count = -1;
 
    }
    
    return self;
}


- (void)cleamCount {

    self.count = -1;
    
    [self.img_star1 setImage:[UIImage imageNamed:@"star_un_selected"]];
    [self.img_star2 setImage:[UIImage imageNamed:@"star_un_selected"]];
    [self.img_star3 setImage:[UIImage imageNamed:@"star_un_selected"]];
    [self.img_star4 setImage:[UIImage imageNamed:@"star_un_selected"]];
    [self.img_star5 setImage:[UIImage imageNamed:@"star_un_selected"]];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self.v_star];
    
        self.canAddStar = YES;
        
        [self changeStarForegroundViewWithPoint:point];

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    if(self.canAddStar) {
        
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self.v_star];
        
        [self changeStarForegroundViewWithPoint:point];
    }
   
    return;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(self.canAddStar) {
        
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self.v_star];
        
        [self changeStarForegroundViewWithPoint:point];
    }
    
    self.canAddStar = NO;

    return;
}


- (void)changeStarForegroundViewWithPoint:(CGPoint)point {
    
    NSInteger count = 0;
    
    count = count + [self changeImg:point.x image:self.img_star1];
    count = count + [self changeImg:point.x image:self.img_star2];
    count = count + [self changeImg:point.x image:self.img_star3];
    count = count + [self changeImg:point.x image:self.img_star4];
    count = count + [self changeImg:point.x image:self.img_star5];
    
    if(count == 0) {
        
        count = 1;
        [self.img_star1 setImage:[UIImage imageNamed:@"star_selected"]];
    }
    
    self.count = count;
    
}

- (NSInteger)changeImg:(float)x image:(UIImageView*)img {
    
    if(x >= img.frame.origin.x ) {
        
        NSLog(@"%f",img.frame.origin.x);
        [img setImage:[UIImage imageNamed:@"star_selected"]];
        
        return 1;
//        [self setImageAnimation:img];
    }else {
        
        [img setImage:[UIImage imageNamed:@"star_un_selected"]];
        
        return 0;
    }
}

- (void)setImageAnimation:(UIView *)v {
    
    CGRect rec = v.frame;
    
    [UIView animateWithDuration:0.1 animations:^ {
        
        v.frame = CGRectMake(v.frame.origin.x, v.frame.origin.y -3, v.frame.size.width, v.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^ {
            
            v.frame = rec;
            
        } completion:^(BOOL finished) {
            
            v.frame = rec;
        }];
    }];
}

- (void)setSelectedStarNum:(NSInteger)starNum {

    for (int i = 0; i < starNum; i++) {
        
        UIImageView *imageView = _imageViewArray[i];
        [imageView setImage:[UIImage imageNamed:@"star_selected"]];
    }
}

@end
