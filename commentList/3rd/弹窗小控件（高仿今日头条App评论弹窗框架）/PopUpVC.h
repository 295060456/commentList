//
//  PopUpVC.h
//  MonkeyKingVideo
//
//  Created by Jobs on 2020/7/6.
//  Copyright © 2020 Jobs. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MoveDirection){
    MoveDirection_vertical = 0,//垂直方向滑动
    MoveDirection_horizont//水平方向滑动
};

@interface PopUpVC : BaseVC

@property(nonatomic,assign)CGFloat liftingHeight;
@property(nonatomic,copy)DataBlock block;

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                 comingStyle:(ComingStyle)comingStyle
           presentationStyle:(UIModalPresentationStyle)presentationStyle
               requestParams:(nullable id)requestParams
                     success:(DataBlock)block
                    animated:(BOOL)animated;
-(void)actionBlock:(DataBlock)block;

@end

NS_ASSUME_NONNULL_END

