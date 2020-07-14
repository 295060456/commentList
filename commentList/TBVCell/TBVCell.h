//
//  TBVCell.h
//  commentList
//
//  Created by 刘赓 on 2020/7/13.
//  Copyright © 2020 Jobs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBVCell : UITableViewCell

-(void)actionBlock:(DataBlock)block;

+(instancetype)cellWith:(UITableView *)tableView
              withModel:(id _Nullable)model;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;

@end

NS_ASSUME_NONNULL_END
