//
//  RWAutoTagView.h
//  RWAutoTagViewDemo
//
//  Created by 曾云 on 2019/10/27.
//  Copyright © 2019 曾云. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RWAutoTagButton,RWAutoTag;
@protocol RWAutoTagViewDataSource,RWAutoTagViewDelegate;


/* 🐱 排列样式  */
typedef NS_ENUM(NSInteger,RWAutoTagViewLineStyle) {
    RWAutoTagViewLineStyle_SingleLine = 0,     /** 单个一行显示 */
    RWAutoTagViewLineStyle_AutoLine           /**< 默认 动态显示 */
    
};

/* 🐱 排序样式 根据宽度来判断  */
typedef NS_ENUM(NSInteger,RWAutoTagViewAutoSortStyle) {
    /**< 默认 根据传入顺序直接展示 */
    RWAutoTagViewAutoSortStyleNormal = 0,
    RWAutoTagViewAutoSortStyleDescending, /** 升序  宽度最长在上面 */
    RWAutoTagViewAutoSortStyleAscending  /** 降序 宽度最短在上面 */
};


/* 🐱 当前宽宽显示的样式   */
typedef NS_ENUM(NSInteger,RWAutoTagViewFullSafeAreaStyle) {
    /**< 默认 根据safeAreaLayoutMaxWidth值为宽度  */
    RWAutoTagViewFullSafeAreaStyle_MaxWidth = 0,
    RWAutoTagViewFullSafeAreaStyle_AutoWidth, /** 自动根据控件布局来计算宽度 */
};


/* 🐱 autoTagButton 点击时间回调类型 */
typedef NS_ENUM(NSInteger,RWAutoTagViewItemClickBlockStyle) {
    /**< 默认  */
    RWAutoTagViewItemClickBlockStyle_None = 0,
    RWAutoTagViewItemClickBlockStyle_Delegate, /** 代理回调 */
    RWAutoTagViewItemClickBlockStyle_Block  /** block 回调  */
};

//NS_DESIGNATED_INITIALIZER  NS_UNAVAILABLE

@interface RWAutoTagView : UIView


@property (nonatomic,weak,nullable) IBOutlet id <RWAutoTagViewDataSource>dataSource;
@property (nonatomic,weak,nullable) IBOutlet id <RWAutoTagViewDelegate>delegate;


/* 内边距 默认 UIEdgeInsetsMake(0,0,0,0) */
@property (nonatomic,assign) UIEdgeInsets insets;

/* 行间距 默认 lineSpacing = 10 */
@property (nonatomic,assign) CGFloat lineSpacing;

/* 行内item间距 默认lineitemSpacing = 10 */
@property (nonatomic,assign) CGFloat lineitemSpacing;

/* 最大显示宽度
 默认 safeAreaLayoutMaxWidth = [UIScreen mainScreen].bounds.size.width   */
@property (nonatomic,assign) CGFloat safeAreaLayoutMaxWidth;

/* 🐱 当前宽宽显示的样式
默认 fullSafeAreaStyle = RWAutoTagViewFullSafeAreaStyle_MaxWidth
*/
@property (nonatomic,assign) RWAutoTagViewFullSafeAreaStyle  fullSafeAreaStyle;

/* 单行时候是否显示行间距  默认 showSingleLineSpacing = NO */
@property (nonatomic,assign) BOOL showSingleLineSpacing;

/* 对允许item进行排序  默认 isItemSort = YES */
@property (nonatomic,assign) BOOL isItemSort;


/* 🐱 排列样式
 默认 lineStyle = RWAutoTagViewLineStylele_AutoLine
 */
@property (nonatomic,assign) RWAutoTagViewLineStyle lineStyle; /**< 排列样式 */

/* 🐱 排序样式 根据宽度来判断
 默认 itemAutoSortStyle = RWAutoTagViewItemAutoSortStyleNormal
 只有在 isItemSort = YES时候，itemSortStyle 才有效果
 */
@property (nonatomic,assign) RWAutoTagViewAutoSortStyle autoSortStyle; /**< 排序样式 */

@property (nonatomic,readonly) NSArray *buttons;/* 🐱 按钮存放数组 */

/* 🐱 RWAutoTagButton 点击事件Block
 autoTagView 当前的RWAutoTagView
 index 表示点击的第几个RWAutoTagButton
 如果使用的RWAutoTagViewDelegate 请使用代理方法
 
 */
@property (nonatomic,strong) void (^autoTagButtonClickBlock)(RWAutoTagView *autoTagView,NSInteger index);

+ (instancetype)autoTagViewWithAutoSortStyle:(RWAutoTagViewAutoSortStyle)autoSortStyle;


- (void)insertAutoTagButtonAtIndex:(NSInteger)index autoTagButtonAtAnimation:(BOOL)animation;/* 🐱 添加一个RWAutoTagButton */
- (void)removeAutoTagButtonAtIndex:(NSInteger)index autoTagButtonAtAnimation:(BOOL)animation;/* 🐱 删除一个RWAutoTagButton */
- (nullable __kindof RWAutoTagButton *)autoTagButtonAtIndex:(NSInteger)index;/* 🐱 返回一个RWAutoTagButton对象 */

- (void)reloadData;/* 🐱 刷新数据 */




@end



#pragma mark - 协议一： 代理对象  数据源

@protocol RWAutoTagViewDataSource <NSObject>

- (NSInteger)numberOfAutoTagButtonInAutoTagView:(RWAutoTagView *)autoTagView;
- (RWAutoTagButton *)autoTagView:(RWAutoTagView *)autoTagView autoTagButtonForAtIndex:(NSInteger)index;




@optional
- (CGFloat)safeAreaLayoutMaxWidthInAutoTagView:(RWAutoTagView *)autoTagView;
- (RWAutoTag *)autoTagView:(RWAutoTagView *)autoTagView ;


@end


#pragma mark - 协议二：  提供的一些事件时机给 代理对象

@protocol RWAutoTagViewDelegate <NSObject>

@optional

- (void)autoTagView:(RWAutoTagView *)autoTagView autoLayoutAutoTagButtonAtIndex:(NSInteger )index;
- (void)autoTagView:(RWAutoTagView *)autoTagView didSelectAutoTagButtonAtIndex:(NSInteger )index;


@end

NS_ASSUME_NONNULL_END
