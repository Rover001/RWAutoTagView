//
//  NSBundle+RWAutoTag.m
//  RWAutoTagViewDemo
//
//  Created by 曾云 on 2019/10/27.
//  Copyright © 2019 曾云. All rights reserved.
//

#import "NSBundle+RWAutoTag.h"
#import "RWAutoTagButton.h"

@implementation NSBundle (RWAutoTag)

+ (instancetype)rw_autoTagBundle {
    
    static NSBundle *autoTagBundle = nil;
       if (autoTagBundle == nil) {
           // 这里不使用mainBundle是为了适配pod 1.x和0.x
           autoTagBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[RWAutoTagButton class]] pathForResource:@"RWAutoTag" ofType:@"bundle"]];
       }
       return autoTagBundle;
}

+ (UIImage *)rw_autotagImage {
    static UIImage *autotagImage = nil;
       if (autotagImage == nil) {
//           autotagImage = [[UIImage imageWithContentsOfFile:[[self rw_autoTagBundle] pathForResource:@"autotag@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
           autotagImage = [UIImage imageWithContentsOfFile:[[self rw_autoTagBundle] pathForResource:@"RWAutoTag" ofType:@"png"]];
       }
       return autotagImage;
}


@end
