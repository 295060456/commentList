//
//  BaseVC+FSCustomButton.m
//  MonkeyKingVideo
//
//  Created by Jobs on 2020/8/4.
//  Copyright © 2020 Jobs. All rights reserved.
//

#import "BaseVC+FSCustomButton.h"
#import <objc/runtime.h>

@implementation BaseVC (FSCustomButton)

static char *BaseVC_FSCustomButton_backBtnCategory;
@dynamic backBtnCategory;

#pragma mark —— 子类需要覆写
-(void)backBtnClickEvent:(UIButton *)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    }
}
#pragma mark —— lazyLoad
-(FSCustomButton *)backBtnCategory{
    FSCustomButton *BackBtnCategory = objc_getAssociatedObject(self, BaseVC_FSCustomButton_backBtnCategory);
    if (!BackBtnCategory) {
        BackBtnCategory = FSCustomButton.new;
        BackBtnCategory.buttonImagePosition = FSCustomButtonImagePositionLeft;
        [BackBtnCategory setTitleColor:kWhiteColor
                       forState:UIControlStateNormal];
        [BackBtnCategory setTitle:@"返回"
                  forState:UIControlStateNormal];
        [BackBtnCategory setImage:kIMG(@"back_white")
                  forState:UIControlStateNormal];
        [BackBtnCategory addTarget:self
                     action:@selector(backBtnClickEvent:)
           forControlEvents:UIControlEventTouchUpInside];
        objc_setAssociatedObject(self,
                                 BaseVC_FSCustomButton_backBtnCategory,
                                 BackBtnCategory,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }return BackBtnCategory;
}

@end
