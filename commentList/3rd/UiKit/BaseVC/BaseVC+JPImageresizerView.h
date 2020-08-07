//
//  BaseVC+JPImageresizerView.h
//  MonkeyKingVideo
//
//  Created by Jobs on 2020/8/7.
//  Copyright © 2020 Jobs. All rights reserved.
//

#import "BaseVC.h"

typedef enum : NSInteger {
    JPImageresizerConfigureType_1 = 0,//默认配置裁剪图片/GIF（UIImage）
    JPImageresizerConfigureType_2,//默认配置裁剪图片/GIF（NSData）
    JPImageresizerConfigureType_3,//默认配置裁剪视频（NSURL）
    JPImageresizerConfigureType_4,//默认配置裁剪视频（AVURLAsset）
    JPImageresizerConfigureType_5,//浅色毛玻璃配置裁剪图片/GIF（UIImage）
    JPImageresizerConfigureType_6,//浅色毛玻璃配置裁剪图片/GIF（NSData）
    JPImageresizerConfigureType_7,//浅色毛玻璃配置裁剪视频（NSURL）
    JPImageresizerConfigureType_8,//浅色毛玻璃配置裁剪视频（AVURLAsset）
    JPImageresizerConfigureType_9,//深色毛玻璃配置裁剪图片/GIF（UIImage）
    JPImageresizerConfigureType_10,//深色毛玻璃配置裁剪图片/GIF（NSData）
    JPImageresizerConfigureType_11,//深色毛玻璃配置裁剪视频（NSURL）
    JPImageresizerConfigureType_12//深色毛玻璃配置裁剪视频（AVURLAsset）
} JPImageresizerConfigureType;

NS_ASSUME_NONNULL_BEGIN

@interface BaseVC (JPImageresizerView)

#pragma mark —— BaseVC+JPImageresizerView
@property(nonatomic,strong)JPImageresizerConfigure *configure;
@property(nonatomic,strong)JPImageresizerView *imageresizerView;
@property(nonatomic,assign)JPImageresizerConfigureType configureType;
///一些资源文件
@property(nonatomic,strong)NSData *JPImageresizerView_data;
@property(nonatomic,strong)UIImage *JPImageresizerView_img;
@property(nonatomic,strong)NSURL *JPImageresizerView_url;
@property(nonatomic,strong)AVURLAsset *JPImageresizerView_avURLAsset;
///Block回调
@property(nonatomic,copy)MKDataBlock makeBlock;
@property(nonatomic,copy)MKDataBlock fixErrorBlock;
@property(nonatomic,copy)MKDataBlock fixStartBlock;
@property(nonatomic,copy)MKDataBlock fixProgressBlock;
@property(nonatomic,copy)MKDataBlock fixCompleteBlock;

@end

NS_ASSUME_NONNULL_END
