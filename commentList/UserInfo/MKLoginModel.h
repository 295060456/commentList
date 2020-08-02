//
//  MKLoginModel.h
//  MonkeyKingVideo
//
//  Created by hansong on 7/12/20.
//  Copyright © 2020 Jobs. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 用户信息数据模型
@interface MKLoginModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*account;
@property(nonatomic,strong)NSString <Optional>*nickName;
@property(nonatomic,strong)NSString <Optional>*tel;
@property(nonatomic,strong)NSString <Optional>*token;
@property(nonatomic,strong)NSString <Optional>*uid;

@property(nonatomic,strong)NSString <Optional>*age;
@property(nonatomic,strong)NSString <Optional>*area;
@property(nonatomic,strong)NSString <Optional>*sex;
@property(nonatomic,strong)NSString <Optional>*balance;
@property(nonatomic,strong)NSString <Optional>*constellation;
@property(nonatomic,strong)NSString <Optional>*goldNumber;
@property(nonatomic,strong)NSString <Optional>*remark;
@property(nonatomic,strong)NSString <Optional>*headImage;
@property(nonatomic,strong)NSString <Optional>*praiseNum;

@property(nonatomic,strong)NSString <Optional>*fansNum;

@property(nonatomic,strong)NSString <Optional>*focusNum;
@property(nonatomic,strong)NSString <Optional>*adPlayTime;
@end

NS_ASSUME_NONNULL_END
