## RWAutoTagView 标签展示
![pod-v0.1.4](https://img.shields.io/badge/pod-v0.1.4-brightgreen.svg) 
![language](https://img.shields.io/badge/language-Objective--C-orange.svg)
![platform-iOS-9.0+](https://img.shields.io/badge/platform-iOS%209.0%2B-ff69b4.svg)

@[博客-自定义标签管理RWAutoTagView](https://blog.csdn.net/RoverWord/article/details/102827798)

使用CocoaPods安装  `pod 'RWAutoTagView'`

导入 `#import "RWAutoTagHeader.h"` 

```objc
#ifndef RWAutoTagHeader_h
#define RWAutoTagHeader_h

#import "UIView+RWExtension.h"
#import "NSBundle+RWAutoTag.h"

#import "RWAutoTag.h"
#import "RWAutoTagButton.h"
#import "RWAutoTagView.h"


#endif /* RWAutoTagHeader_h */

```
## Contents

* [RWAutoTagView.h](#RWAutoTagView.h)
* [RWAutoTagButton.h](#RWAutoTagButton.h)
* [RWAutoTag.h](#RWAutoTag.h)

## RWAutoTagViewDemo

#### RWAutoTagViewViewController.h
  Xib、Storyboard创建标签集合-RWAutoTagView  
  
#### RWAutoTagViewPureCodeViewController.h
  纯代码创建标签集合-RWAutoTagView
  
#### RWAutoTagButtonViewController.h
Xib、Storyboard创建标签集合-RWAutoTagButton

#### RWAutoTagButtonPureCodeViewController.h
纯代码创建标签集合-RWAutoTagButton


## <a id="RWAutoTagView.h"></a>RWAutoTagView.h
```objc

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

end
```

## <a id="RWAutoTagButton.h"></a>RWAutoTagButton.h

```objc

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
```
## <a id="RWAutoTag.h"></a>RWAutoTag.h

```objc

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

```


  
