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
    RWAutoTagViewLineStyle_AutoLine,         /**< 默认 动态显示 */
    
    /* 🐱 动态-单行显示  单个AutoTagButton标签显示一行 */
    RWAutoTagViewLineStyle_DynamicSingle = RWAutoTagViewLineStyle_SingleLine,
    /* 🐱 动态-多行显示  根据AutoTagButton标签宽度来计算的 */
    RWAutoTagViewLineStyle_DynamicMulti = RWAutoTagViewLineStyle_AutoLine,
    
    
    
    /* 🐱 宽度不能超过最大显示宽度 */
    /* 🐱 动态-固定AutoTagButton标签宽度-多行显示
     属于动态多行显示中特殊的存在，设置AutoTagButton标签固定宽度
     需实现代理 '- (CGSize)autoTagView:(RWAutoTagView *)autoTagView autoTagButtonSizeForAtIndex:(NSInteger)index'
    */
    RWAutoTagViewLineStyle_DynamicFixedMulti,
    
    /* 🐱 动态-固定平分宽度-多行显示
     属于RWAutoTagViewLineStyle_Fixed 中特殊的一种  每行中的AutoTagButton标签宽度相等
     代理'- (NSInteger)equallyNumberOfAutoTagButtonInautoTagView:(RWAutoTagView *)autoTagView;' 返回每行平分标签的数量 可用equallyNumber（可读）获取
     
     
     一、如果实现代理'- (NSInteger)equallyNumberOfAutoTagButtonInautoTagView:(RWAutoTagView *)autoTagView;'
        那么代理'- (CGSize)autoTagView:(RWAutoTagView *)autoTagView autoTagButtonSizeForAtIndex:(NSInteger)index' 可不实现
     
     二、代理'- (NSInteger)equallyNumberOfAutoTagButtonInautoTagView:(RWAutoTagView *)autoTagView;' 没有实现，
        可实现代理'- (CGSize)autoTagView:(RWAutoTagView *)autoTagView autoTagButtonSizeForAtIndex:(NSInteger)index' 而达到效果
        那就是每行返回的CGSzie必须宽度相等
        比如：每行显示3个
        height：AutoTagButton标签高
        width ：safeAreaLayoutMaxWidth
        如果实现代理 '- (CGFloat)safeAreaLayoutMaxWidthInAutoTagView:(RWAutoTagView *)autoTagView;'
        width:代理返回宽度
        
        CGSizeMake(width/3, height) 这样就可以达到效果
     */
    RWAutoTagViewLineStyle_DynamicFixedEquallyMulti
};

/* 🐱 排序样式 根据宽度来判断  排列样式为 动态显示时候有效
DEPRECATED_MSG_ATTRIBUTE("🐱'RWAutoTagView','~> 0.1.4'废弃;请自行对RWAutoTagButton进行排序或者RWAutoTag进行排序")
 */
typedef NS_ENUM(NSInteger,RWAutoTagViewAutoSortStyle) {
    /**< 默认 根据传入顺序直接展示 */
    RWAutoTagViewAutoSortStyleNormal = 0,
    RWAutoTagViewAutoSortStyleDescending, /** 升序  宽度最长在上面 */
    RWAutoTagViewAutoSortStyleAscending  /** 降序 宽度最短在上面 */
};


/* 🐱 当前宽度显示的样式  排列样式为 动态显示时候有效 */
typedef NS_ENUM(NSInteger,RWAutoTagViewFullSafeAreaStyle) {
    
    /**< 默认 根据safeAreaLayoutMaxWidth值为宽度  */
    RWAutoTagViewFullSafeAreaStyle_MaxWidth = 0,
    /** 自动根据控件布局来计算宽度 但不超过最大显示宽度 */
    RWAutoTagViewFullSafeAreaStyle_AutoWidth
};

//NS_DESIGNATED_INITIALIZER  NS_UNAVAILABLE

@interface RWAutoTagView : UIView

@property (nonatomic,weak,nullable) IBOutlet id <RWAutoTagViewDataSource>dataSource;
@property (nonatomic,weak,nullable) IBOutlet id <RWAutoTagViewDelegate>delegate;


/* 内边距 默认 UIEdgeInsetsMake(0,0,0,0) */
@property (nonatomic,assign) UIEdgeInsets insets;

/* 行间距 默认 lineSpacing = 10.0f */
@property (nonatomic,assign) CGFloat lineSpacing;

/* 行内item间距 默认lineitemSpacing = 10.0f */
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

/* 🐱 排列样式
 默认 lineStyle = RWAutoTagViewLineStylele_AutoLine
 */
@property (nonatomic,assign) RWAutoTagViewLineStyle lineStyle; /**< 排列样式 */

/* 平分的标签数量 默认0
 lineStyle = RWAutoTagViewLineStyle_FixedEqually 值大于0  */
@property (nonatomic,readonly) CGFloat equallyNumber;


/* 🐱 排序样式 根据宽度来判断
 默认 itemAutoSortStyle = RWAutoTagViewItemAutoSortStyleNormal
 只有在 isItemSort = YES时候，itemSortStyle 才有效果
 */
 /**< 排序样式 */
@property (nonatomic,assign) RWAutoTagViewAutoSortStyle autoSortStyle DEPRECATED_MSG_ATTRIBUTE("🐱'RWAutoTagView','~> 0.1.4'废弃;请自行对RWAutoTagButton进行排序或者RWAutoTag进行排序");

/* 对允许item进行排序  默认 isItemSort = YES */
@property (nonatomic,assign) BOOL isItemSort DEPRECATED_MSG_ATTRIBUTE("🐱'RWAutoTagView','~> 0.1.4'废弃;请自行对RWAutoTagButton进行排序或者RWAutoTag进行排序");

/* 🐱 RWAutoTagButton 点击事件Block
 autoTagView 当前的RWAutoTagView
 index 表示点击的第几个RWAutoTagButton
 如果使用的RWAutoTagViewDelegate 请使用代理方法
 */
@property (nonatomic,strong) void (^autoTagButtonClickBlock)(RWAutoTagView *autoTagView,NSInteger index);

/// 初始化  使用排列样式初始化
/// @param lineStyle 排列样式
- (instancetype)initAutoTagViewWithLineStyle:(RWAutoTagViewLineStyle)lineStyle;


+ (instancetype)autoTagViewWithAutoSortStyle:(RWAutoTagViewAutoSortStyle)autoSortStyle __attribute__((unavailable("🐱'RWAutoTagView','~> 0.1.4',初始化方法废弃")));





- (void)insertAutoTagButtonAtIndex:(NSInteger)index autoTagButtonAtAnimation:(BOOL)animation;/* 🐱 添加一个RWAutoTagButton */
- (void)removeAutoTagButtonAtIndex:(NSInteger)index autoTagButtonAtAnimation:(BOOL)animation;/* 🐱 删除一个RWAutoTagButton */
- (nullable __kindof RWAutoTagButton *)autoTagButtonAtIndex:(NSInteger)index;/* 🐱 返回一个RWAutoTagButton对象 */

- (void)reloadData;/* 🐱 刷新数据 */




@end



#pragma mark - 协议一： 代理对象  数据源

@protocol RWAutoTagViewDataSource <NSObject>

/* 🐱 总共有多少个AutoTagButton标签对象 */
- (NSInteger)numberOfAutoTagButtonInAutoTagView:(RWAutoTagView *)autoTagView;

/* 🐱 返回AutoTagButton标签对象 */
- (RWAutoTagButton *)autoTagView:(RWAutoTagView *)autoTagView autoTagButtonForAtIndex:(NSInteger)index;

@optional

/*  返回safeAreaLayoutMaxWidth的值  不实现次代理 默认值 [UIScreen mainScreen].bounds.size.width  */
- (CGFloat)safeAreaLayoutMaxWidthInAutoTagView:(RWAutoTagView *)autoTagView;

/* 🐱 默认值
 width ：safeAreaLayoutMaxWidth
 如果实现代理 '- (CGFloat)safeAreaLayoutMaxWidthInAutoTagView:(RWAutoTagView *)autoTagView;'
 width:代理返回宽度
 宽度不能超过最大显示宽度 */
- (CGFloat)autoTagView:(RWAutoTagView *)autoTagView autoTagButtonWidthForAtIndex:(NSInteger)index;
/* 🐱 返回平分标签数量 自动计算宽度 不会使用代理'- (CGFloat)autoTagView:(RWAutoTagView *)autoTagView autoTagButtonWidthForAtIndex:(NSInteger)index'返回值*/
- (NSInteger)equallyNumberOfAutoTagButtonInautoTagView:(RWAutoTagView *)autoTagView;
@end


#pragma mark - 协议二：  提供的一些事件时机给 代理对象

@protocol RWAutoTagViewDelegate <NSObject>

@optional

/*  RWAutoTagButton 点击事件代理  */
- (void)autoTagView:(RWAutoTagView *)autoTagView didSelectAutoTagButtonAtIndex:(NSInteger )index;


@end

NS_ASSUME_NONNULL_END
