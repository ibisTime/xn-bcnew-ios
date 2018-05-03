//
//  TLComposeToolBar.h
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/6.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ChangeType) {
    ChangeTypePhoto = 0,
    ChangeTypeAt,
    ChangeTypeEmoticon,
};

#define TOOLBAR_EFFECTIVE_HEIGHT 46.0

@interface TLComposeToolBar : UIView

@property (nonatomic, copy) void(^changeType)(ChangeType type);

@end
