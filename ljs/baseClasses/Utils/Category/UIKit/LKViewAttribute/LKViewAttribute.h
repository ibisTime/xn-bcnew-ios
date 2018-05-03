//
//  LKViewAttribute.h
//  LKKit
//
//  Created by 蔡卓越 on 16/4/28.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LKAttributeMaker;

/**
 *  category for UIView
 */
@interface UIView (LKKit)

- (LKAttributeMaker*)lk_attribute;

- (void)lk_performSelector:(SEL)aSelector withObject:(id)object;

@end



@interface LKAttributeMaker : NSObject

@property (nonatomic, strong) UIView *view;


/**
 *  base attributes for UIView
 */
- (LKAttributeMaker* (^) (UIView *superView))superView;

- (LKAttributeMaker* (^) (UIColor *color))backgroundColor;

- (LKAttributeMaker* (^) (NSInteger tag))tag;

- (LKAttributeMaker* (^) (CGFloat corner))corner;

- (LKAttributeMaker* (^) (UIColor *color, CGFloat borderWidth))border;

- (LKAttributeMaker* (^) (CGFloat alpha))alpha;


/**
 *   attributes just for UILabel
 */

- (LKAttributeMaker* (^) (NSString *text))text;

- (LKAttributeMaker* (^) (CGFloat font))font;

- (LKAttributeMaker* (^) (UIColor *color))textColor;

- (LKAttributeMaker* (^) (NSTextAlignment textAligent))textAlignment;

- (LKAttributeMaker* (^) (CGFloat lineSpace))lineSpace;

- (LKAttributeMaker* (^) (NSInteger numberLine))numberLines;


/**
 *  attributes just for UIImageView
 */

- (LKAttributeMaker* (^) (UIImage *image))image;

/**
 *  attributes just for UIButton
 */


- (LKAttributeMaker* (^) (id target, SEL selector))event;

- (LKAttributeMaker* (^) (UIImage *image))selectImage;

- (LKAttributeMaker* (^) (NSString *title))selectTitle;

- (LKAttributeMaker* (^) (UIColor *color))selectTitleColor;

- (LKAttributeMaker* (^) (UIImage *image))selectBackgroundImage;


- (LKAttributeMaker* (^) (UIImage *image))normalImage;

- (LKAttributeMaker* (^) (NSString *title))normalTitle;

- (LKAttributeMaker* (^) (UIColor *color))normalTitleColor;

- (LKAttributeMaker* (^) (UIImage *image))normalBackgroundImage;



/* UIButton
 
 ->>>>>>>>>1. font  the attribute used for UIButton and UILabel
 
 2. normalImage
 
 3. selectImage
 
 4. normalTitle
 
 5. selectTitle
 
 6. normalTitleColor
 
 7. selectedTitleColor
 
 8. 
 
 10. target select
 
 ->>>>>>>>>8.  numberLine   the attribute used for UIButton and UILabel
 
 ->>>>>>>>>9.  textAligent   the attribute used for UIButton and UILabel
 
*/




@end




