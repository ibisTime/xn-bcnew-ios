//
//  BannerCell.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BannerCell.h"

#import "UIImageView+WebCache.h"

#import "UILabel+Extension.h"

#import <Masonry.h>

@interface BannerCell ()

@property (nonatomic,weak) UIImageView *imageIV;

@property (nonatomic,strong)UILabel *nameLabel;

@end

@implementation BannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:self.bounds];
        
        [self.contentView addSubview:iv];
        iv.clipsToBounds = YES;
        iv.contentMode = UIViewContentModeScaleAspectFill;
        self.imageIV = iv;
        
        
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.nameLabel];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(20);
        }];
        
    }
    return self;
}

- (void)setUrlString:(NSString *)urlString
{
    _urlString = [urlString copy];
    if ([_urlString hasPrefix:@"http:"]) { //网络图片
        
        NSURL *url = [NSURL URLWithString:urlString];
        if ([urlString containsString:@".gif"]) {
            
            [_imageIV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
            
        } else {
            
            [_imageIV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
            
        }
        
    } else { //本地图片
        
        self.imageIV.image = [UIImage imageWithContentsOfFile:_urlString];
        
    }
    
}

- (void)setNameText:(NSString *)nameText
{
    self.nameLabel.text = nameText;
}
@end
