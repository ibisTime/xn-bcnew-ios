//
//  TLComposeTextView.m
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/6.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "TLComposeTextView.h"

@interface TLComposeTextView()


@end

@implementation TLComposeTextView
- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.placeholderLbl];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame textContainer:(nullable NSTextContainer *)textContainer  {

    if (self = [super initWithFrame:frame textContainer:textContainer]) {
        
        [self addSubview:self.placeholderLbl];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
        
    }
    
    return self;
}

- (void)textChange {

   
    if (self.text && self.text.length > 0) {
        
        [self.placeholderLbl removeFromSuperview];
        
    } else {
        
        [self addSubview:self.placeholderLbl];
        
    }
    

}

//- (void)appendEmoticon:(TLEmoticon *)emoticon {
//
//    if (self.attributedText == nil) {
//        
//        self.attributedText = [NSAttributedString new];
//    }
//    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
//    
//    //图片字符串
//    TLTextAttachment *attachment = [[TLTextAttachment alloc] init];
//    attachment.emoticon = emoticon;
//    attachment.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", emoticon.directory, emoticon.png]];
//    attachment.bounds = CGRectMake(0, -3, self.font.lineHeight, self.font.lineHeight);
//    NSAttributedString *willAddAttributeString = [NSAttributedString attributedStringWithAttachment:attachment];
//    
//    //
//    NSInteger insertIndex = self.selectedRange.location;
//    
//    [attributedText insertAttributedString:willAddAttributeString atIndex:insertIndex];
//    
////    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
////    style.lineSpacing = 3.0f;
//    [attributedText addAttributes:@{
//                                    NSFontAttributeName : self.font
//                                    } range:NSMakeRange(0, attributedText.length)];
//    
//    
//
//    
//    self.attributedText = attributedText;
//    self.selectedRange = NSMakeRange(insertIndex + 1, 0);
//    
//    
//    CGSize size = [self sizeThatFits:CGSizeMake(self.width - 10, MAXFLOAT)];
//    if (size.height + 10 > COMPOSE_ORG_HEIGHT) {
//        
//        self.height = size.height + 10;
//
//    } else  {
//    
//        self.height = COMPOSE_ORG_HEIGHT;
//    }
//    
//}

- (NSMutableString *)copyText {

    if (!_copyText) {
        
        _copyText = [NSMutableString new];
    }
    return _copyText;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
 
    
}

- (void)setAttributedText:(NSAttributedString *)attributedText {

    [super setAttributedText:attributedText];
    
    if (attributedText && attributedText.string.length > 0) {
        
        [self.placeholderLbl removeFromSuperview];

    } else {
        
        [self addSubview:self.placeholderLbl];

    }
    
    return;
    
}




- (void)setPlacholder:(NSString *)placholder {
    
    _placholder = [placholder copy];
    self.placeholderLbl.text = _placholder;
    
}

- (UILabel *)placeholderLbl {
    
    if (!_placeholderLbl) {
     _placeholderLbl =  [UILabel
        
                    labelWithFrame:CGRectMake(15, 5, 200, 20)
                                                     textAligment:NSTextAlignmentLeft
                                                  backgroundColor:[UIColor whiteColor]
                                                             font:self.font
                                                        textColor:[UIColor textColor]];
//     _placeholderLbl.userInteractionEnabled = YES;
        
    }
    return _placeholderLbl;
    
}

//- (void)deleteEmoticon:(TLEmoticon *)emoticon {

    
//    [self deleteBackward];
//    NSInteger location = self.selectedRange.location;
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString: self.attributedText];
//    
//    [str deleteCharactersInRange:NSMakeRange(location - 1, 1)];
//    
//    self.attributedText = str;
//    self.selectedRange = NSMakeRange((location - 1) ? : 0 , 0);
    
//    = [self.attributedText attr];
//   self.attributedText = [self.attributedText attributedSubstringFromRange:NSMakeRange(0, self.attributedText.length - 1)];

//}

@end
