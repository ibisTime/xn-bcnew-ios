//
//  WarningableViewCell.m
//  ljs
//
//  Created by zhangfuyu on 2018/5/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "WarningableViewCell.h"
#import <Masonry.h>
#import "UIColor+Extension.h"
@interface WarningableViewCell ()

@property (nonatomic , strong)UILabel *titleLabel;

@end

@implementation WarningableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(16);
        }];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right);
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.width.mas_equalTo(50);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"删除 红"] forState:UIControlStateNormal];
        [self.contentView addSubview:_deleteBtn];
    }
    return _deleteBtn;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#3A3A3A"];
        
    }
    return _titleLabel;
}
- (void)setDataModel:(PlatformWarningModel *)dataModel
{
    _dataModel = dataModel;
    NSString *titleText = @"";
    if ([dataModel.warnDirection isEqualToString:@"0"]) {
        titleText = @"上涨至";
    }
    else
    {
        titleText = @"下跌至";
    }
    
    if ([dataModel.warnCurrency isEqualToString:@"USD"]) {
        NSString *subtext = [NSString stringWithFormat:@"$%.2f",[dataModel.warnPrice floatValue]];
        titleText = [titleText stringByAppendingString:@"  "];
        titleText = [titleText stringByAppendingString:subtext];
    }
    else
    {
        NSString *subtext = [NSString stringWithFormat:@"¥%.2f",[dataModel.warnPrice floatValue]];
        titleText = [titleText stringByAppendingString:@"  "];
        titleText = [titleText stringByAppendingString:subtext];
    }
    
    titleText = [titleText stringByAppendingString:@"  时提醒"];
    self.textLabel.text = titleText;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
