//
//  RWAutoTagButton.h
//  RWAutoTagViewDemo
//
//  Created by 曾云 on 2019/10/27.
//  Copyright © 2019 曾云. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/* 🐱 按钮样式 */
typedef NS_ENUM(NSInteger,RWAutoTagButtonStyle) {
    RWAutoTagButtonStyle_Text = 0,     /**< 默认 只有文字 */
    RWAutoTagButtonStyle_Image,        /** 只有图片 */
    RWAutoTagButtonStyle_Mingle,       /** 图片文字 */
    RWAutoTagButtonStyle_Custom,       /** 自定义  暂无实现 */
};

/* 🐱 按钮内容显示优先级样式
 rw_imageStyle = RWAutoTagButtonImageStyle_Top;
 rw_imageStyle = RWAutoTagButtonImageStyle_Right;
 
 */
typedef NS_ENUM(NSInteger,RWAutoTagButtonDisplayStyle) {
    RWAutoTagButtonDisplayStyle_Text = 0,     /**<  优先显示文字 默认 */
    RWAutoTagButtonDisplayStyle_Image,        /** 优先显示图片 */
};

/* 🐱 图片的位置样式 */
typedef NS_ENUM(NSInteger,RWAutoTagButtonImageStyle) {
    RWAutoTagButtonImageStyle_Top = 0,     /**< 图片在上面 */
    RWAutoTagButtonImageStyle_Left,        /** 图片在左边  默认 */
    RWAutoTagButtonImageStyle_Bottom,       /** 图片在下边 */
    RWAutoTagButtonImageStyle_Right,      /** 图片在右边 */
    RWAutoTagButtonImageStyle_Center,      /** 图片居中 */
};



@class RWAutoTag;

@interface RWAutoTagButton : UIButton

/* 🐱 样式
 默认 rw_autoTagButtonStyle = RWAutoTagButtonStyle_Text */
@property (nonatomic,assign) RWAutoTagButtonStyle rw_autoTagButtonStyle;
@property (nonatomic,assign) RWAutoTagButtonStyle autoTagButtonStyle DEPRECATED_MSG_ATTRIBUTE("🐱'RWAutoTagView','~> 0.1.5'废弃、将会在后续的某一个版本(0.1.7)删除;请使用 rw_autoTagButtonStyle"); /**< 样式 */


/* 🐱 图片位置样式
 rw_autoTagButtonStyle = RWAutoTagButtonStyle_Image | RWAutoTagButtonStyle_Mingle 才有效
 rw_autoTagButtonStyle = RWAutoTagButtonStyle_Image 时候，  rw_imageStyle = RWAutoTagButtonImageStyle_Center
 默认 rw_imageStyle = RWAutoTagButtonImageStyle_Left */
@property (nonatomic,assign)RWAutoTagButtonImageStyle rw_imageStyle;/**< 图片位置样式 */
@property (nonatomic,assign)RWAutoTagButtonImageStyle imageStyle DEPRECATED_MSG_ATTRIBUTE("🐱'RWAutoTagView','~> 0.1.5'废弃、将会在后续的某一个版本(0.1.7)删除;请使用 rw_imageStyle"); /**< 图片位置样式 */

/* 最大显示宽度
 默认 rw_safeAreaLayoutMaxWidth = [UIScreen mainScreen].bounds.size.width   */
@property (nonatomic,assign) CGFloat rw_safeAreaLayoutMaxWidth;
@property (nonatomic,assign) CGFloat safeAreaLayoutMaxWidth DEPRECATED_MSG_ATTRIBUTE("🐱'RWAutoTagView','~> 0.1.5'废弃、将会在后续的某一个版本(0.1.7)删除;请使用 rw_safeAreaLayoutMaxWidth");

/* 文字与图片间距 默认rw_itemSpacing = 0
 如：RWAutoTagButtonImageStyle_Top 图片在上面是rw_itemSpacing就表示图片底部与文字顶部的间距
 */
@property (nonatomic,assign) CGFloat rw_itemSpacing;
@property (nonatomic,assign) CGFloat lineitemSpacing DEPRECATED_MSG_ATTRIBUTE("🐱'RWAutoTagView','~> 0.1.5'废弃、将会在后续的某一个版本(0.1.7)删除;请使用 rw_itemSpacing");

/* 🐱 是否是动态固定宽度 */
@property (nonatomic,assign) BOOL rw_isDynamicFixed;
@property (nonatomic,assign) BOOL isDynamicFixed DEPRECATED_MSG_ATTRIBUTE("🐱'RWAutoTagView','~> 0.1.5'废弃、将会在后续的某一个版本(0.1.7)删除;请使用 rw_isDynamicFixed");
/* 🐱 固定宽度值 默认CGSizeZero */

@property (nonatomic,assign) CGSize rw_dynamicFixedSize;
@property (nonatomic,assign) CGSize dynamicFixedSize DEPRECATED_MSG_ATTRIBUTE("🐱'RWAutoTagView','~> 0.1.5'废弃、将会在后续的某一个版本(0.1.7)删除;请使用 rw_dynamicFixedSize");

/* 🐱 配置数据 */
@property (nonatomic,strong) RWAutoTag *autoTag DEPRECATED_MSG_ATTRIBUTE("🐱'RWAutoTagView','~> 0.1.5'废弃、将会在后续的某一个版本(0.1.7)删除");


+ (instancetype)autoTagButtonWithAutoTag:(RWAutoTag *)autoTag DEPRECATED_MSG_ATTRIBUTE("🐱'RWAutoTagView','~> 0.1.5',初始化方法废弃、将会在后续的某一个版本(0.1.7)删除");

@end

NS_ASSUME_NONNULL_END
