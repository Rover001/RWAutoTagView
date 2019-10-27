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
    RWAutoTagButtonStyle_Custom,       /** 自定义 */
};

/* 🐱 图片的位置样式 */
typedef NS_ENUM(NSInteger,RWAutoTagButtonImageEdgeInsetStyle) {
    RWAutoTagButtonImageEdgeInsetStyleTop = 0,     /**< 图片在上面 */
    RWAutoTagButtonImageEdgeInsetStyleLeft,        /** 图片在左边  默认 */
    RWAutoTagButtonImageEdgeInsetStyleRight,       /** 图片在右边 */
    RWAutoTagButtonImageEdgeInsetStyleBottom       /** 图片在下边 */
};

@class RWAutoTag;

@interface RWAutoTagButton : UIButton

/* 🐱 样式
 默认 autoButtonStyle = RWAutoTagButtonStyle_Text */
@property (nonatomic,assign) RWAutoTagButtonStyle autoTagButtonStyle; /**< 样式 */

/* 🐱 图片位置样式
 autoButtonStyle = RWAutoTagButtonStyle_Image | RWAutoTagButtonStyle_Mingle 才有效
 默认 imageEdgeInsetStyle = RWAutoTagButtonImageEdgeInsetStyleLeft */
@property (nonatomic,assign)
RWAutoTagButtonImageEdgeInsetStyle imageEdgeInsetStyle; /**< 图片位置样式 */

/* 最大显示宽度
 默认 safeAreaLayoutMaxWidth = [UIScreen mainScreen].bounds.size.width   */
@property (nonatomic,assign) CGFloat safeAreaLayoutMaxWidth;

/* 文字与图片间距 默认lineitemSpacing = 0
 如：RWAutoTagButtonImageEdgeInsetStyleTop 图片在上面是lineitemSpacing就表示图片底部与文字顶部的间距
 */
@property (nonatomic,assign) CGFloat lineitemSpacing;

/* 🐱 配置数据 */
@property (nonatomic,strong) RWAutoTag *autoTag;

+ (instancetype)autoTagButtonWithAutoTag:(RWAutoTag *)autoTag;

@end

NS_ASSUME_NONNULL_END
