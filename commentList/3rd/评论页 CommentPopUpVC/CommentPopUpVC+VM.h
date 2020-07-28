//
//  CommentPopUpVC+VM.h
//  MonkeyKingVideo
//
//  Created by Jobs on 2020/7/13.
//  Copyright © 2020 Jobs. All rights reserved.
//

#import "CommentPopUpVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentPopUpVC (VM)
///GET 初始化用户评论列表
-(void)netWorking_MKCommentQueryInitListGET;
///POST 评论视频
-(void)netWorking_MKCommentVideoPOST;
///POST 回复评论
-(void)netWorking_MKCommentReplyCommentPOST;

@end

NS_ASSUME_NONNULL_END
