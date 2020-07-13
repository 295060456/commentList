//
//  MyVedioTBVCell.h
//  MonkeyKingVideo
//
//  Created by Jobs on 2020/6/24.
//  Copyright © 2020 Jobs. All rights reserved.
//

#import "TBVCell_style_02.h"

NS_ASSUME_NONNULL_BEGIN

/// 个人中心——我的视频
@interface MyVedioTBVCell : TBVCell_style_02

@property(nonatomic,copy)DataBlock actionBlock;

+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;

-(void)action:(DataBlock)actionBlock;

@end

NS_ASSUME_NONNULL_END
