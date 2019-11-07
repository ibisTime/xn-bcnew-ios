//
//  TLQusertionVC.m
//  Coin
//
//  Created by shaojianfei on 2018/8/4.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLQusertionVC.h"
#import "FilterView.h"
#import "TLTextView.h"
#import "LPDQuoteImagesView.h"
#import "TLTextField.h"
#import "TLhistoryListVC.h"
#import "TLUploadManager.h"
#import "TLhistoryListVC.h"
#import "NSString+Check.h"
//#import "FeedbackContactVC.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface TLQusertionVC ()<UITextViewDelegate,LPDQuoteImagesViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *bgImage;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UILabel *nameLable;

@property (nonatomic, strong) UIButton *showView;

@property (nonatomic, strong) UILabel *historyLable;
//筛选
@property (nonatomic, strong) FilterView *filterPicker;

@property (nonatomic, strong) UILabel *typeLab;

@property (nonatomic, strong) UIButton *typeButton;

@property (nonatomic, strong) UILabel *typechange;

@property (nonatomic, strong) UILabel *Qintroduce;

@property (nonatomic, strong) TLTextView *textView;
//@property (nonatomic, strong) TLTextView *reproductionView;

@property (nonatomic, strong) UIScrollView *contentView;

//@property (nonatomic, strong) TLTextField *introduceTf;

@property (nonatomic ,strong) UIButton *nextButton;
@property (nonatomic ,strong) LPDQuoteImagesView *quoteImagesView;

@property (nonatomic ,strong) UIView *lineView;
//@property (nonatomic ,strong)  UIView *lineView1;
@property (nonatomic ,strong)  UILabel *imageLable;
@property (nonatomic ,copy)  NSString *type;
@property (nonatomic ,assign) NSInteger count;

@property (nonatomic ,copy)  NSString *tempText;

@property (nonatomic ,copy)  NSString *tempRe;

@property (nonatomic ,strong)  NSMutableArray *imageString;

@end

@implementation TLQusertionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    FeedbackContactVC *vc = [FeedbackContactVC new];
//    [self.navigationController pushViewController:vc animated:YES];
    
    self.title = @"问题反馈";
    
    
    [self initCustomUi];
    [self initBodyView];
    
    [self initPicker];
    self.typechange.text = @"iOS";
    self.type = @"iOS";
    // Do any additional setup after loading the view.
}

-(NSMutableArray *)imageString
{
    if (!_imageString) {
        _imageString = [NSMutableArray array];
    }
    return _imageString;
}

- (void)initPicker
{
//    self.imageLable
    UILabel *imageLable = [[UILabel alloc] initWithFrame:CGRectMake(15, self.textView.yy+10, kScreenWidth - 30, 22)];
    imageLable.text = @"问题截图（选填）";
    imageLable.textColor = kBlackColor;
//    [imageLable theme_setTextColorIdentifier:LabelColor moduleName:ColorName];
    imageLable.font = [UIFont systemFontOfSize:14];
    [self.bgImage addSubview:imageLable];
    
    LPDQuoteImagesView *quoteImagesView =[[LPDQuoteImagesView alloc] initWithFrame:CGRectMake(15, imageLable.yy + 10, kScreenWidth -30, SCREEN_WIDTH/4) withCountPerRowInView:4 cellMargin:11];
    
    quoteImagesView.collectionView.showsVerticalScrollIndicator = NO;
    quoteImagesView.collectionView.showsHorizontalScrollIndicator = NO;
    quoteImagesView.collectionView.scrollEnabled = NO;
    quoteImagesView.backgroundColor = kWhiteColor;
    //初始化view的frame, view里每行cell个数， cell间距（上方的图片1 即为quoteImagesView）
//    注：设置frame时，我们可以根据设计人员给的cell的宽度和最大个数、排列，间距去大致计算下quoteview的size.
    quoteImagesView.maxSelectedCount = 9;
    self.quoteImagesView = quoteImagesView;
    //最大可选照片数
    //view可否滑动
    MJWeakSelf;
    quoteImagesView.HeightChange = ^(CGFloat height) {
        
//        [self.quoteImagesView removeFromSuperview];
        self.quoteImagesView.backgroundColor = [UIColor redColor];
        self.quoteImagesView.frame = CGRectMake(15, imageLable.yy + 10, kScreenWidth - 30, height);
        self.quoteImagesView.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 30, height);
        self.lineView.frame = CGRectMake(15, quoteImagesView.yy+10, kScreenWidth - 30, 0.5);
//        self.introduceTf.frame = CGRectMake(15, quoteImagesView.yy + 10, kScreenWidth-30, 50);
//        self.lineView1.frame = CGRectMake(15, self.introduceTf.yy+5, kScreenWidth - 30, 0.5);
        self.nextButton.frame =  CGRectMake(15, self.lineView.yy+30, kScreenWidth - 30, 45);
        self.bgImage.contentSize = CGSizeMake(0,  self.nextButton.yy+60);



        [self.view setNeedsLayout];
        [self.bgImage setNeedsDisplay];
    };
    quoteImagesView.navcDelegate = self;
    quoteImagesView.backgroundColor = kWhiteColor;
//    [quoteImagesView theme_setBackgroundColorIdentifier:BackColor moduleName:ColorName];
    //self 至少是一个控制器。
    //委托（委托controller弹出picker，且不用实现委托方法）
    UIView *lineView = [UIView new];
    lineView.backgroundColor = kLineColor;
//    [lineView theme_setBackgroundColorIdentifier:LineViewColor moduleName:ColorName];
    self.lineView = lineView;

    
    lineView.frame = CGRectMake(15, quoteImagesView.yy+10, kScreenWidth - 30, 0.5);
    [self.bgImage addSubview:lineView];
    [self.bgImage addSubview:quoteImagesView];
//    TLTextField *introduceTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, quoteImagesView.yy + 10, kScreenWidth, 50) leftTitle:@"备注（选填）" titleWidth:120 placeholder:@"请留下您的联系方式（推荐邮箱)"];
//    [self.bgImage addSubview:introduceTf];
//    introduceTf.leftLbl.font = [UIFont systemFontOfSize:14];
//    introduceTf.textColor = kHexColor([TLUser TextFieldTextColor]);
//    [introduceTf setValue:kHexColor([TLUser TextFieldPlacColor]) forKeyPath:@"_placeholderLabel.color"];
//    self.introduceTf = introduceTf;
//
//    UIView *lineView1 = [UIView new];
//    [lineView theme_setBackgroundColorIdentifier:LineViewColor moduleName:ColorName];
//    lineView1.frame = CGRectMake(15, introduceTf.yy+5, kScreenWidth - 30, 0.5);
//    [self.bgImage addSubview:lineView1];
//    self.lineView1 = lineView1;
    
    
    self.nextButton = [UIButton buttonWithImageName:nil cornerRadius:4];
    NSString *text = @"提交";
    [self.nextButton setTitle:text forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.nextButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    self.nextButton.frame =  CGRectMake(15, lineView.yy+30, kScreenWidth - 30, 45);
    [self.nextButton setBackgroundColor:kAppCustomMainColor forState:UIControlStateNormal];
    [self.bgImage addSubview:self.nextButton];
    self.bgImage.contentSize = CGSizeMake(0,  self.nextButton.yy+60);

//    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(introduceTf.mas_bottom).offset(10);
//        make.right.equalTo(self.bgImage.mas_right).offset(-15);
//        make.left.equalTo(self.bgImage.mas_left).offset(15);
//        make.height.equalTo(@48);
//
//    }];
    
//    self.bgImage.contentSize = CGSizeMake(0, 0);
    
}

- (void)submit
{
    //提交
    if (!self.type || self.type == nil) {
        [TLAlert alertWithMsg:@"请选择客户端"];
        return;
    }
    if ([self.textView.text isBlank]) {
        [TLAlert alertWithMsg:@"请详细描述一下问题"];
        return;
    }
//    if ([self.reproductionView.text isBlank]) {
//        [TLAlert alertWithMsg:@"请填写复现步骤"];
//        return;
//    }
    
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    TLNetworking *http = [TLNetworking new];
    
//    http.isUploadToken = NO;
    http.code = @"805100";
    http.parameters[@"deviceSystem"] = self.type;
    http.parameters[@"description"] = self.textView.text;
//    http.parameters[@"reappear"] = self.reproductionView.text;
    http.parameters[@"commitUser"] = [TLUser user].userId;
    
    if (self.quoteImagesView.selectedPhotos.count > 0) {
        ///需要上传照片
        self.count = self.quoteImagesView.selectedPhotos.count;
        [self postImageRequset];
        return;
    }
//    if (self.introduceTf.text) {
//        http.parameters[@"commitNote"] = self.introduceTf.text;
//
//    }

    [http postWithSuccess:^(id responseObject) {
        
        NSString *H5code = responseObject[@"data"];
        
        if (H5code) {
//            [self gohistory];
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            TLhistoryListVC *vc = [TLhistoryListVC new];
            [self.navigationController pushViewController:vc animated:YES];
//            [TLAlert alertWithMsg:@"问题反馈提交成功"];

        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        //        [TLProgressHUD dismiss];
        
    }];
    
    
    
}


- (void)postImageRequset
{
    
    
    NSMutableData *imgData;
    NSInteger count = self.quoteImagesView.selectedPhotos.count;
//    for (int i = 0; i < self.quoteImagesView.selectedPhotos.count; i++) {
        UIImage *im =self.quoteImagesView.selectedPhotos[count-self.count];
        
       imgData = (NSMutableData*)UIImageJPEGRepresentation(im, 0.1);
        
        TLUploadManager *manager = [TLUploadManager manager];
        
        manager.imgData = imgData;
            manager.image = im;
        self.count --;
        [manager getQuestionTokenShowView:self.view succes:^(NSString *key) {
            
            
            //        [self changeHeadIconWithKey:key imgData:imgData];
//            [TLAlert alertWithSucces:@"上传成功"]
            
            if (key) {
                
                [self.imageString addObject:key];
                if (self.count == 0) {
                  
                    // 上传图片名称 到后台
                    [self postImageStringWithArray:self.imageString];
                    return ;
                }
                
                [self postImageRequset];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
        
//    }
    
    //进行上传
   
}

- (void)postImageStringWithArray: (NSMutableArray *)arr
{
    
    TLNetworking *http = [TLNetworking new];
    
//    http.isUploadToken = NO;
    http.code = @"805100";
    http.parameters[@"deviceSystem"] = self.type;
    http.parameters[@"description"] = self.textView.text;
//    http.parameters[@"reappear"] = self.reproductionView.text;
    http.parameters[@"commitUser"] = [TLUser user].userId;
    
    if (self.imageString.count > 0) {
//        ///需要上传照片
//        self.count = self.quoteImagesView.selectedPhotos.count;
//        [self postImageRequset];
//        return;
        
       
        NSString *str = [self.imageString componentsJoinedByString:@"||"];
//        str = [str substringToIndex:str.length-2];
        http.parameters[@"pic"] = str;
        

    }
//    if (self.introduceTf.text) {
//        http.parameters[@"commitNote"] = self.introduceTf.text;
//
//    }
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *H5code = responseObject[@"data"];
        
        if (H5code) {
//            [self gohistory];
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            TLhistoryListVC *vc = [TLhistoryListVC new];
            [self.navigationController pushViewController:vc animated:YES];
            
            
//            [TLAlert alertWithMsg:@"问题反馈提交成功"];
            
            
        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        //        [TLProgressHUD dismiss];
        
    }];
    
}

- (void)back
{
    TLhistoryListVC *h = [TLhistoryListVC new];
    [self.navigationController pushViewController:h animated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
    
}

- (FilterView *)filterPicker {
    
    if (!_filterPicker) {
        
        MJWeakSelf;
        
        NSArray *textArr = @[@"iOS",
                             @"Android",
                             @"H5"

                             ];
        
        _filterPicker = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//        _filterPicker.backgroundColor = kWhiteColor;
        _filterPicker.title =   @"请选择客户端";
        
        _filterPicker.selectBlock = ^(NSInteger index) {
            
            NSString *text = textArr[index];
            weakSelf.typechange.text = text;
            if (index == 0) {
                weakSelf.type = @"iOS";
            }else if (index == 1){
                  weakSelf.type = @"Android";
            }else{
                weakSelf.type = @"H5";
            }
        };
        _filterPicker.tagNames = textArr;
    }
    
    return _filterPicker;
}


- (void)initCustomUi
{

    self.bgImage = [[UIScrollView alloc] init];
    self.bgImage.userInteractionEnabled = YES;
    self.bgImage.delegate = self;
    
//    [self.bgImage theme_setBackgroundColorIdentifier:BackColor moduleName:ColorName];
    self.bgImage.backgroundColor = kWhiteColor;
    [self.view  addSubview:self.bgImage];
    self.bgImage.scrollEnabled = YES;
    
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

    UILabel *_titleText = [UILabel labelWithFrame:CGRectZero textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(16) textColor:kHexColor(@"#333333")];
//    [_titleText theme_setTextIdentifier:LabelColor moduleName:ColorName];
    _titleText.textColor = kWhiteColor;
    _titleText.height = 44;
    _titleText.text = @"问题反馈";
    self.navigationItem.titleView = _titleText;
    
    
    

    
    self.historyLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    self.historyLable.text = @"历史反馈";
    self.historyLable.textAlignment = NSTextAlignmentRight;
    self.historyLable.userInteractionEnabled = YES;
    self.historyLable.font = Font(13);
//    self.historyLable.textColor = kBlackColor;
//    [self.historyLable theme_setTextColorIdentifier:LabelColor moduleName:ColorName];
    self.historyLable.textColor = kWhiteColor;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:self.historyLable]];

//    self.title = @"问题反馈";

    UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gohistory)];
    [self.historyLable addGestureRecognizer:ta];

    
    
}

- (void)gohistory
{
    TLhistoryListVC *vc = [TLhistoryListVC new];
    vc.title = @"历史反馈";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)initBodyView
{
    self.typeLab = [[UILabel alloc] init];
    
    self.typeLab.text = @"所在端";
    self.typeLab.textAlignment = NSTextAlignmentLeft;
//    self.historyLable.userInteractionEnabled = YES;
    self.typeLab.font = Font(14);
    self.typeLab.textColor = kBlackColor;
    [self.bgImage addSubview:self.typeLab];
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kHeight(30)));
        make.left.equalTo(self.bgImage.mas_left).offset(15);
    }];
    
    self.typeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.typeButton setImage:kImage(@"更多-灰色") forState:(UIControlStateNormal)];
    self.typeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.typeButton.titleLabel.textColor = kTextColor;
    self.typeButton.titleLabel.font = FONT(12);
    [self.typeButton addTarget:self action:@selector(history) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgImage addSubview:self.typeButton];
    [self.typeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kHeight(30)));
        make.right.equalTo(self.view.mas_right).offset(-15);

    }];
    
    UIView *lineView2 = [UIView new];
    lineView2.backgroundColor = kLineColor;

    [self.bgImage addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.typeLab.mas_bottom).offset(18);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@0.5);
        
    }];
    self.typechange = [[UILabel alloc] init];
    
    self.typechange.text = @"客户端";
    self.typechange.textAlignment = NSTextAlignmentLeft;
    //    self.historyLable.userInteractionEnabled = YES;
    self.typechange.font = Font(14);
    self.typechange.userInteractionEnabled = YES;
    self.typechange.textColor = kBlackColor;
//    [self.typechange theme_setTextColorIdentifier:LabelColor moduleName:ColorName];
    [self.bgImage addSubview:self.typechange];
    [self.typechange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.typeButton.mas_centerY);
        make.right.equalTo(self.typeButton.mas_left).offset(-15);
    }];
        UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(history)];
        [self.typechange addGestureRecognizer:ta];
//    return;

    self.Qintroduce = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    self.Qintroduce.text = @"问题描述（必填）";
 
    [self.bgImage addSubview:self.Qintroduce];
    
    [self.Qintroduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLab.mas_bottom).offset(30);
        make.left.equalTo(self.bgImage.mas_left).offset(15);
    }];
 
    TLTextView *textView = [[TLTextView alloc] initWithFrame:CGRectMake(15, kHeight(100), kScreenWidth - 30, 100)];
    textView.userInteractionEnabled = YES;
    textView.backgroundColor = kClearColor;
    textView.returnKeyType = UIReturnKeyDone;
    textView.font = [UIFont systemFontOfSize:15];
    textView.placholder = @"请详细描述一下问题";
//    textView.textColor = kHexColor([TLUser TextFieldTextColor]);
//    [textView setValue:kHexColor([TLUser TextFieldPlacColor]) forKeyPath:@"_placeholderLabel.color"];
    self.textView = textView;
    [self.bgImage addSubview:self.textView];
    
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = kHexColor(@"#E3E3E3");
    lineView.backgroundColor = kLineColor;
//    [lineView theme_setBackgroundColorIdentifier:LineViewColor moduleName:ColorName];
    lineView.frame = CGRectMake(15, textView.yy+5, kScreenWidth - 30, 0.5);
    [self.bgImage addSubview:lineView];


}




- (void)done
{
    
    [self.view endEditing:YES];
    
}

- (void)history
{
    NSLog(@"点击历史");
    [self.filterPicker show];
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self done];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
//    [self.reproductionView resignFirstResponder];
    [self.view endEditing:YES];
    
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
