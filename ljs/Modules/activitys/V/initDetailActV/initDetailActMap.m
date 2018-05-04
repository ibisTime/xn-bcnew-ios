//
//  initDetailActMap.m
//  ljs
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "initDetailActMap.h"
//Category 响应者链
#import "UIView+Responder.h"

@import CoreLocation;
@import MapKit;

@interface initDetailActMap ()
@property (nonatomic, strong) UIImageView *dateImg;
@property (nonatomic, strong) UILabel *date;
@property (nonatomic, strong) UIImageView * locationImg;
@property (nonatomic, strong) UILabel * location;
@property (nonatomic,strong) UIButton * locationBut;
@property (nonatomic, strong) UIImageView * telphoneImg;
@property (nonatomic, strong) UILabel * telphone;


@property (nonatomic, strong) NSString *urlScheme;
@property (nonatomic, strong) NSString *appName;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@end

@implementation initDetailActMap

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.backgroundColor = kWhiteColor;
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    //1
    self.dateImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"活动详情时间"]];
    
    [self addSubview:self.dateImg];
    
    [self.dateImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(13);
        make.left.offset(15);
        make.height.equalTo(@16);
        make.width.equalTo(@16);

        
        
    }];
    //2
    self.date = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#3A3A3A") font:15];
    
    [self addSubview:self.date];
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(13);
        make.left.equalTo(self.dateImg.mas_right).offset(10);
        
    }];
    //3
    self.locationImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"活动详情地址"]];
    [self addSubview:self.locationImg];
    
    [self.locationImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateImg.mas_bottom).offset(25);
        make.left.offset(15);
        make.height.equalTo(@20);
        make.width.equalTo(@16);

    }];
    
    //4
    self.location = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#3A3A3A") font:15];
    self.location.numberOfLines = 0;//行数

    [self addSubview:self.location];
    
    [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locationImg.mas_right).offset(10);
        make.centerY.equalTo(self.locationImg.mas_centerY);
        make.height.equalTo(@45);
        make.width.equalTo(@270);
    }];
    
    //5
    self.locationBut = [UIButton buttonWithTitle:@"查看地图" titleColor:kHexColor(@"#2F93ED") backgroundColor:kClearColor titleFont:12];
    [self addSubview:self.locationBut];
    [self.locationBut addTarget:self action:@selector(openMap) forControlEvents:UIControlEventTouchUpInside];
    [self.locationBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.location);
        make.right.offset(-15);
//        make.height.equalTo(@24);
//        make.width.equalTo(@25);

    }];
    
    //3
    self.telphoneImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"活动详情电话"]];
    [self addSubview:self.telphoneImg];
    
    [self.telphoneImg mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.locationImg.mas_bottom).offset(46);
        make.left.offset(15);
        make.height.equalTo(@17);
        make.width.equalTo(@17);
        
    }];
    
    //4
    self.telphone = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#3A3A3A") font:15];
    
    
    [self addSubview:self.telphone];
    
    [self.telphone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.telphoneImg.mas_right).offset(10);
        make.centerY.equalTo(self.telphoneImg.mas_centerY);
        
        
    }];
    

    
    
}


#pragma mark - sourse
-(void)setDetailActModel:(DetailActModel *)detailActModel
{
    _detailActModel = detailActModel;
    self.date.text = [NSString stringWithFormat:(@"%@/%@"),detailActModel.startDatetime,detailActModel.endDatetime];
    self.location.text = detailActModel.address;
    self.telphone.text = detailActModel.contactMobile;

}


#pragma mark - event
-(void)openMap
{
        __block NSString *urlScheme = self.urlScheme;
        __block NSString *appName = self.appName;
        __block CLLocationCoordinate2D coordinate = self.coordinate;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        //这个判断其实是不需要的
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]])
        {
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
                MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
                //目的地名称,可以传值进来,当然我们实际需要的并不是它,它只作为给用户的展示,我们实际需要的是self.coordinate,通过它来进行定位
                toLocation.name =self.detailActModel.address;
                [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                               launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
            }];
            
            [alert addAction:action];
        }
        
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])
        {
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=海威国际&mode=driving&coord_type=gcj02",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSLog(@"%@",urlString);
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                
            }];
            
            [alert addAction:action];
        }
        
        
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
        {
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appName,urlScheme,coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSLog(@"%@",urlString);
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                
            }];
            
            [alert addAction:action];
        }
        
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
        {
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"谷歌地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",appName,urlScheme,coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSLog(@"%@",urlString);
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                
            }];
            
            [alert addAction:action];
        }
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        
        [self.viewController presentViewController:alert animated:YES completion:^{
            
        }];
    
    

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
