//
//  UIView+RWExtension.m
//  CustomAutoTagView_Example
//
//  Created by 曾云 on 2019/10/26.
//  Copyright © 2019 Rover001. All rights reserved.
//

#import "UIView+RWExtension.h"


@implementation UIView (RWExtension)

- (void)setRw_x:(CGFloat)rw_x
{
    CGRect frame = self.frame;
    frame.origin.x = rw_x;
    self.frame = frame;
}

- (CGFloat)rw_x
{
    return self.frame.origin.x;
}

- (void)setRw_y:(CGFloat)rw_y
{
    CGRect frame = self.frame;
    frame.origin.y = rw_y;
    self.frame = frame;
}

- (CGFloat)rw_y
{
    return self.frame.origin.y;
}

- (void)setRw_w:(CGFloat)rw_w
{
    CGRect frame = self.frame;
    frame.size.width = rw_w;
    self.frame = frame;
}

- (CGFloat)rw_w
{
    return self.frame.size.width;
}

- (void)setRw_h:(CGFloat)rw_h
{
    CGRect frame = self.frame;
    frame.size.height = rw_h;
    self.frame = frame;
}

- (CGFloat)rw_h
{
    return self.frame.size.height;
}

- (void)setRw_size:(CGSize)rw_size
{
    CGRect frame = self.frame;
    frame.size = rw_size;
    self.frame = frame;
}

- (CGSize)rw_size
{
    return self.frame.size;
}

- (void)setRw_origin:(CGPoint)rw_origin
{
    CGRect frame = self.frame;
    frame.origin = rw_origin;
    self.frame = frame;
}

- (CGPoint)rw_origin
{
    return self.frame.origin;
}

@end
