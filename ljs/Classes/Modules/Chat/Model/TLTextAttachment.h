//
//  TLTextAttachment.h
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/7.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLEmoticon.h"

@interface TLTextAttachment : NSTextAttachment

@property (nonatomic, strong) TLEmoticon *emoticon;

@end
