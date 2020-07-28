//
//  InputView.h
//  MonkeyKingVideo
//
//  Created by Jobs on 2020/7/24.
//  Copyright © 2020 Jobs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InputView : UIView

@property(nonatomic,copy)MKDataBlock block;
-(void)actionBlock:(MKDataBlock)block;

@end

NS_ASSUME_NONNULL_END
