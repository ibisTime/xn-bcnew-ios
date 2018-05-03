//
//  TLEmoticonCell.m
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/4.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "TLEmoticonCell.h"
#import "TLEmoticonHelper.h"

@interface TLEmoticonCell ()


@end

@implementation TLEmoticonCell

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:imageView];
//        imageView.size = CGSizeMake(32, 32);
//        imageView.center = self.center;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(32);
            make.height.mas_equalTo(32);
            make.center.equalTo(self.contentView);

        }];
        
        
//        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showEmoticon:)];
//        imageView.userInteractionEnabled = YES;
//        [imageView addGestureRecognizer:longTap];
        self.imageView = imageView;
    }
    
    return self;

}

- (void)showEmoticon:(UILongPressGestureRecognizer *)longPress {

//    if (longPress.state == UIGestureRecognizerStateEnded) {
//        
//    } else {
//    
////        emoticon_keyboard_magnifier@2x.png
//        UIImageView *imageView =  (UIImageView *)longPress.view;
//
//        CGRect displayFrame = [imageView convertRect:imageView.bounds toView:nil];
//
//        static UIImageView *displayImageView ;
//        displayImageView = displayImageView ? : [[UIImageView alloc] initWithFrame:CGRectMake(displayFrame.origin.x, displayFrame.origin.y - 50, displayFrame.size.width, 50)];
//        
//        
//        
//     UIImageView *displayImageView =  ;
//        displayImageView.backgroundColor = [UIColor orangeColor];
//        [[UIApplication sharedApplication].keyWindow addSubview:displayImageView];
//    
//    }
//    
//    NSTimeInterval dur = 0.1;
//    [UIView animateWithDuration:dur delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
////        _magnifierContent.top = 3;
//    } completion:^(BOOL finished) {
//        
//        [UIView animateWithDuration:dur delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            
////            _magnifierContent.top = 6;
//            
//        } completion:^(BOOL finished) {
//            
//            [UIView animateWithDuration:dur delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
////                _magnifierContent.top = 5;
//            } completion:^(BOOL finished) {
//                
//            }];
//            
//        }];
//    }];


    
}

- (void)setEmoticon:(TLEmoticon *)emoticon {

    _emoticon = emoticon;

    if (emoticon) {
        
        NSString *imgPath = nil;
        
        if ([_emoticon.png hasPrefix:@"lxh"]) {
            
            imgPath = [NSString stringWithFormat:@"%@/%@",[TLEmoticonHelper lxhEmoticonPath],emoticon.png];
            
        } else {
        
            imgPath = [NSString stringWithFormat:@"%@/%@",[TLEmoticonHelper defaultEmoticonPath],emoticon.png];
        }
        UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
        if (img) {
            self.imageView.image = img;

        } else {
        
            NSLog(@"null");
        
        }
        
        return;
    }
    
    if (self.isDelete) {
        
        self.imageView.image = [UIImage imageNamed:@"compose_emotion_delete@2x"];


    } else {
    
        self.imageView.image = nil;

    }


}
@end
