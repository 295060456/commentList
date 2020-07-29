//
//  ViewController.m
//  commentList
//
//  Created by Jobs on 2020/7/15.
//  Copyright © 2020 Jobs. All rights reserved.
//

#import "ViewController.h"
#import "CommentPopUpVC.h"

#import "TestClass.h"

@interface ViewController ()
{
    BOOL isOpen;
    CGFloat liftingHeight;
    CGFloat CommentPopUpVC_Y;
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
    [TestClass print:@"a",@"b",@"c", nil];
    TestClass *ts = TestClass.new;
//    [self performSelectorWithArgs:<#(nonnull SEL), ...#>];
//    [ts actionBlock:^(id data, ...) {
//        if (data) {
//            // 取出第一个参数
//            NSLog(@"%@", data);
//            // 定义一个指向个数可变的参数列表指针；
//            va_list args;
//            // 用于存放取出的参数
//            NSString *arg;
//            // 初始化变量刚定义的va_list变量，这个宏的第二个参数是第一个可变参数的前一个参数，是一个固定的参数
//            va_start(args, data);
//            // 遍历全部参数 va_arg返回可变的参数(a_arg的第二个参数是你要返回的参数的类型)
//            while ((arg = va_arg(args, NSString *))) {
//                NSLog(@"%@", arg);
//            }
//            // 清空参数列表，并置参数指针args无效
//            va_end(args);
//        }
//    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if (isOpen) {
//        [SceneDelegate sharedInstance].customSYSUITabBarController.lzb_tabBarHidden = YES;
//    }else{
//        [SceneDelegate sharedInstance].customSYSUITabBarController.lzb_tabBarHidden = NO;
//    }
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    NSLog(@"self.commentPopUpVC.view弹出");//self.commentPopUpVC.view.frame = (0 0; 414 896); self.commentPopUpVC.view.frame = (0 896; 414 448);self.commentPopUpVC.view.frame = (0 896; 414 448);
    NSLog(@"键盘输入");//self.commentPopUpVC.view.frame = (0 102; 414 448);&& self.commentPopUpVC.view.frame = (0 448; 414 448);
    NSLog(@"self.commentPopUpVC.view退出");//self.commentPopUpVC.view.frame = (0 448; 414 448);self.commentPopUpVC.view.frame = (0 0; 414 896);
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSLog(@"self.commentPopUpVC.view弹出");//self.commentPopUpVC.view.frame = (0 896; 414 448);self.commentPopUpVC.view.frame = (0 896; 414 448);self.commentPopUpVC.view.frame = (0 448; 414 448);
    NSLog(@"键盘输入");//self.commentPopUpVC.view.frame = (0 448; 414 448);&& self.commentPopUpVC.view.frame = (0 448; 414 448);
    NSLog(@"self.commentPopUpVC.view退出");//self.commentPopUpVC.view.frame = (0 896; 414 448);self.commentPopUpVC.view.frame = (0 0; 414 896);
//    self.commentPopUpVC.view.mj_y = CommentPopUpVC_Y;//开102 关448
    if (CommentPopUpVC_Y != liftingHeight && CommentPopUpVC_Y != 0) {
        self.commentPopUpVC.view.mj_y = CommentPopUpVC_Y;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//     if (isOpen) {
//         [SceneDelegate sharedInstance].customSYSUITabBarController.lzb_tabBarHidden = YES;
//     }else{
//         [SceneDelegate sharedInstance].customSYSUITabBarController.lzb_tabBarHidden = NO;
//     }
}

-(void)keyboard{
#warning 此处必须禁用IQKeyboardManager，因为框架的原因，弹出键盘的时候是整个VC全部向上抬起，一个是弹出的高度不对，第二个是弹出的逻辑不正确，就只是需要评论页向上同步弹出键盘高度即可。可是一旦禁用IQKeyboardManager这里就必须手动监听键盘弹出高度，再根据这个高度对评论页做二次约束
    [IQKeyboardManager sharedManager].enable = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrameNotification:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidChangeFrameNotification:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];
}
// 点击输入框 弹出软键盘commentPopUpVC.view 整体向上弹出一段软键盘高度的距离 self.commentPopUpVC.view.frame = (0 102; 414 448) ——> self.commentPopUpVC.view.frame = (0 448; 414 448)
// 软键盘失去焦点，键盘消失，commentPopUpVC.view回归正常位置 self.commentPopUpVC.view.frame = (0 448; 414 448);
#warning 因为是通知，这个地方如果写self.commentPopUpVC,可能引起其他地方键盘事件，比如登录的时候，对它进行影响，所以必须用_commentPopUpVC
- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];//(origin = (x = 0, y = 896), size = (width = 414, height = 346))
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];//(origin = (x = 0, y = 550), size = (width = 414, height = 346))
    CGFloat KeyboardOffsetY = beginFrame.origin.y - endFrame.origin.y;
    _commentPopUpVC.view.mj_y -= KeyboardOffsetY;
    CommentPopUpVC_Y = _commentPopUpVC.view.mj_y;//开102 关448
    NSLog(@"键盘弹出");//self.commentPopUpVC.view.frame = (0 102; 414 448);
    NSLog(@"键盘关闭");//self.commentPopUpVC.view.frame = (0 448; 414 448);
}

- (void)keyboardDidChangeFrameNotification:(NSNotification *)notification{
    NSLog(@"键盘弹出");//self.commentPopUpVC.view.frame = (0 102; 414 448);
    NSLog(@"键盘关闭");//self.commentPopUpVC.view.frame = (0 448; 414 448);
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
        [self.commentPopUpVC.inputView endEditing:YES];
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
        [self.commentPopUpVC.inputView endEditing:YES];
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
        
        [_commentPopUpVC commentPopUpActionBlock:^(id data) {
            NSLog(@"");
            [self willClose_vertical];
        }];
        
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
