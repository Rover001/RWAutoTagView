//
//  NSBundle+RWAutoTag.h
//  RWAutoTagViewDemo
//
//  Created by 曾云 on 2019/10/27.
//  Copyright © 2019 曾云. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;
NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (RWAutoTag)
+ (instancetype)rw_autoTagBundle;
+ (UIImage *)rw_autotagImage;
@end

NS_ASSUME_NONNULL_END
