//
//  TestClass.m
//  commentList
//
//  Created by Jobs on 2020/7/28.
//  Copyright © 2020 Jobs. All rights reserved.
//

#import "TestClass.h"

@implementation TestClass

/*
 NS_REQUIRES_NIL_TERMINATION是一个宏定义，用于编译时非nil结尾的检查
 
 在方法末尾添加NS_REQUIRES_NIL_TERMINATION有一个好处就是在调用该方法的时候，如果可变参数没有以nil结尾，则系统会出现一个警告Missing sentinel in method dispatch；如果没有添加这个宏，就不会有这个警告，所以推荐在方法末尾添加这个宏
 
 使用可变参数需要注意的点:
 
 一个方法最多只能有一个可变参数
 可变参数一定要放在方法的末尾
 在可变参数里，多个参数均以逗号隔开
 一般来说调用可变参数一般会以nil结尾
 */

+ (void)print:(NSString *)firstArg, ... NS_REQUIRES_NIL_TERMINATION {
    if (firstArg) {
        // 取出第一个参数
        NSLog(@"%@", firstArg);
        // 定义一个指向个数可变的参数列表指针；
        va_list args;
        // 用于存放取出的参数
        NSString *arg;
        // 初始化变量刚定义的va_list变量，这个宏的第二个参数是第一个可变参数的前一个参数，是一个固定的参数
        va_start(args, firstArg);
        // 遍历全部参数 va_arg返回可变的参数(a_arg的第二个参数是你要返回的参数的类型)
        while ((arg = va_arg(args, NSString *))) {
            NSLog(@"%@", arg);
        }
        // 清空参数列表，并置参数指针args无效
        va_end(args);
    }
}

-(void)actionBlock:(KBlock)block{
    self.block = block;
    if (self.block) {
//        self.block(@(1),1,@"12");
        self.block(@"11",@"12",@"13");
    }
}

@end
