//
//  UIView+RWExtension.h
//  CustomAutoTagView_Example
//
//  Created by 曾云 on 2019/10/26.
//  Copyright © 2019 Rover001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (RWExtension)

@property (assign, nonatomic) CGFloat rw_x;
@property (assign, nonatomic) CGFloat rw_y;
@property (assign, nonatomic) CGFloat rw_w;
@property (assign, nonatomic) CGFloat rw_h;
@property (assign, nonatomic) CGSize rw_size;
@property (assign, nonatomic) CGPoint rw_origin;

@end

NS_ASSUME_NONNULL_END
