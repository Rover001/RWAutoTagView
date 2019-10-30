//
//  UIView+Custom_Xib.m
//  MagicWallet
//
//  Created by 心冷如灰 on 2019/4/22.
//  Copyright © 2019年 心冷如灰. All rights reserved.
//

#import "UIView+Custom_Xib.h"

@implementation UIView (Custom_Xib)

+ (instancetype)initViewWithXibIndex:(NSInteger)index {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][index];
}

@end
