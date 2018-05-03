//
//  TLTextStorage.m
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/7.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "TLTextStorage.h"
//#import "TLEmoticonHelper.h"
#import "TLTextAttachment.h"

@implementation TLTextStorage
{
    NSMutableAttributedString *_imp;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        _imp = [NSMutableAttributedString new];
    }
    
    return self;
}


#pragma mark - Reading Text
- (NSString *)string
{
    return _imp.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [_imp attributesAtIndex:location effectiveRange:range];
}


#pragma mark - Text Editing
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    [_imp replaceCharactersInRange:range withString:str];
    
    [self edited:NSTextStorageEditedCharacters range:range changeInLength:(NSInteger)str.length - (NSInteger)range.length];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    [_imp setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
}


#pragma mark - Syntax highlighting

- (void)processEditing
{
    // Regular expression matching all iWords -- first character i, followed by an uppercase alphabetic character, followed by at least one other character. Matches words like iPod, iPhone, etc.
    static NSRegularExpression *emoticonExpression;
    static NSRegularExpression *atExpression;

    //	iExpression = iExpression ?: [NSRegularExpression regularExpressionWithPattern:@"i[\\p{Alphabetic}&&\\p{Uppercase}][\\p{Alphabetic}]+" options:0 error:NULL];
    
    emoticonExpression = emoticonExpression ?: [NSRegularExpression regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]" options:0 error:NULL];
    
    atExpression = atExpression ?: [NSRegularExpression regularExpressionWithPattern:@"@[-_a-zA-Z0-9\u4E00-\u9FA5]+" options:0 error:NULL];
    
    
    // 清除原来的信息，在编辑范围内
    NSRange paragaphRange = [self.string paragraphRangeForRange:self.editedRange];
    
    [self removeAttribute:NSForegroundColorAttributeName range:paragaphRange];
    
    // Find all iWords in range
    [atExpression enumerateMatchesInString:self.string options:0 range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        // Add red highlight color
        [self addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:result.range];
        
    }];
    
    // Call super *after* changing the attrbutes, as it finalizes the attributes and calls the delegate methods.
    [super processEditing];
    
//    TLTextAttachment *attachment = [[TLTextAttachment alloc] init];
//    attachment.image = [UIImage imageWithContentsOfFile:@"/var/containers/Bundle/Application/A101F2B4-B42C-473B-AAF9-F47E6AE58ABA/CityBBS.app/Emoticons.bundle/com.sina.default/d_guzhang.png"];
//    attachment.bounds = CGRectMake(0, -3, self.textView.font.lineHeight, self.textView.font.lineHeight);
//    
//    if (!self.string || self.string.length == 0) {
//        return;
//    }
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    style.lineSpacing = 5.0f;
//    CGSize size = [self.string boundingRectWithSize:CGSizeMake(self.textView.width - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{
//                                                                                                                                                               
//                                                                                                                                                              NSParagraphStyleAttributeName : style,                                                                                              NSFontAttributeName : self.textView.font,
//                                                                                                                                                               NSAttachmentAttributeName : attachment
//                                                                                                                                                               } context:nil].size;
//    [UIView animateWithDuration:0.25 animations:^{
//        
//        self.textView.height = size.height + 5 + 5 + 20;
//
//    }];
    
    
}

@end
