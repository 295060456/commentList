//
//  BaseVC.h
//  gtp
//
//  Created by GT on 2019/1/8.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCustomButton.h"
#import "AABlock.h"

typedef enum : NSUInteger {
    ComingStyle_PUSH = 0,
    ComingStyle_PRESENT
} ComingStyle;

NS_ASSUME_NONNULL_BEGIN

@interface BaseVC : UIViewController
<
UIGestureRecognizerDelegate
,UINavigationControllerDelegate
,TZImagePickerControllerDelegate
>

@property(nonatomic,strong)RACSignal *reqSignal;
@property(nonatomic,strong)MJRefreshAutoGifFooter *tableViewFooter;
@property(nonatomic,strong)MJRefreshGifHeader *tableViewHeader;
@property(nonatomic,strong)MJRefreshBackNormalFooter *refreshBackNormalFooter;
@property(nonatomic,weak)TZImagePickerController *imagePickerVC;
@property(nonatomic,strong)BRStringPickerView *stringPickerView;
//@property(nonatomic,strong)ViewForHeader *viewForHeader;
//@property(nonatomic,strong)ViewForFooter *viewForFooter;
@property(nonatomic,strong)FSCustomButton *backBtn;
@property(nonatomic,strong)UIAlertController *alertController;
@property(nonatomic,assign)BRStringPickerMode brStringPickerMode;
@property(nonatomic,strong)NSArray *BRStringPickerViewDataMutArr;

@property(nonatomic,assign)BOOL isRequestFinish;//数据请求是否完毕
@property(nonatomic,copy)void (^ReachableViaWWANNetWorking)(void);//3G网络
@property(nonatomic,copy)void (^ReachableViaWiFiNetWorking)(void);//WiFi
@property(nonatomic,copy)void (^UnknownNetWorking)(void);//未知网络
@property(nonatomic,copy)void (^NotReachableNetWorking)(void);//无任何网络连接
@property(nonatomic,copy)void (^ReachableNetWorking)(void);//有网络

-(void)backBtnClickEvent:(UIButton *)sender;
-(void)VCwillComingBlock:(DataBlock)block;//即将进来
-(void)VCdidComingBlock:(DataBlock)block;//已经进来
-(void)VCwillBackBlock:(DataBlock)block;//即将出去
-(void)VCdidBackBlock:(DataBlock)block;//已经出去
-(void)GettingPicBlock:(DataBlock)block;//点选的图片
-(void)BRStringPickerViewBlock:(DataBlock)block;

-(void)AFNReachability;

-(void)showLoginAlertView;
-(void)showAlertViewTitle:(NSString *)title
                  message:(NSString *)message
              btnTitleArr:(NSArray <NSString*>*)btnTitleArr
           alertBtnAction:(NSArray <NSString*>*)alertBtnActionArr;
-(void)showActionSheetTitle:(NSString *)title
                    message:(NSString *)message
                btnTitleArr:(NSArray <NSString*>*)btnTitleArr
             alertBtnAction:(NSArray <NSString*>*)alertBtnActionArr
                     sender:(nullable UIButton *)sender;

-(void)locateTabBar:(NSInteger)index;
-(void)setStatusBarBackgroundColor:(UIColor *)color;
-(void)choosePic;//选择图片
-(void)camera:(NSString *)doSth;//访问摄像头
-(void)feedbackGenerator;//震动特效反馈

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                 comingStyle:(ComingStyle)comingStyle
           presentationStyle:(UIModalPresentationStyle)presentationStyle
               requestParams:(nullable id)requestParams
                     success:(DataBlock)block
                    animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
