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
    [self keyboard];
}

-(void)keyboard{
#warning 此处必须禁用IQKeyboardManager，因为框架的原因，弹出键盘的时候是整个VC全部向上抬起，一个是弹出的高度不对，第二个是弹出的逻辑不正确，就只是需要评论页向上同步弹出键盘高度即可。可是一旦禁用IQKeyboardManager这里就必须手动监听键盘弹出高度，再根据这个高度对评论页做二次约束
    [IQKeyboardManager sharedManager].enable = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrameNotification:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];//(origin = (x = 0, y = 896), size = (width = 414, height = 346))
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];//(origin = (x = 0, y = 550), size = (width = 414, height = 346))
    CGFloat KeyboardOffsetY = beginFrame.origin.y - endFrame.origin.y;
    self.commentPopUpVC.view.mj_y -= KeyboardOffsetY;
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
        [UIView appointCornerCutToCircleWithTargetView:_commentPopUpVC.view
                                     byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                           cornerRadii:CGSizeMake(20, 20)];
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
