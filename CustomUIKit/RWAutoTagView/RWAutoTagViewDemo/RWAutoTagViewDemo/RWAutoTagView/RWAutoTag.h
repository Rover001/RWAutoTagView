//
//  RWAutoTag.h
//  RWAutoTagViewDemo
//
//  Created by 曾云 on 2019/10/27.
//  Copyright © 2019 曾云. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;
NS_ASSUME_NONNULL_BEGIN

/* 🐱 样式 */
typedef NS_ENUM(NSInteger,RWAutoTagStyle) {
    RWAutoTagStyle_Text = 0,     /**< 默认 只有文字 */
    RWAutoTagStyle_Image,        /**<  只有图片 */
    RWAutoTagStyle_Mingle,       /** 图片文字 */
    RWAutoTagStyle_Custom       /** 自定义 */
};

/* 🐱 图片的位置样式 */
typedef NS_ENUM(NSInteger,RWAutoTagImageEdgeInsetStyle) {
    RWAutoTagImageEdgeInsetStyle_Top = 0,     /**< 图片在上面 */
    RWAutoTagImageEdgeInsetStyle_Left,        /** 图片在左边  默认 */
    RWAutoTagImageEdgeInsetStyle_Right,       /** 图片在右边 */
    RWAutoTagImageEdgeInsetStyle_Bottom       /** 图片在下边 */
};

@interface RWAutoTag : NSObject

/* 🐱 样式
 默认 style = RWAutoTagStyle_Text */
@property (nonatomic,assign) RWAutoTagStyle style; /**< 样式 */

/* 🐱 图片位置样式
 style = RWAutoTagStyle_Image | RWAutoTagStyle_Mingle 才有效果
 默认 imageEdgeInsetStyle = RWAutoTagImageEdgeInsetStyle_Left */
@property (nonatomic,assign) RWAutoTagImageEdgeInsetStyle imageEdgeInsetStyle; /**< 图片位置样式 */
/* 文字与图片间距 默认lineitemSpacing = 0 */
@property (nonatomic,assign) CGFloat lineitemSpacing;


/* 最大显示宽度
 默认 safeAreaLayoutMaxWidth = [UIScreen mainScreen].bounds.size.width   */
@property (nonatomic,assign) CGFloat safeAreaLayoutMaxWidth;
@property (nonatomic,strong,nullable) NSString *text; /**< <#备注#> */
@property (nonatomic,strong,nullable) NSAttributedString *attributedText; /**< <#备注#> */

/* 内边距 默认 UIEdgeInsetsMake(0,0,0,0) */
@property (nonatomic,assign) UIEdgeInsets paddingInsets;
@property (strong,nonatomic,nullable) UIFont *font;
@property (assign,nonatomic) CGFloat fontSize; /**< 默认 13 */
@property (assign,nonatomic) BOOL enable;/* 🐱  默认YES */



+ (instancetype)autoTagWithText:(NSString *)text;
+ (instancetype)autoTagWithAttributedText:(NSAttributedString *)attributedText;
+ (instancetype)autoTagWithTagStyle:(RWAutoTagStyle)style;

@end

NS_ASSUME_NONNULL_END
