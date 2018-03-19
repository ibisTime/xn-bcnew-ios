//
//  TLComposeTextView.h
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/6.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TLEmoticon.h"
#import "TLTextAttachment.h"

#define COMPOSE_ORG_HEIGHT 200
@interface TLComposeTextView : UITextView

//- (void)appendEmoticon:(TLEmoticon *)emoticon;
//- (void)deleteEmoticon:(TLEmoticon *)emoticon;

@property (nonatomic,strong) UILabel *placeholderLbl;

@property (nonatomic, copy) NSMutableString *copyText;
@property (nonatomic, copy) NSString *placholder;

@end
