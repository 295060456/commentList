//
//  HighModel.h
//  eva
//
//  Created by 上帝的宠儿 on 2020/7/14.
//  Copyright © 2020 ice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondClassModel.h"

#define preMax 3//子标题一开始最多加载的个数

@interface FirstClassModel : NSObject

@property(nonatomic,strong)NSString *firstClassText;
@property(nonatomic,strong)NSMutableArray <SecondClassModel *>*secClsModelMutArr;

#pragma mask --- define
@property(nonatomic,assign)BOOL _hasMore;
@property(nonatomic,assign)BOOL isFullShow;

+ (FirstClassModel *)create:(NSString *)firstClassText;

@end

