//
//  ZHAddAddressVC.m
//  ljs
//
//  Created by  蔡卓越 on 2016/12/29.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "ZHAddAddressVC.h"
//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Category
#import "NSString+Check.h"
//Extension
#import "IQKeyboardManager.h"
//V
#import "AddressPickerView.h"
#import "TLTextField.h"

@interface ZHAddAddressVC ()<UIScrollViewDelegate>

@property (nonatomic,strong) TLTextField *nameTf;
@property (nonatomic,strong) TLTextField *mobileTf;
@property (nonatomic,strong) TLTextField *proviceTf;
@property (nonatomic,strong) TLTextField *cityTf;
@property (nonatomic,strong) TLTextField *areaTf;

@property (nonatomic,strong) TLTextField *detailAddressTf;

@property (nonatomic,strong) AddressPickerView *addressPicker;

@end

@implementation ZHAddAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *bgScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    [self.view addSubview:bgScrollview];
    bgScrollview.delegate = self;
    
    CGFloat leftW = 115;
    CGFloat margin = 1;
    
    
    //
    self.nameTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 50) leftTitle:@"收货人姓名" titleWidth:leftW placeholder:@"请输入收货人姓名"];
    [bgScrollview addSubview:self.nameTf];
    
    // 手机号码
    self.mobileTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.nameTf.yy + margin , kScreenWidth, 50) leftTitle:@"手机号" titleWidth:leftW placeholder:@"请输入手机号码"];
    self.mobileTf.keyboardType = UIKeyboardTypeNumberPad;
    [bgScrollview addSubview:self.mobileTf];
    
    //省市区
    self.proviceTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.mobileTf.yy + margin, kScreenWidth, 50) leftTitle:@"省份" titleWidth:leftW placeholder:@"请选择省份"];
    [bgScrollview addSubview:self.proviceTf];
    
    self.cityTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.proviceTf.yy + margin, kScreenWidth, 50) leftTitle:@"城市" titleWidth:leftW placeholder:@"请选择城市"];
    [bgScrollview addSubview:self.cityTf];
    
    self.areaTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.cityTf.yy + margin, kScreenWidth, 50) leftTitle:@"区县" titleWidth:leftW placeholder:@"请选择城市区县"];
    [bgScrollview addSubview:self.areaTf];
    
    UIButton *maskBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.proviceTf.y, kScreenWidth, self.areaTf.yy - self.proviceTf.y)];
    [maskBtn addTarget:self action:@selector(chooseAddr) forControlEvents:UIControlEventTouchUpInside];
    [bgScrollview addSubview:maskBtn];
    
    //
    self.detailAddressTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.areaTf.yy + margin + 10, kScreenWidth, 50) leftTitle:@"详细地址" titleWidth:leftW placeholder:@"请输入详细地址"];
    [bgScrollview addSubview:self.detailAddressTf];
    
    //btn
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确定" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:5];
    
    confirmBtn.frame = CGRectMake(15, self.detailAddressTf.yy + 30, kScreenWidth - 30, 45);
    
    [bgScrollview addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
    if (confirmBtn.yy > kSuperViewHeight) {
        bgScrollview.contentSize = CGSizeMake(kScreenWidth, confirmBtn.yy + 10);
    } else {
        bgScrollview.contentSize = CGSizeMake(kScreenWidth, kSuperViewHeight + 5);

    }
    
    if (self.address) {
        self.nameTf.text = self.address.addressee;
        self.mobileTf.text = self.address.mobile;;
        self.proviceTf.text = self.address.province;
        self.cityTf.text = self.address.city;
        self.areaTf.text = self.address.district;
        self.detailAddressTf.text = self.address.detailAddress;
    }
    
}

- (void)setAddressType:(AddressType)addressType {

    _addressType = addressType;
    
    self.title = _addressType == AddressTypeAdd ? @"新增地址": @"编辑地址";
}

- (AddressPickerView *)addressPicker {
    
    if (!_addressPicker) {
        
        _addressPicker = [[AddressPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        __weak typeof(self) weakSelf = self;
        _addressPicker.confirm = ^(NSString *province,NSString *city,NSString *area){
            
            weakSelf.cityTf.text = city;
            weakSelf.proviceTf.text = province;
            weakSelf.areaTf.text = area;

        };
    }
    return _addressPicker;
}

//选择地址
- (void)chooseAddr {

    //
    [self.view endEditing:YES];
    
    //
    [[UIApplication sharedApplication].keyWindow addSubview:self.addressPicker];
}

- (void)confirm {
    
    if (![self.mobileTf.text isPhoneNum]) {
        [TLAlert alertWithInfo:@"请输入正确的手机号码"];
        return;
    }
    
    if (![self.proviceTf.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择省市区"];
        return;
    }
    
    if (![self.detailAddressTf.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入详细地址"];
        return;
    }

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    
    if (self.address) { //修改
        http.code = @"805162";
        http.parameters[@"code"] = self.address.code;
        
    } else { //添加
        
        http.code = @"805160";
    }
    
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"addressee"] = self.nameTf.text;
    http.parameters[@"mobile"] = self.mobileTf.text;
    http.parameters[@"province"] = self.proviceTf.text;
    http.parameters[@"city"] = self.cityTf.text;
    http.parameters[@"district"] = self.areaTf.text;
    http.parameters[@"detailAddress"] = self.detailAddressTf.text;
    
    [http postWithSuccess:^(id responseObject) {
        
        
        if (!self.address) {
            [TLAlert alertWithSucces:@"添加成功"];

        } else {
        
            [TLAlert alertWithSucces:@"修改成功"];
            if (self.editSuccess) {
                
                ZHReceivingAddress *address = [ZHReceivingAddress new];
                address.addressee = self.nameTf.text;
                address.mobile = self.mobileTf.text;
                address.province = self.proviceTf.text;
                
                address.city  = self.cityTf.text;
                address.district = self.areaTf.text;
                address.detailAddress = self.detailAddressTf.text;
                
                self.editSuccess(address);
            }
        }
        [self.navigationController popViewControllerAnimated:YES];

        if (self.addAddress) {
            
            ZHReceivingAddress *address = [ZHReceivingAddress new];
            address.addressee = self.nameTf.text;
            address.mobile = self.mobileTf.text;
            address.province = self.proviceTf.text;
            
            address.city  = self.cityTf.text;
            address.district = self.areaTf.text;
            address.detailAddress = self.detailAddressTf.text;
            address.isSelected = YES;
            self.addAddress(address);
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}

@end
