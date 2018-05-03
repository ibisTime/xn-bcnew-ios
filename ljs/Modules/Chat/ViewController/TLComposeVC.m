//
//  TLComposeVC.m
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/4.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "TLComposeVC.h"
//#import "TLEmoticonInputView.h"
#import "TLComposeTextView.h"
#import "TLComposeToolBar.h"
//#import "TLEmoticonHelper.h"
#import "TLTextStorage.h"

#import "SVProgressHUD.h"
#import "MLLinkLabel.h"
#import "NSString+MLExpression.h"
#import "UIImage+Custom.h"

#import "TLPhotoChooseView.h"
//#import "TLPlateChooseView.h"

//#import "TLImagePicker.h"
//#import "CSWSmallPlateModel.h"
#import "QNUploadManager.h"
#import "QNConfiguration.h"
#import "QNResponseInfo.h"

//#import "CSWAtUserSearchVC.h"
#import "TLImagePickerController.h"

//#import "TLNavigationController.h"
//#import "CanlePublishTipView.h"
#import "NavigationController.h"

#define TITLE_MARGIN 10
#define TEXT_MARGIN 5

@interface TLComposeVC ()<UITextViewDelegate,TLImagePickerControllerDelegate>

//@property (nonatomic, strong) TLEmoticonInputView *emoticonInputView;
@property (nonatomic, strong) TLComposeToolBar *toolBar;

@property (nonatomic, strong) TLComposeTextView *titleTextView;

@property (nonatomic, strong) TLComposeTextView *composeTextView;
@property (nonatomic, strong) UIScrollView *bgScrollView;

//用于展示已经选择图片的视图
@property (nonatomic, strong) TLPhotoChooseView *photoChooseView;
//@property (nonatomic, strong) TLImagePicker *imagePicker;

@property (nonatomic, strong) UIButton *titleBtn;//顶部板块吊起
@property (nonatomic, strong) UILabel *titleLbl;

//@property (nonatomic, strong) TLPlateChooseView *plateChooseView;
//取消发布
//@property (nonatomic, strong) CanlePublishTipView *tipView;

//数据
//@property (nonatomic, copy) NSArray <CSWSmallPlateModel *>*smallPlateModelRoom;

@property (nonatomic, strong) NSAttributedString *contentAttributedString;

@end

@implementation TLComposeVC
{
    dispatch_group_t _uploadGroup;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"@"]) {
        
        //        CSWAtUserSearchVC *searchUserVC = [[CSWAtUserSearchVC alloc] init];
        //        NavigationController *navCtrl = [[NavigationController alloc] initWithRootViewController:searchUserVC];
        //
        //        [searchUserVC setChooseUserAction:^(NSString *nickname){
        //
        //            [self.composeTextView insertText:[NSString stringWithFormat:@"@%@ ",nickname]];
        //            [self.composeTextView becomeFirstResponder];
        //
        //        }];
        //
        //        [self presentViewController:navCtrl animated:YES completion:nil];
        
        return NO;
        
    } else {
        
        return YES;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:SVProgressHUDDidReceiveTouchEventNotification object:nil];
    //键盘通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _uploadGroup = dispatch_group_create();
    
    //
    [UIBarButtonItem addRightItemWithTitle:@"发布" frame:CGRectMake(0, 0, 40, 40) vc:self action:@selector(send)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    btn.contentMode = UIViewContentModeScaleToFill;
    btn.frame = CGRectMake(0, 0, 16, 16);
    [btn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    //    [UIBarButtonItem addLeftItemWithImageName:@"cancel" frame:CGRectMake(0, 0, 20, 20) vc:self action:@selector(cancle)];
    
    //背景
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - TOOLBAR_EFFECTIVE_HEIGHT)];
    self.bgScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.bgScrollView];
    //    self.bgScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight - 64 - 0 + 10);
    
    //
    self.view.backgroundColor = [UIColor whiteColor];
    self.bgScrollView.backgroundColor = [UIColor whiteColor];
    
    
    //板块选择
//    self.navigationItem.titleView = self.titleBtn;
//    [self.titleBtn addTarget:self action:@selector(changeTopic) forControlEvents:UIControlEventTouchUpInside];
    
    
    //标题栏--可变
    self.titleTextView = [[TLComposeTextView alloc] initWithFrame:CGRectMake(0, 5, self.bgScrollView.width, [FONT(18) lineHeight] + 2*TITLE_MARGIN)];
    self.titleTextView.font = FONT(18);
    self.titleTextView.placholder = @"标题";
    self.titleTextView.delegate = self;
    self.titleTextView.placeholderLbl.y = 10;
    self.titleTextView.placeholderLbl.textColor = [UIColor colorWithHexString:@"#999999"];
    self.titleTextView.textContainerInset = UIEdgeInsetsMake(TITLE_MARGIN, TEXT_MARGIN, TITLE_MARGIN, TEXT_MARGIN);
    [self.bgScrollView addSubview:self.titleTextView];
    
    //线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lineColor];
    [self.bgScrollView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleTextView.mas_bottom);
        make.left.equalTo(self.titleTextView.mas_left);
        make.width.equalTo(self.titleTextView.mas_width);
        make.height.mas_equalTo(1);
    }];
    
    
    self.titleTextView.hidden = YES;
    
    line.hidden = YES;
    //-----//
    //内容栏
//    self.composeTextView.y = self.titleTextView.yy + 1;
    self.composeTextView.y = 0;

    self.composeTextView.placeholderLbl.textColor = [UIColor colorWithHexString:@"#999999"];
    self.composeTextView.font = FONT(15);
    self.composeTextView.textColor = [UIColor textColor];
    self.composeTextView.textContainerInset = UIEdgeInsetsMake(TEXT_MARGIN, TEXT_MARGIN, TEXT_MARGIN, TEXT_MARGIN);
    [self.bgScrollView addSubview:self.composeTextView];
    
    //    if (_statusType == ArticleStatusTypeSave) {
    //
    //        self.titleTextView.text = _poseInfo.title;
    //
    //        self.contentAttributedString = [TLEmoticonHelper convertEmoticonStrToNormalString:_poseInfo.content];
    //
    //        self.composeTextView.attributedText = self.contentAttributedString;
    //    }
    
#pragma mark- 图片选择
    TLPhotoChooseView *photoChooseView = [[TLPhotoChooseView alloc] initWithFrame:CGRectMake(10, self.composeTextView.yy, kScreenWidth - 20, kScreenWidth - 20)];
    self.photoChooseView = photoChooseView;
    [self.bgScrollView addSubview:photoChooseView];
    
    [photoChooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.composeTextView.mas_bottom).offset(10);
        make.centerX.equalTo(self.bgScrollView.mas_centerX);
        make.width.mas_equalTo(kScreenWidth - 20);
        make.height.mas_equalTo(kScreenWidth - 20);
        
    }];
    
    if (photoChooseView.yy + 20 < self.bgScrollView.height) {
        
        self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width, self.bgScrollView.height + 20);
        
    } else {
        
        self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width, photoChooseView.yy + 20);
    }
    
    
#pragma mark- 工具栏
    TLComposeToolBar *toolBar = [[TLComposeToolBar alloc] initWithFrame:CGRectMake(0, kScreenHeight - TOOLBAR_EFFECTIVE_HEIGHT - 64, kScreenWidth, 0)];
    
    //解决切换 效果差
    toolBar.height = 350;
    [self.view addSubview:toolBar];
    self.toolBar = toolBar;
    
    
#pragma mark- 切换工具
    
    BaseWeakSelf;
    
    toolBar.changeType = ^(ChangeType type){
        
        if (type == ChangeTypeEmoticon) {
            
            
            
        } else if (type == ChangeTypePhoto) {
            
            
            TLImagePickerController *imagePickerController = [[TLImagePickerController alloc] init];
            imagePickerController.pickerDelegate = self;
            
            //要把已经选中的图片回源，显示已经展示的图片
            imagePickerController.replacePhotoItems = self.photoChooseView.currentPhotoItems;
            
            //
            [weakSelf presentViewController:imagePickerController animated:YES completion:nil];
            
        }
        
        
    };
    //    __weak typeof(self) weakself = self;
    //    toolBar.changeType = ^(ChangeType type){
    //
    //        if (type == ChangeTypeEmoticon) {
    //
    //            if (!weakself.composeTextView.inputView) {
    //
    //                weakself.composeTextView.inputView = weakself.emoticonInputView;
    //                [weakself.composeTextView reloadInputViews];
    //                [weakself.composeTextView becomeFirstResponder];
    //
    //            } else {
    //
    //                weakself.composeTextView.inputView = nil;
    //                [weakself.composeTextView reloadInputViews];
    //                [weakself.composeTextView becomeFirstResponder];
    //
    //            }
    //
    //        } else if (type == ChangeTypePhoto) {
    //
    //
    //            TLImagePickerController *imagePickerController = [[TLImagePickerController alloc] init];
    //            imagePickerController.pickerDelegate = self;
    //
    //            //要把已经选中的图片回源，显示已经展示的图片
    //            imagePickerController.replacePhotoItems = self.photoChooseView.currentPhotoItems;
    //
    //            //
    //            [self presentViewController:imagePickerController animated:YES completion:nil];
    //
    //        } else { // At
    //
    //            CSWAtUserSearchVC *searchUserVC = [[CSWAtUserSearchVC alloc] init];
    //            NavigationController *navCtrl = [[NavigationController alloc] initWithRootViewController:searchUserVC];
    //
    //            [searchUserVC setChooseUserAction:^(NSString *nickname){
    //
    //                [self.composeTextView insertText:[NSString stringWithFormat:@"@%@ ",nickname]];
    //
    //                [self.composeTextView becomeFirstResponder];
    //
    //            }];
    //
    //            [self presentViewController:navCtrl animated:YES completion:nil];
    //
    //        }
    //
    //
    //    };
    
    //#pragma mark- 板块选择
    //    [self.plateChooseView setChoosePlate:^(NSInteger idx,CSWSmallPlateModel *plateModel){
    //
    //        weakself.titleLbl.text = plateModel.name;
    //
    //    }];
    //
    //    //获取板块,小版块
    //    TLNetworking *http = [TLNetworking new];
    //    http.showView = self.view;
    //    http.code = @"610047";
    //    http.parameters[@"companyCode"] = [CSWCityManager manager].currentCity.code;
    //    [http postWithSuccess:^(id responseObject) {
    //
    //        self.smallPlateModelRoom = [CSWSmallPlateModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
    //
    //        if (self.smallPlateModelRoom.count > 0) {
    //
    //            if (_isPlatePush) {
    //
    //                [self selectPlateWithName:self.plateName];
    //
    //            } else {
    //
    //                self.titleLbl.text = @"选择版块";
    //            }
    //
    //        } else {
    //
    //            [TLAlert alertWithInfo:@"没有可选板块"];
    //        }
    //
    //
    //    } failure:^(NSError *error) {
    //
    //
    //    }];
    
#pragma mark- 图片添加
    [self.photoChooseView setAddAction:^{
        
        TLImagePickerController *imagePickerController = [[TLImagePickerController alloc] init];
        imagePickerController.pickerDelegate = weakSelf;
        //要把已经选中的图片回源，显示已经展示的图片
        imagePickerController.replacePhotoItems = weakSelf.photoChooseView.currentPhotoItems;
        //
        [weakSelf presentViewController:imagePickerController animated:YES completion:nil];
        
        
    }];
    
    //    [self initTipView];
    
    
}

//默认是当前进入的版块
//- (void)selectPlateWithName:(NSString *)name {
//
//    NSInteger index = 0;
//
//    for (int i = 0; i < self.smallPlateModelRoom.count; i++) {
//
//        CSWSmallPlateModel *model = self.smallPlateModelRoom[i];
//
//        if ([model.name isEqualToString:name]) {
//
//            index = i;
//        }
//    }
//
//    self.smallPlateModelRoom[index].isSelected = YES;
//    self.titleLbl.text = self.smallPlateModelRoom[index].name;
//}

#pragma mark- 图片选择的代理
- (void)imagePickerControllerDidCancel:(TLImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)imagePickerController:(TLImagePickerController *)picker didFinishPickingWithImages:(NSArray <UIImage *> *)imgs chooseItems:(NSMutableArray<TLPhotoChooseItem *> *)items{
    
    //--//
    [self.photoChooseView finishChooseWithImgs:items];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

//- (TLImagePicker *)imagePicker {
//
//    if (!_imagePicker) {
//
//        _imagePicker = [[TLImagePicker alloc] initWithVC:self];
//        __weak typeof(self) weakself = self;
//        _imagePicker.pickFinish = ^(NSDictionary *info,UIImage *img) {
//
//            UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
//            [weakself.photoChooseView beginChooseWithImg:image];
//
//        };
//
//    }
//    return _imagePicker;
//
//}


- (void)textViewDidEndEditing:(UITextView *)textView {
    
    
    
}

#pragma mark-
- (void)textViewDidChange:(UITextView *)textView {
    
    if ([textView isEqual:self.titleTextView] && textView.text) {//titile
        
        CGSize size = [textView.text calculateStringSize:CGSizeMake(textView.width - 2*TEXT_MARGIN, MAXFLOAT) font:textView.font];
        
        //         CGSize size = [textView sizeThatFits:CGSizeMake(textView.width - 10, MAXFLOAT)];
        
        if ((size.height + 2*TITLE_MARGIN) > ([textView.font lineHeight] + 2*TITLE_MARGIN) ) {
            
            textView.height = size.height + 2*TITLE_MARGIN;
            
        } else {
            
            textView.height = [textView.font lineHeight] + 2*TITLE_MARGIN;
            
        }
        
        self.composeTextView.y = self.titleTextView.yy + 1;
        
    } else {
        
        //内容
        CGSize size = [textView sizeThatFits:CGSizeMake(textView.width - 10, MAXFLOAT)];
        if (size.height + 10 > COMPOSE_ORG_HEIGHT) {
            
            textView.height = size.height + 10;
            
        } else  {
            
            textView.height = COMPOSE_ORG_HEIGHT;
        }
        
    }
    
    if (self.composeTextView.yy + kScreenWidth - 20 > (kScreenHeight - 64 - TOOLBAR_EFFECTIVE_HEIGHT) + 10) {
        
        self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width, self.composeTextView.yy + kScreenWidth + 20);
    } else {
        
        self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width, self.bgScrollView.height + 20);
    }
    
}



//#pragma mark- 改变板块
//- (void)changeTopic {
//
//    //--
//    if (self.plateChooseView.isShow) {
//
//        [self.plateChooseView dismiss];
//
//    } else {
//
//        self.plateChooseView.plateModelRoom = self.smallPlateModelRoom;
//        [self.plateChooseView show];
//
//    }
//
//}

#pragma mark - Events

- (void)clickBack {

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- 发布

- (void)articleStatus {
    
//    __block NSString *plateCode = nil;
    //    [self.smallPlateModelRoom enumerateObjectsUsingBlock:^(CSWSmallPlateModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        if (obj.isSelected) {
    //            plateCode = obj.code;
    //        }
    //    }];
    
    if (![[self.composeTextView.attributedText string] valid]) {
        [TLProgressHUD showErrorWithStatus:@"帖子内容不能为空"];
        return ;
    }
    
//    if (![plateCode valid]) {
//        
//        [TLProgressHUD showErrorWithStatus:@"请选择板块"];
//        return ;
//        
//    }
    
    NSMutableString *plainStr = [self.composeTextView.attributedText string].mutableCopy;
    
    //倒叙遍历,emjio
    //    [self.composeTextView.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.composeTextView.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
    //
    //        if ([value isKindOfClass:[TLTextAttachment class]]) {
    //            TLTextAttachment *textAttachment = (TLTextAttachment *)value;
    //
    //            [plainStr replaceCharactersInRange:NSMakeRange(range.location, 1) withString:textAttachment.emoticon.chs];
    //
    //        }
    //        else if ([value isKindOfClass:[NSTextAttachment class]]) {
    //
    //
    //
    //        }
    //
    //    }];
    
    
    
    
    if (self.photoChooseView.currentPhotoItems.count) {
        //图片上传
        //获取图片名称
        
        [self.photoChooseView getImgs:^(NSArray<UIImage *> *imgs) {
            
            NSMutableArray *imgNames = [[NSMutableArray alloc] initWithCapacity:imgs.count];
            __block NSInteger uploadSuccessCount = 0;
            [imgs enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [imgNames addObject:[obj getUploadImgName]];
                
            }];
            
            
            //---//
            [TLProgressHUD showWithStatus:@"图片上传中"];
            TLNetworking *getUploadToken = [TLNetworking new];
            getUploadToken.code = IMG_UPLOAD_CODE;
            getUploadToken.parameters[@"token"] = [TLUser user].token;
            [getUploadToken postWithSuccess:^(id responseObject) {
                
                //
                NSString *token = responseObject[@"data"][@"uploadToken"];
                //
                QNUploadManager *qnUoloadManange = [[QNUploadManager alloc] initWithConfiguration:[QNConfiguration build:^(QNConfigurationBuilder *builder) {
                    
                    builder.zone = [QNZone zone2];
                    
                }]];
                //可直接上传PHAsset 以后优化
                
                [imgs enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    dispatch_group_enter(_uploadGroup);
                    [qnUoloadManange putData:UIImageJPEGRepresentation(obj, 1) key:imgNames[idx] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                        
                        dispatch_group_leave(_uploadGroup);
                        
                        if (key && !info.error) {
                            uploadSuccessCount ++;
                        }
                        
                    } option:nil];
                    
                }];
                
                
                dispatch_group_notify(_uploadGroup, dispatch_get_main_queue(), ^{
                    
                    [TLProgressHUD dismiss];

                    if (uploadSuccessCount) {
                        //拼接图片
                        NSString *pic = [imgNames componentsJoinedByString:@"||"];
                        [self composeWithContentStr:plainStr picStr:pic plateCode:nil];
                        
                    } else {
                        
                        [TLAlert alertWithError:@"图片上传失败"];
                        
                    }
                    
                });
                
                
            } failure:^(NSError *error) {
                
                [TLProgressHUD dismiss];
                
            }];
            
            
        }];
        
        
    } else {
        
        [TLAlert alertWithSucces:@"发布失败,请添加图片"];
//        [self composeWithContentStr:plainStr picStr:nil plateCode:nil];
        
        
    }
    
    
    //    _lbl.attributedText = [TLEmoticonHelper convertEmoticonStrToAttributedString:plainStr];
}

- (void)send {
    
    _statusType = ArticleStatusTypePublish;
    
    [self.view endEditing:YES];
    
    [self articleStatus];
    
}

- (void)composeWithContentStr:(NSString *)contentStr picStr:(NSString *)picStr plateCode:(NSString *)plateCode {
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"621010";
    http.parameters[@"title"] = @"标题";
    http.parameters[@"content"] = contentStr;
    http.parameters[@"pic"] = picStr;
    http.parameters[@"publisher"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        if (self.composeSucces) {
            
            self.composeSucces();
            
        }
        
        NSString *textStr = _statusType == ArticleStatusTypePublish ? @"发布成功": @"保存成功";
        [TLAlert alertWithSucces:textStr];
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
}

//#pragma mark- 取消发布

//- (void)initTipView {
//
//    NSArray *titles = @[@"保存草稿", @"放弃编辑", @"取消"];
//    _tipView = [[CanlePublishTipView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) titles:titles];
//    [self.navigationController.view addSubview:_tipView];
//
//    CSWWeakSelf;
//    _tipView.eventBlock = ^(NSInteger index) {
//        if (index == 0) {
//            [weakSelf saveArticle];
//        }
//        else if (index == 1) {
//
//            [weakSelf quitArticle];
//        }
//    };
//
//}

//- (void)saveArticle {
//
//    _statusType = ArticleStatusTypeSave;
//
//    [self articleStatus];
//    //    [self saveArticleWithRelease:NO];
//}

- (void)quitArticle {
    
    //    [self.plateChooseView dismiss];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    //    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancle {
    
    [self.view endEditing:YES];
    
    if (_composeTextView.text.length ==0 && self.titleTextView.text.length == 0) {
        
        //        [self.plateChooseView dismiss];
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
        return;
    }
    
    //    [_tipView show];
    
    
}


#pragma mark- 表情视图，和事件处理
//- (TLEmoticonInputView *)emoticonInputView {
//
//    if (!_emoticonInputView) {
//
//        TLEmoticonInputView *emoticonInputView = [TLEmoticonInputView shareView];
//
//        _emoticonInputView = emoticonInputView;
//
//        emoticonInputView.editAction = ^(BOOL isDelete, TLEmoticon *emoction){
//
//            if (isDelete) {
//
//                if (self.composeTextView.attributedText.length == 0) {
//
//                    return ;
//                }
//
//                [self.composeTextView deleteEmoticon:emoction];
//
//                return ;
//            }
//            [self.composeTextView appendEmoticon:emoction];
//
//        };
//
//    }
//
//    return _emoticonInputView;
//
//}


- (void)keyboardWillAppear:(NSNotification *)notification {
    
    //获取键盘高度
    CGFloat duration =  [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect keyBoardFrame = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    if (self.titleTextView.isFirstResponder) {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.toolBar.y = kScreenHeight - TOOLBAR_EFFECTIVE_HEIGHT - 64;
            
        }];
        return;
    }
    
    [UIView animateWithDuration:duration delay:0 options: 458752 | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.toolBar.y = CGRectGetMinY(keyBoardFrame) - TOOLBAR_EFFECTIVE_HEIGHT - 64;
        
        
    } completion:NULL];
    
    
}


- (TLComposeTextView *)composeTextView {
    
    if (!_composeTextView) {
        
        //textConiter
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(kScreenWidth, MAXFLOAT)];
        
        //layoutManager
        NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
        [layoutManager addTextContainer:textContainer];
        
        //textStorage
        TLTextStorage *textStorage = [[TLTextStorage alloc] init];
        [textStorage addLayoutManager:layoutManager];
        [textStorage setAttributedString:[[NSAttributedString alloc] init]];
        
        //
        TLComposeTextView *editTextView = [[TLComposeTextView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, COMPOSE_ORG_HEIGHT) textContainer:textContainer];
        //        editTextView.scrollEnabled = NO;
        editTextView.keyboardType = UIKeyboardTypeTwitter;
        editTextView.textContainerInset = UIEdgeInsetsMake(5, 5, 0, 5);
        editTextView.delegate = self;
        editTextView.font = [UIFont systemFontOfSize:15];
        editTextView.placholder = @"这一刻的想法...";
        _composeTextView = editTextView;
        
        textStorage.textView = editTextView;
    }
    
    return _composeTextView;
    
}

//- (TLPlateChooseView *)plateChooseView {
//
//    if (!_plateChooseView) {
//
//        _plateChooseView = [[TLPlateChooseView alloc] init];
//    }
//
//    return _plateChooseView;
//
//}

- (UIButton *)titleBtn {
    
    if (!_titleBtn) {
        _titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 120, 30)];
        
        UILabel *titlelbl = [UILabel labelWithFrame:CGRectZero
                                       textAligment:NSTextAlignmentCenter
                                    backgroundColor:[UIColor clearColor]
                                               font:FONT(18)
                                          textColor:[UIColor whiteColor]];
        [_titleBtn addSubview:titlelbl];
        [titlelbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_titleBtn.mas_centerX);
            make.bottom.equalTo(_titleBtn.mas_bottom).offset(-4);
            
        }];
        titlelbl.text = @"选择板块";
        self.titleLbl = titlelbl;
        
        //
        UIImageView *arrawView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headline_location_arrow"]];
        [_titleBtn addSubview:arrawView];
        [arrawView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titlelbl.mas_right).offset(7);
            make.width.mas_equalTo(14);
            make.height.mas_equalTo(8);
            make.centerY.equalTo(titlelbl.mas_centerY);
        }];
        
    }
    return _titleBtn;
    
}

@end
