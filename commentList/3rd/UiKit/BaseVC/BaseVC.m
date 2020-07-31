
//
//  BaseVC.m
//  gtp
//
//  Created by GT on 2019/1/8.
//  Copyright © 2019 GT. All rights reserved.
//

#import "BaseVC.h"
#import "SDWebImage-umbrella.h"//不支持图片后处理
#import "UIImage+GIF.h"

@interface BaseVC ()
<
JXCategoryListContentViewDelegate
>

@property(nonatomic,strong)UIImage *image;
@property(nonatomic,strong)NSData *data;

@property(nonatomic,copy)MKDataBlock willComingBlock;
@property(nonatomic,copy)MKDataBlock didComingBlock;
@property(nonatomic,copy)MKDataBlock willBackBlock;
@property(nonatomic,copy)MKDataBlock didBackBlock;
@property(nonatomic,copy)MKDataBlock picBlock;
@property(nonatomic,copy)MKDataBlock brStringPickerViewBlock;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)MKDataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,strong)AFNetworkReachabilityManager *afNetworkReachabilityManager;

@end

@implementation BaseVC

- (void)dealloc{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)init{
    if (self = [super init]) {

    }return self;
}

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                 comingStyle:(ComingStyle)comingStyle
           presentationStyle:(UIModalPresentationStyle)presentationStyle
               requestParams:(nullable id)requestParams
                     success:(MKDataBlock)block
                    animated:(BOOL)animated{
    BaseVC *vc = BaseVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    switch (comingStyle) {
        case ComingStyle_PUSH:{
            if (rootVC.navigationController) {
                vc.isPush = YES;
                vc.isPresent = NO;
                [rootVC.navigationController pushViewController:vc
                                                       animated:animated];
            }else{
                vc.isPush = NO;
                vc.isPresent = YES;
                [rootVC presentViewController:vc
                                     animated:animated
                                   completion:^{}];
            }
        }break;
        case ComingStyle_PRESENT:{
            vc.isPush = NO;
            vc.isPresent = YES;
            //iOS_13中modalPresentationStyle的默认改为UIModalPresentationAutomatic,而在之前默认是UIModalPresentationFullScreen
            vc.modalPresentationStyle = presentationStyle;
            [rootVC presentViewController:vc
                                 animated:animated
                               completion:^{}];
        }break;
        default:
            NSLog(@"错误的推进方式");
            break;
    }return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES
                                             animated:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES
                                             animated:NO];
    printf("retain count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));//打印对象的引用计数器
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;//状态栏字体白色 UIStatusBarStyleDefault黑色
}

#pragma mark —— 截取 UIViewController 手势返回事件 这两个方法进出均调用，只不过进场的时候parent有值，出场的时候是nil
- (void)willMoveToParentViewController:(UIViewController*)parent{
    [super willMoveToParentViewController:parent];
    if (parent) {
        NSLog(@"进场:%s,%@",__FUNCTION__,parent);
        if (self.willComingBlock) {//即将进来
            self.willComingBlock(parent);
        }
    }else{
        NSLog(@"出场:%s,%@",__FUNCTION__,parent);
        if (self.willBackBlock) {//即将出去
            self.willBackBlock(parent);
        }
    }
    [self.navigationController setNavigationBarHidden:YES
                                             animated:NO];
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if(parent){
        NSLog(@"进场:%s,%@",__FUNCTION__,parent);
        if (self.didComingBlock) {//已经进来
            self.didComingBlock(parent);
        }
    }else{
        NSLog(@"出场:%s,%@",__FUNCTION__,parent);
//        NSLog(@"页面pop成功了");
        if (self.didBackBlock) {//已经出去
            self.didBackBlock(parent);
        }
    }
    [self.navigationController setNavigationBarHidden:YES
                                             animated:NO];
}

-(void)VCwillComingBlock:(MKDataBlock)block{//即将进来
    self.willComingBlock = block;
}

-(void)VCdidComingBlock:(MKDataBlock)block{//已经进来
    self.didComingBlock = block;
}

-(void)VCwillBackBlock:(MKDataBlock)block{//即将出去
    self.willBackBlock = block;
}

-(void)VCdidBackBlock:(MKDataBlock)block{//已经出去
    self.didBackBlock = block;
}

-(void)GettingPicBlock:(MKDataBlock)block{//点选的图片
    self.picBlock = block;
}

-(void)BRStringPickerViewBlock:(MKDataBlock)block{
    self.brStringPickerViewBlock = block;
}
#pragma mark —— JXCategoryListContentViewDelegate
/**
 如果列表是VC，就返回VC.view
 如果列表是View，就返回View自己

 @return 返回列表视图
 */
- (UIView *)listView{
    return self.view;
}

- (void)AFNReachability {
    //2.监听网络状态的改变
    /*
     AFNetworkReachabilityStatusUnknown          = 未知
     AFNetworkReachabilityStatusNotReachable     = 没有网络
     AFNetworkReachabilityStatusReachableViaWWAN = 3G
     AFNetworkReachabilityStatusReachableViaWiFi = WIFI
     */
    @weakify(self)
    if (!_isRequestFinish) {
        //如果没有请求完成就检测网络
        [self.afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            @strongify(self)
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    DLog(@"未知网络");
                    if (self.UnknownNetWorking) {
                        self.UnknownNetWorking();
                    }
                    if (self.ReachableNetWorking) {
                        self.ReachableNetWorking();
                    }
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    DLog(@"3G网络");//不是WiFi的网络都会识别成3G网络.比如2G/3G/4G网络
                    if (self.ReachableViaWWANNetWorking) {
                        self.ReachableViaWWANNetWorking();
                    }
                    if (self.ReachableNetWorking) {
                        self.ReachableNetWorking();
                    }
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    DLog(@"WIFI网络");
                    if (self.ReachableViaWiFiNetWorking) {
                        self.ReachableViaWiFiNetWorking();
                    }
                    if (self.ReachableNetWorking) {
                        self.ReachableNetWorking();
                    }
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    DLog(@"没有网络");
                    if (self.NotReachableNetWorking) {
                        self.NotReachableNetWorking();
                    }
                    break;
                default:
                    break;
            }}];
    }
    [self.afNetworkReachabilityManager startMonitoring];
}

-(void)alertControllerStyle:(AlertControllerStyle)alertControllerStyle
         showAlertViewTitle:(nullable NSString *)title
                    message:(nullable NSString *)message
            isSeparateStyle:(BOOL)isSeparateStyle
                btnTitleArr:(NSArray <NSString*>*)btnTitleArr
             alertBtnAction:(NSArray <NSString*>*)alertBtnActionArr{
    switch (alertControllerStyle) {
        case SYS_AlertController:{
            @weakify(self)
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                     message:message
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            for (int i = 0; i < alertBtnActionArr.count; i++) {
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:btnTitleArr[i]
                                                                   style:isSeparateStyle ? (i == alertBtnActionArr.count - 1 ? UIAlertActionStyleCancel : UIAlertActionStyleDefault) : UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     @strongify(self)
                                                                     [self performSelector:NSSelectorFromString((NSString *)alertBtnActionArr[i])
                                                                                withObject:Nil];
                                                                 }];
                [alertController addAction:okAction];
            }
            [self presentViewController:alertController
                               animated:YES
                             completion:nil];
        }break;
        case YX_AlertController:{
            @weakify(self)
            YXAlertController *alertController = [YXAlertController alertControllerWithTitle:title
                                                                                     message:message
                                                                                       style:YXAlertControllerStyleAlert];
            //自定义颜色设置
//            alertController.layout.doneActionTitleColor = [UIColor redColor];
//            alertController.layout.cancelActionBackgroundColor = [UIColor whiteColor];
//            alertController.layout.doneActionBackgroundColor = [UIColor yellowColor];
//            alertController.layout.lineColor = [UIColor redColor];
//            alertController.layout.topViewBackgroundColor = [UIColor orangeColor];
//            alertController.layout.titleColor = [UIColor whiteColor];
//            [alertController layoutSettings];
            for (int i = 0; i < alertBtnActionArr.count; i++) {
                YXAlertAction *okAction = [YXAlertAction actionWithTitle:btnTitleArr[i]
                                                                   style:isSeparateStyle ? (i == alertBtnActionArr.count - 1 ? YXAlertActionStyleCancel : YXAlertActionStyleDefault) : YXAlertActionStyleDefault
                                                                 handler:^(YXAlertAction * _Nonnull action) {
                                                                     @strongify(self)
                                                                     [self performSelector:NSSelectorFromString((NSString *)alertBtnActionArr[i])
                                                                                withObject:Nil];
                                                                 }];
                [alertController addAction:okAction];
            }
            [self presentViewController:alertController
                               animated:YES
                             completion:nil];
        }break;
        default:
            break;
    }
}

-(void)alertControllerStyle:(AlertControllerStyle)alertControllerStyle
       showActionSheetTitle:(nullable NSString *)title
                    message:(nullable NSString *)message
            isSeparateStyle:(BOOL)isSeparateStyle
                btnTitleArr:(NSArray <NSString*>*)btnTitleArr
             alertBtnAction:(NSArray <NSString*>*)alertBtnActionArr
                     sender:(nullable UIControl *)sender{
    UIViewController *vc = nil;
    switch (alertControllerStyle) {
        case SYS_AlertController:{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                     message:message
                                                                              preferredStyle:UIAlertControllerStyleActionSheet];
            vc = alertController;
            @weakify(self)
            for (int i = 0; i < alertBtnActionArr.count; i++) {
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:btnTitleArr[i]
                                                                   style:isSeparateStyle ? (i == alertBtnActionArr.count - 1 ? UIAlertActionStyleCancel : UIAlertActionStyleDefault) : UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     @strongify(self)
                                                                     [self performSelector:NSSelectorFromString((NSString *)alertBtnActionArr[i])
                                                                                withObject:Nil];
                                                                 }];
                [alertController addAction:okAction];
            }
        } break;
        case YX_AlertController:{
            YXAlertController *alertController = [YXAlertController alertControllerWithTitle:title
                                                                                     message:message
                                                                                       style:YXAlertControllerStyleActionSheet];
            vc = alertController;
            //自定义颜色设置
//            alertController.layout.doneActionTitleColor = [UIColor redColor];
//            alertController.layout.cancelActionBackgroundColor = [UIColor whiteColor];
//            alertController.layout.doneActionBackgroundColor = [UIColor yellowColor];
//            alertController.layout.lineColor = [UIColor redColor];
//            alertController.layout.topViewBackgroundColor = [UIColor orangeColor];
//            alertController.layout.titleColor = [UIColor whiteColor];
//            [alertController layoutSettings];
            @weakify(self)
            for (int i = 0; i < alertBtnActionArr.count; i++) {
                YXAlertAction *okAction = [YXAlertAction actionWithTitle:btnTitleArr[i]
                                                                   style:isSeparateStyle ? (i == alertBtnActionArr.count - 1 ? YXAlertActionStyleCancel : YXAlertActionStyleDefault) : YXAlertActionStyleDefault
                                                                 handler:^(YXAlertAction * _Nonnull action) {
                                                                     @strongify(self)
                                                                     [self performSelector:NSSelectorFromString((NSString *)alertBtnActionArr[i])
                                                                                withObject:Nil];
                                                                 }];
                [alertController addAction:okAction];
            }
        } break;
        default:
            break;
    }
    UIPopoverPresentationController *popover = vc.popoverPresentationController;
    if (popover){
        popover.sourceView = sender;
        popover.sourceRect = sender.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    [self presentViewController:vc
                       animated:YES
                     completion:nil];
}

-(void)showLoginAlertView{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Login"
                                                                             message:@"Enter Your Account Info Below"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self)
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        @strongify(self)
        textField.placeholder = @"username";
        [textField addTarget:self
                      action:@selector(alertUserAccountInfoDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        @strongify(self)
        textField.placeholder = @"password";
        textField.secureTextEntry = YES;
        [textField addTarget:self
                      action:@selector(alertUserAccountInfoDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             NSLog(@"Cancel Action");
                                                         }];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"Login"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            UITextField *userName = alertController.textFields.firstObject;
                                                            UITextField *password = alertController.textFields.lastObject;
                                                            // 输出用户名 密码到控制台
                                                            NSLog(@"username is %@, password is %@",userName.text,password.text);
                                                        }];
    loginAction.enabled = NO;   // 禁用Login按钮
    [alertController addAction:cancelAction];
    [alertController addAction:loginAction];
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

- (void)alertUserAccountInfoDidChange:(UITextField *)sender{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController){
        NSString *userName = alertController.textFields.firstObject.text;
        NSString *password = alertController.textFields.lastObject.text;
        UIAlertAction *loginAction = alertController.actions.lastObject;
        if (userName.length > 3 &&
            password.length > 6)
            // 用户名大于3位，密码大于6位时，启用Login按钮。
            loginAction.enabled = YES;
        else
            // 用户名小于等于3位，密码小于等于6位，禁用Login按钮。
            loginAction.enabled = NO;
    }
}

-(void)locateTabBar:(NSInteger)index{//backHome
    if (self.navigationController.tabBarController.selectedIndex == index) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        self.navigationController.tabBarController.hidesBottomBarWhenPushed = NO;
        self.navigationController.tabBarController.selectedIndex = index;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
//设置状态栏背景颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
//访问相册 —— 选择图片
-(void)choosePic{
    @weakify(self)
    [ECAuthorizationTools checkAndRequestAccessForType:ECPrivacyType_Photos
                                          accessStatus:^(ECAuthorizationStatus status,
                                                         ECPrivacyType type) {
        @strongify(self)
        // status 即为权限状态，
        //状态类型参考：ECAuthorizationStatus
        NSLog(@"%lu",(unsigned long)status);
        if (status == ECAuthorizationStatus_Authorized) {
            [self presentViewController:self.imagePickerVC
                                     animated:YES
                                   completion:nil];
        }else{
            NSLog(@"相册不可用:%lu",(unsigned long)status);
            [self alertControllerStyle:SYS_AlertController
                    showAlertViewTitle:@"获取相册权限"
                               message:nil
                       isSeparateStyle:YES
                           btnTitleArr:@[@"去获取"]
                        alertBtnAction:@[@"pushToSysConfig"]];
        }
    }];
}
//访问摄像头
-(void)camera:(NSString *)doSth{
    //先鉴权
    @weakify(self)
    [ECAuthorizationTools checkAndRequestAccessForType:ECPrivacyType_Camera
                                          accessStatus:^(ECAuthorizationStatus status,
                                                         ECPrivacyType type) {
        @strongify(self)
        // status 即为权限状态，
        //状态类型参考：ECAuthorizationStatus
        NSLog(@"%lu",(unsigned long)status);
        if (status == ECAuthorizationStatus_Authorized) {
            //允许访问摄像头后需要做的操作
            [self performSelector:NSSelectorFromString(doSth)
                       withObject:Nil];
        }else{
            NSLog(@"摄像头不可用:%lu",(unsigned long)status);
            [self alertControllerStyle:SYS_AlertController
                    showAlertViewTitle:@"获取摄像头权限"
                               message:nil
                       isSeparateStyle:YES
                           btnTitleArr:@[@"去获取"]
                        alertBtnAction:@[@"pushToSysConfig"]];
        }
    }];
}
#pragma mark —— 子类需要覆写
-(void)backBtnClickEvent:(UIButton *)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    }
}
// 下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
}

-(void)OK{
    
}
//跳转系统设置
-(void)pushToSysConfig{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url
                                           options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @YES}
                                 completionHandler:nil];
    }
}
//KVO 监听 MJRefresh + 震动特效反馈
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    if ([object isEqual:self.tableViewHeader] &&
        self.tableViewHeader.state == MJRefreshStatePulling) {
        [self feedbackGenerator];
    }
    else if ([object isEqual:self.tableViewFooter] &&
             self.tableViewFooter.state == MJRefreshStatePulling) {
        [self feedbackGenerator];
    }
}
//震动特效反馈
-(void)feedbackGenerator{
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [generator prepare];
        [generator impactOccurred];
    } else {
        // Fallback on earlier versions
    }
}
#pragma mark —— lazyLoad
-(MJRefreshGifHeader *)tableViewHeader{
    if (!_tableViewHeader) {
        _tableViewHeader =  [MJRefreshGifHeader headerWithRefreshingTarget:self
                                                          refreshingAction:@selector(pullToRefresh)];
        // 设置普通状态的动画图片
        [_tableViewHeader setImages:@[kIMG(@"官方")]
                           forState:MJRefreshStateIdle];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        [_tableViewHeader setImages:@[kIMG(@"Indeterminate Spinner - Small")]
                           forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
//        [_tableViewHeader setImages:@[kIMG(@"gif_header_1"),
//                                      kIMG(@"gif_header_2"),
//                                      kIMG(@"gif_header_3"),
//                                      kIMG(@"gif_header_4")]
//                           duration:0.4
//                           forState:MJRefreshStateRefreshing];
        NSMutableArray *dataMutArr = NSMutableArray.array;
        for (int i = 1; i <= 55; i++) {
            NSString *str = [NSString stringWithFormat:@"gif_header_%d",i];
            [dataMutArr addObject:kIMG(str)];
        }

        [_tableViewHeader setImages:dataMutArr
                           duration:0.7
                           forState:MJRefreshStateRefreshing];
        
        // 设置文字
        [_tableViewHeader setTitle:@"Click or drag down to refresh"
                          forState:MJRefreshStateIdle];
        [_tableViewHeader setTitle:@"Loading more ..."
                          forState:MJRefreshStateRefreshing];
        [_tableViewHeader setTitle:@"No more data"
                          forState:MJRefreshStateNoMoreData];

        // 设置字体
        _tableViewHeader.stateLabel.font = [UIFont systemFontOfSize:17];
        // 设置颜色
        _tableViewHeader.stateLabel.textColor = KLightGrayColor;
        //震动特效反馈
        [_tableViewHeader addObserver:self
                           forKeyPath:@"state"
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    }return _tableViewHeader;
}

-(MJRefreshAutoGifFooter *)tableViewFooter{
    if (!_tableViewFooter) {
        _tableViewFooter = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self
                                                                refreshingAction:@selector(loadMoreRefresh)];
        // 设置普通状态的动画图片
        [_tableViewFooter setImages:@[kIMG(@"官方")]
                           forState:MJRefreshStateIdle];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        [_tableViewFooter setImages:@[kIMG(@"Indeterminate Spinner - Small")]
                           forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
//        [_tableViewFooter setImages:@[kIMG(@"gif_header_1"),
//                                      kIMG(@"gif_header_2"),
//                                      kIMG(@"gif_header_3"),
//                                      kIMG(@"gif_header_4")]
//                           duration:0.4
//                           forState:MJRefreshStateRefreshing];
        
        NSMutableArray *dataMutArr = NSMutableArray.array;
        for (int i = 1; i <= 55; i++) {
            NSString *str = [NSString stringWithFormat:@"gif_header_%d",i];
            [dataMutArr addObject:kIMG(str)];
        }

        [_tableViewHeader setImages:dataMutArr
                           duration:0.4
                           forState:MJRefreshStateRefreshing];
        
        // 设置文字
        [_tableViewFooter setTitle:@"Click or drag up to refresh"
                          forState:MJRefreshStateIdle];
        [_tableViewFooter setTitle:@"Loading more ..."
                          forState:MJRefreshStateRefreshing];
        [_tableViewFooter setTitle:@"No more data"
                          forState:MJRefreshStateNoMoreData];
        // 设置字体
        _tableViewFooter.stateLabel.font = [UIFont systemFontOfSize:17];
        // 设置颜色
        _tableViewFooter.stateLabel.textColor = KLightGrayColor;
        //震动特效反馈
        [_tableViewFooter addObserver:self
                           forKeyPath:@"state"
                              options:NSKeyValueObservingOptionNew
                              context:nil];
        _tableViewFooter.hidden = YES;
    }return _tableViewFooter;
}

-(MJRefreshBackNormalFooter *)refreshBackNormalFooter{
    if (!_refreshBackNormalFooter) {
        _refreshBackNormalFooter = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self
                                                                        refreshingAction:@selector(loadMoreRefresh)];
    }return _refreshBackNormalFooter;
}

-(FSCustomButton *)backBtn{
    if (!_backBtn) {
        _backBtn = FSCustomButton.new;
        _backBtn.buttonImagePosition = FSCustomButtonImagePositionLeft;
        [_backBtn setTitleColor:kWhiteColor
                       forState:UIControlStateNormal];
        [_backBtn setTitle:@"返回"
                  forState:UIControlStateNormal];
        [_backBtn setImage:kIMG(@"back_black")
                  forState:UIControlStateNormal];
        [_backBtn addTarget:self
                     action:@selector(backBtnClickEvent:)
           forControlEvents:UIControlEventTouchUpInside];
    }return _backBtn;
}

-(TZImagePickerController *)imagePickerVC{
    if (!_imagePickerVC) {
        _imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9
                                                                        delegate:self];
        @weakify(self)
        [_imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,
                                                          NSArray *assets,
                                                          BOOL isSelectOriginalPhoto) {
            @strongify(self)
            if (self.picBlock) {
                self.picBlock(photos);
            }
        }];
    }return _imagePickerVC;
}

-(BRStringPickerView *)stringPickerView{
    if (!_stringPickerView) {
        _stringPickerView = [[BRStringPickerView alloc] initWithPickerMode:self.brStringPickerMode];
        if (self.BRStringPickerViewDataMutArr.count > 2) {
            _stringPickerView.title = self.BRStringPickerViewDataMutArr[0];
            NSMutableArray *temp = NSMutableArray.array;
            temp = self.BRStringPickerViewDataMutArr.copy;
            [temp removeObjectAtIndex:0];
            _stringPickerView.dataSourceArr = temp;
        }
        @weakify(self)
        _stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
//            NSLog(@"选择的值：%@", resultModel.selectValue);
            @strongify(self)
            if (self.brStringPickerViewBlock) {
                self.brStringPickerViewBlock(resultModel);
            }
        };
    }return _stringPickerView;
}

-(AFNetworkReachabilityManager *)afNetworkReachabilityManager{
    if (!_afNetworkReachabilityManager) {
//        1.创建网络监听管理者
        _afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    }return _afNetworkReachabilityManager;
}


-(UIImageView *)gifImageView{
    if (!_gifImageView) {
        _gifImageView = UIImageView.new;
        _gifImageView.image = self.image;
        [self.view addSubview:_gifImageView];
        [_gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }return _gifImageView;
}

-(NSString *)path{
    if (!_path) {
        _path = [[NSBundle mainBundle] pathForResource:@"GIF大图"
                                                ofType:@"gif"];
    }return _path;
}

-(NSData *)data{
    if (!_data) {
        _data = [NSData dataWithContentsOfFile:self.path];
    }return _data;
}

-(UIImage *)image{
    if (!_image) {
        _image = [UIImage sd_animatedGIFWithData:self.data];
    }return _image;
}


@end

