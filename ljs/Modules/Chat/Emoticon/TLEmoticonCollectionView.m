//
//  TLEmoticonCollectionView.m
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/7.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "TLEmoticonCollectionView.h"
#import "TLEmoticonCell.h"

@implementation TLEmoticonCollectionView



- (UIImageView *)magnifyImageView {
    
    if (!_magnifyImageView) {
        
        _magnifyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 91.5)];
        _magnifyImageView.image = [UIImage imageNamed:@"emoticon_keyboard_magnifier@2x.png"];
        _magnifyImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        //
        _magnifyContent = [[UIImageView alloc] initWithFrame:CGRectMake(12, 8, 40, 40)];
        _magnifyContent.contentMode = UIViewContentModeScaleAspectFit;
        [_magnifyImageView addSubview:_magnifyContent];
    }
    
    return _magnifyImageView;
    
}


#pragma 处理表情输出，和放大镜
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    //
    TLEmoticonCell *cell = [self getCellByOrgPoint:point];
    
    //
    if (cell && !(cell.emoticon == nil && cell.isDelete == NO) && !cell.isDelete) {
        
        CGRect frame = [cell.imageView convertRect:cell.imageView.bounds toView:self];
        
        self.magnifyImageView.centerX = CGRectGetMidX(frame);
        self.magnifyImageView.bottom = CGRectGetMaxY(frame);
        self.magnifyContent.image = cell.imageView.image;
        [self addSubview:self.magnifyImageView];
        
    }
    
    
}
//
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (!self.magnifyImageView.superview) {
        
        [self addSubview:self.magnifyImageView];
        
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    //
    TLEmoticonCell *cell = [self getCellByOrgPoint:point];
    
    //
    if (cell && !(cell.emoticon == nil && cell.isDelete == NO) && !cell.isDelete) {
        
        CGRect frame = [cell.imageView convertRect:cell.imageView.bounds toView:self];
        
        self.magnifyImageView.centerX = CGRectGetMidX(frame);
        self.magnifyImageView.bottom = CGRectGetMaxY(frame);
        self.magnifyContent.image = cell.imageView.image;
        [self addSubview:self.magnifyImageView];
        
    } else {
    
        [self.magnifyImageView removeFromSuperview];
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.magnifyImageView removeFromSuperview];
    
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //
    TLEmoticonCell *cell = [self getCellByOrgPoint:point];
    
    if (cell && self.editAction && !(cell.emoticon == nil && cell.isDelete == NO)) {
        
        self.editAction(cell.isDelete,cell.emoticon);
        
    }
    
    
}

- (TLEmoticonCell *)getCellByOrgPoint:(CGPoint)orgPoint {
    
  
    
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:orgPoint];
    
    TLEmoticonCell *cell = (TLEmoticonCell *)[self cellForItemAtIndexPath:indexPath];
    
    return cell;
    
}

@end
