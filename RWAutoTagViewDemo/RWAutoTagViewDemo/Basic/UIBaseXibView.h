//
//  UIBaseXibView.h
//  MaoBuTou
//
//  Created by 心冷如灰 on 2017/9/22.
//  Copyright © 2017年 心冷如灰. All rights reserved.
//

#import <UIKit/UIKit.h>


//IB_DESIGNABLE

@interface UIBaseXibView : UIView

//@property (nonatomic,strong) UIBaseViewController *viewController;

+ (instancetype)initViewWithIndex:(NSInteger)index;

@end
