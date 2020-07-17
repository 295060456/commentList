//
//  ViewController.m
//  commentList
//
//  Created by Jobs on 2020/7/15.
//  Copyright © 2020 Jobs. All rights reserved.
//

#import "ViewController.h"
#import "CommentPopUpVC.h"

@interface ViewController ()
{
    BOOL isOpen;
    CGFloat liftingHeight;
}

@property(nonatomic,strong)CommentPopUpVC *commentPopUpVC;

@end

@implementation ViewController

-(instancetype)init{
    if (self = [super init]) {

    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    isOpen = NO;
    liftingHeight = SCREEN_HEIGHT / 2;
}
#pragma mark —— PopUpVCDelegate
- (void)closeComment {

}

-(void)willOpen{
    [self.commentPopUpVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(self->liftingHeight);
        make.bottom.mas_equalTo(self->liftingHeight);
    }];
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.3f
                     animations:^{
        [self.commentPopUpVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
        // 注意需要再执行一次更新约束
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self->isOpen = !self->isOpen;
    }];
}

-(void)willClose_vertical{
    [UIView animateWithDuration:0.3f
                     animations:^{
        [self.commentPopUpVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self->liftingHeight);
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
                //vc的view减1
        [self.commentPopUpVC.view removeFromSuperview];
        //vc为0
        [self.commentPopUpVC removeFromParentViewController];
        self->_commentPopUpVC = nil;
        self->isOpen = !self->isOpen;
    }];
}

-(void)willClose_horizont{
    [UIView animateWithDuration:0.3f
                     animations:^{
        [self.commentPopUpVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(self->liftingHeight);
            make.left.mas_equalTo(SCREEN_WIDTH);
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        //vc的view减1
        [self.commentPopUpVC.view removeFromSuperview];
        //vc为0
        [self.commentPopUpVC removeFromParentViewController];
        self->_commentPopUpVC = nil;
        self->isOpen = !self->isOpen;
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches
          withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        UIView *touchView = touch.view;
        if (touchView == _commentPopUpVC.view) {
            
        }else if(touchView == self.view){
            if (_commentPopUpVC.view) {
                [self willClose_vertical];
            }else{
                [self willOpen];
            }
        }else{}
    }
}

#pragma mark —— lazyload
-(CommentPopUpVC *)commentPopUpVC{
    if (!_commentPopUpVC) {
        _commentPopUpVC = CommentPopUpVC.new;
        _commentPopUpVC.liftingHeight = liftingHeight;
        [self addChildViewController:_commentPopUpVC];
        [self.view addSubview:_commentPopUpVC.view];
        [_commentPopUpVC actionBlock:^(id data) {
            MoveDirection moveDirection = [data intValue];
            if (moveDirection == MoveDirection_vertical_down) {
                [self willClose_vertical];
            }else if (moveDirection == MoveDirection_horizont_right){
                [self willClose_horizont];
            }else if (moveDirection == MoveDirection_vertical_up){
                [self willOpen];
            }else{}
        }];
    }return _commentPopUpVC;
}

@end
