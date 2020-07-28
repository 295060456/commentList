//
//  TestClass.h
//  commentList
//
//  Created by Jobs on 2020/7/28.
//  Copyright © 2020 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestClass : NSObject

@property(nonatomic,copy)KBlock block;

+ (void)print:(NSString *)firstArg, ... NS_REQUIRES_NIL_TERMINATION;

-(void)actionBlock:(KBlock)block;

@end

NS_ASSUME_NONNULL_END
