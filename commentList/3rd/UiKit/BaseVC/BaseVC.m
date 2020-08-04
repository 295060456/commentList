//
//  BaseVC.m
//  gtp
//
//  Created by GT on 2019/1/8.
//  Copyright © 2019 GT. All rights reserved.
//

#import "BaseVC.h"

#import "BaseVC+TZImagePickerController.h"
#import "BaseVC+MJRefresh.h"
#import "BaseVC+AlertController.h"
#import "BaseVC+AFNReachability.h"
#import "BaseVC+FSCustomButton.h"
#import "BaseVC+JXCategoryListContentViewDelegate.h"
#import "BaseVC+BRStringPickerView.h"
#import "BaseVC+GifImageView.h"

@interface BaseVC ()

@property(nonatomic,copy)MKDataBlock willComingBlock;
@property(nonatomic,copy)MKDataBlock didComingBlock;
@property(nonatomic,copy)MKDataBlock willBackBlock;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)MKDataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

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
#pragma mark —— Sys_LifeCycle
-(void)loadView{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES
                                             animated:NO];
}
//这个地方必须用下划线属性而不能用self.属性。因为这两个方法反复调用，会触发懒加载
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}
//这个地方必须用下划线属性而不能用self.属性。因为这两个方法反复调用，会触发懒加载
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES
                                             animated:NO];
    printf("retain count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self)));//打印对象的引用计数器
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

-(void)locateTabBar:(NSInteger)index{//backHome
    if (self.navigationController.tabBarController.selectedIndex == index) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        self.navigationController.tabBarController.hidesBottomBarWhenPushed = NO;
        self.navigationController.tabBarController.selectedIndex = index;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
///设置状态栏背景颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
///跳转系统设置
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
    }else if ([object isEqual:self.tableViewFooter] &&
             self.tableViewFooter.state == MJRefreshStatePulling) {
        [self feedbackGenerator];
    }
}
///震动特效反馈
-(void)feedbackGenerator{
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [generator prepare];
        [generator impactOccurred];
    } else {
        // Fallback on earlier versions
    }
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
#pragma mark —— lazyLoad
-(FSCustomButton *)backBtnBaseVC{
    if (!_backBtnBaseVC) {
        _backBtnBaseVC = FSCustomButton.new;
        _backBtnBaseVC.buttonImagePosition = FSCustomButtonImagePositionLeft;
        [_backBtnBaseVC setTitleColor:kWhiteColor
                       forState:UIControlStateNormal];
        [_backBtnBaseVC setTitle:@"返回"
                  forState:UIControlStateNormal];
        [_backBtnBaseVC setImage:kIMG(@"back_white")
                  forState:UIControlStateNormal];
        [_backBtnBaseVC addTarget:self
                     action:@selector(backBtnClickEvent:)
           forControlEvents:UIControlEventTouchUpInside];
    }return _backBtnBaseVC;
}

@end

