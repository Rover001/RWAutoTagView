//
//  RWAutoTagView.m
//  RWAutoTagViewDemo
//
//  Created by 曾云 on 2019/10/27.
//  Copyright © 2019 曾云. All rights reserved.
//

#import "RWAutoTagView.h"
#import "UIView+RWExtension.h"
#import "RWAutoTagButton.h"


@interface RWAutoTagView ()

/* 🐱 存放RWAutoTagButton的数组 */
@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,assign) NSInteger currentCount; /**< 当前的RWAutoTagButton 总数量 */
@property (nonatomic,assign) BOOL isAnimation; /**< 是否动画、在insert 或者 remove有效果  默认是不需要动画 */
@property (nonatomic,strong) RWAutoTagButton *animationAutoTagButton;/* 需要执行动画的按钮 */
@property (nonatomic,assign) CGSize rw_currentSize;/* 大小 */

@end

@implementation RWAutoTagView

#pragma mark - init
- (instancetype)initAutoTagViewWithLineStyle:(RWAutoTagViewLineStyle)lineStyle {
    self = [super init];
    if (self) {self.lineStyle = lineStyle;}
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {[self initAttribute];}
    return self;
}

/*  xib加载  */
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {[self initAttribute];}
    return self;
}
#pragma mark -- init Attribute
- (void)initAttribute {
    self.insets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.lineSpacing = 10;
    self.lineitemSpacing = 10;
    self.safeAreaLayoutMaxWidth = [UIScreen mainScreen].bounds.size.width;
    self.fullSafeAreaStyle = RWAutoTagViewFullSafeAreaStyle_MaxWidth;
    self.showSingleLineSpacing = NO;
    self.lineStyle = RWAutoTagViewLineStyle_DynamicMulti;
    _equallyNumber = 0;
    self.currentCount = 0;
    self.buttons = [NSMutableArray array];
    self.isAnimation = YES;
    self.rw_currentSize = CGSizeZero;
    
    if (_dataSource) {
        [self reloadData];
    }
}


#pragma mark -- init RWAutoTagButton

- (void)initAutaTagButton {
    if (!self.dataSource) {
        return;
    }
    
    NSInteger count = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfAutoTagButtonInAutoTagView:)]) {
       count = [self.dataSource numberOfAutoTagButtonInAutoTagView:self];
    }
    for (NSInteger i = 0; i<count; i++) {
       if (self.dataSource && [self.dataSource respondsToSelector:@selector(autoTagView:autoTagButtonForAtIndex:)]) {
           RWAutoTagButton *autoTagButton = [self.dataSource autoTagView:self autoTagButtonForAtIndex:i];
           autoTagButton.tag = i+1000;
           /*  测试使用
           autoTagButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
           autoTagButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
           autoTagButton.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
           autoTagButton.lineitemSpacing = 10.0f;
            */

           autoTagButton.safeAreaLayoutMaxWidth = self.safeAreaLayoutMaxWidth - self.insets.left - self.insets.right;
           if (self.dataSource && [self.dataSource respondsToSelector:@selector(safeAreaLayoutMaxWidthInAutoTagView:)]) {
               CGFloat safeAreaLayoutMaxWidth = [self.dataSource safeAreaLayoutMaxWidthInAutoTagView:self];
               if (safeAreaLayoutMaxWidth > self.safeAreaLayoutMaxWidth) {
                   safeAreaLayoutMaxWidth = self.safeAreaLayoutMaxWidth;
               }
               autoTagButton.safeAreaLayoutMaxWidth = safeAreaLayoutMaxWidth - self.insets.left - self.insets.right;
           }
           if (self.lineStyle == RWAutoTagViewLineStyle_DynamicFixedMulti ||
               self.lineStyle == RWAutoTagViewLineStyle_DynamicFixedEquallyMulti) {
               autoTagButton.isDynamicFixed = YES;
               autoTagButton.dynamicFixedSize = CGSizeMake(autoTagButton.safeAreaLayoutMaxWidth, UITableViewAutomaticDimension);
               
               if (self.dataSource && [self.dataSource respondsToSelector:@selector(autoTagView:autoTagButtonWidthForAtIndex:)]) {
                   CGFloat width = [self.dataSource autoTagView:self autoTagButtonWidthForAtIndex:i];
                   if (width > autoTagButton.safeAreaLayoutMaxWidth) {
                       width= autoTagButton.safeAreaLayoutMaxWidth;
                   }
                   autoTagButton.dynamicFixedSize = CGSizeMake(width, UITableViewAutomaticDimension);
               }
               
               if (self.lineStyle == RWAutoTagViewLineStyle_DynamicFixedEquallyMulti) {
                   _equallyNumber = 1;
                   if (self.dataSource && [self.dataSource respondsToSelector:@selector(equallyNumberOfAutoTagButtonInautoTagView:)]) {
                       _equallyNumber = [self.dataSource equallyNumberOfAutoTagButtonInautoTagView:self];
                       if (_equallyNumber <=0) {
                           _equallyNumber = 1;
                       }
                     }
                   NSLog(@"autoTagButton.safeAreaLayoutMaxWidth:%f",autoTagButton.safeAreaLayoutMaxWidth);
                   CGFloat width = (autoTagButton.safeAreaLayoutMaxWidth - (self.lineitemSpacing *(self.equallyNumber -1)))/self.equallyNumber;
                   autoTagButton.dynamicFixedSize = CGSizeMake(width, UITableViewAutomaticDimension);
               }
           }
           
           
           [autoTagButton addTarget:self action:@selector(autoTagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//               [autoTagButton setNeedsLayout];
           NSLog(@"%@",NSStringFromCGSize([autoTagButton intrinsicContentSize]));
           [self addSubview:autoTagButton];
           [self.buttons addObject:autoTagButton];
       }
   }
       self.currentCount = self.buttons.count;
}

#pragma mark - RWAutoTagButton 点击事件
- (void)autoTagButtonClick:(RWAutoTagButton *)autoTagButton {
    /* 🐱 代理回调 */
    if (self.delegate && [self.delegate respondsToSelector:@selector(autoTagView:didSelectAutoTagButtonAtIndex:)]) {
        [self.delegate autoTagView:self didSelectAutoTagButtonAtIndex:autoTagButton.tag-1000];
    }
    
    /* 🐱 Block 回调 */
    if (self.autoTagButtonClickBlock) {
        self.autoTagButtonClickBlock(self, autoTagButton.tag-1000);
    }
    NSLog(@"%s",__func__);
}


#pragma mark - Set Attribute

- (void)setCurrentCount:(NSInteger)currentCount {
    _currentCount = currentCount;
}

- (void)setDataSource:(id<RWAutoTagViewDataSource>)dataSource {
    if (_dataSource !=dataSource) {
        _dataSource = dataSource;
        if (_dataSource) {
            [self reloadData];
        }
    }
}

- (void)setDelegate:(id<RWAutoTagViewDelegate>)delegate {
    if (_delegate !=delegate) {
        _delegate = delegate;
        if (_dataSource && _delegate) {
            [self setNeedsLayout];
        }
    }
}

- (void)setLineStyle:(RWAutoTagViewLineStyle)lineStyle {
    if (_lineStyle !=lineStyle) {
        _lineStyle = lineStyle;
        [self reloadData];
    }
}

- (void)setInsets:(UIEdgeInsets)insets {
    _insets = insets;
    [self reloadData];
}

- (void)setSafeAreaLayoutMaxWidth:(CGFloat)safeAreaLayoutMaxWidth {
    if (_safeAreaLayoutMaxWidth != safeAreaLayoutMaxWidth) {
        _safeAreaLayoutMaxWidth = safeAreaLayoutMaxWidth;
        [self setNeedsLayout];
    }
}

- (void)setFullSafeAreaStyle:(RWAutoTagViewFullSafeAreaStyle)fullSafeAreaStyle {
    if (_fullSafeAreaStyle != fullSafeAreaStyle) {
        _fullSafeAreaStyle = fullSafeAreaStyle;
        [self setNeedsLayout];
        self.rw_size = [self intrinsicContentSize];
    }
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    if (_lineSpacing != lineSpacing) {
        _lineSpacing = lineSpacing;
        [self setNeedsLayout];
    }
}


#pragma mark - 增、删 RWAutoTagButton

- (void)autoTagButtonAtIndex:(NSInteger)index buttons:(NSInteger)buttons errMsg:(NSString *)errMsg {
    //判断下标index是否越界
    if (index < 0) {
        errMsg = [NSString stringWithFormat:@"%@  index：%ld  数组 bounds [0 .. %ld]",errMsg,(long)index,(long)buttons];
        NSAssert(index >= 0,errMsg);
    } else {
        if (index >= buttons) {
            if (index !=0 || buttons !=0) {
                errMsg = [NSString stringWithFormat:@"%@  index:%ld  数组 bounds [0 .. %ld]",errMsg,(long)index,(long)buttons];
                NSAssert(index < buttons,errMsg);
            }
        }
    }
}

- (void)insertAutoTagButtonAtIndex:(NSInteger)index autoTagButtonAtAnimation:(BOOL)animation {
    [self autoTagButtonAtIndex:index buttons:self.buttons.count errMsg:[NSString stringWithFormat:@"%s",__func__]];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(autoTagView:autoTagButtonForAtIndex:)]) {
        
        NSInteger number = 0;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfAutoTagButtonInAutoTagView:)]) {
           number = [self.dataSource numberOfAutoTagButtonInAutoTagView:self];
        }
        if (index >= number) {
            NSString *errMsg = [NSString stringWithFormat:@"%@  index:%ld  数组 bounds [0 .. %ld]",[NSString stringWithFormat:@"%s",__func__],(long)index,number -1];
            NSAssert(index < number,errMsg);
        }
        
        
//        if (number >= self.currentCount) {
//            NSString *errMsg = [NSString stringWithFormat:@"%@  delegate Number:%ld  数组 bounds [0 .. %ld]",[NSString stringWithFormat:@"%s",__func__],(long)number,self.currentCount -1];
//            NSAssert(number < self.currentCount,errMsg);
//        }
        self.currentCount  ++;
        
        RWAutoTagButton *autoTagButton = [self.dataSource autoTagView:self autoTagButtonForAtIndex:index];
        autoTagButton.tag = index+1000;
        [autoTagButton addTarget:self action:@selector(autoTagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (index <0 || index >=self.buttons.count) {
            [self.buttons addObject:autoTagButton];
        } else {
            [self.buttons insertObject:autoTagButton atIndex:index];
        }
        [self insertSubview:autoTagButton atIndex:index];
        if (animation) {
            self.animationAutoTagButton = autoTagButton;
        }
        [self setNeedsLayout];
    } else {
        NSLog(@"请实现代理方法：%s",__func__);
    }
}

- (void)removeAutoTagButtonAtIndex:(NSInteger)index autoTagButtonAtAnimation:(BOOL)animation {
    [self autoTagButtonAtIndex:index buttons:self.buttons.count-1 errMsg:[NSString stringWithFormat:@"%s",__func__]];
    if (self.buttons.count == 0) {
       NSString *errMsg = [NSString stringWithFormat:@"%s  index：%ld  数组 bounds [0 .. 0]",__func__,(long)index];
       NSAssert(self.buttons.count >0,errMsg);
   }
    [self.buttons removeObjectAtIndex:index];
    [[self autoTagButtonAtIndex:index] removeFromSuperview];
    self.currentCount --;
    [self setNeedsLayout];
}

- (nullable __kindof RWAutoTagButton *)autoTagButtonAtIndex:(NSInteger)index {
    [self autoTagButtonAtIndex:index buttons:self.subviews.count errMsg:[NSString stringWithFormat:@"%s",__func__]];
    return [self viewWithTag:index +1000];
}

#pragma mark - 刷新数据

- (void)reloadData {
    
    /* 🐱 清除按钮数组 */
    [self.buttons removeAllObjects];
    /* 🐱 清除self.subviews中的RWAutoTagButton对象 */
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[RWAutoTagButton class]]) {
            [subView removeFromSuperview];
        }
    }
    /* 🐱 重新创建RWAutoTagButton对象 */
    [self initAutaTagButton];
}


#pragma mark - layout contentSize

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutContentSize];
    NSLog(@"rw_size:%@",NSStringFromCGSize(self.rw_size));
}

- (CGSize)intrinsicContentSize {
    return [self layoutContentSize];
}

- (CGSize)layoutContentSize {
    
    CGSize newSize = CGSizeZero;
    
    switch (self.lineStyle) {
        case RWAutoTagViewLineStyle_DynamicSingle:
        {
            newSize = [self reloadRWAutoTagViewLineStyle_DynamicSingle];
        }
            break;
       
        case RWAutoTagViewLineStyle_DynamicMulti:
        {
            newSize = [self reloadRWAutoTagViewLineStyle_DynamicMulti];
        }
            break;
            
        case RWAutoTagViewLineStyle_DynamicFixedMulti:
        {
            newSize = [self reloadRWAutoTagViewLineStyle_DynamicFixed];
        }
            break;
            
        case RWAutoTagViewLineStyle_DynamicFixedEquallyMulti:
        {
            newSize = [self reloadRWAutoTagViewLineStyle_DynamicFixed];
        }
            break;
        default:
            break;
    }
    self.rw_size = newSize;
    return newSize;
}

#pragma mark -- RWAutoTagViewLineStyle_DynamicSingle 计算动态单行

- (CGSize)reloadRWAutoTagViewLineStyle_DynamicSingle {
    if (self.buttons.count == 0) {
        return CGSizeZero;
    }
    NSArray *subviews = self.subviews;
    CGFloat lineSpacing = self.lineSpacing;
    
    CGFloat top = self.insets.top;
    CGFloat left = self.insets.left;
    CGFloat right = self.insets.right;
    CGFloat bottom = self.insets.bottom;
    
    CGFloat intrinsicHeight = 0.0f;
    CGFloat intrinsicWidth = left + right;
    CGFloat current_X = left;
    CGFloat current_Y = top;
    
    CGFloat lineMaxWidth = 0.0f;
    
    NSInteger index = 0;
    
    for (UIView *view in subviews) {
        if ([view isKindOfClass:[RWAutoTagButton class]]) {
            RWAutoTagButton *autoTagButton = (RWAutoTagButton *)view;
            CGSize size = autoTagButton.intrinsicContentSize;
            CGFloat width = size.width;
            CGFloat height = size.height;
            if ((size.width >= self.safeAreaLayoutMaxWidth) ||
                (width + left +right) >= self.safeAreaLayoutMaxWidth) {
                width = self.safeAreaLayoutMaxWidth - left -right;
//                intrinsicHeight += height;
            }
            
            lineMaxWidth = MAX(lineMaxWidth, width);
            [self autoTagButton:autoTagButton frame:CGRectMake(current_X, current_Y, width, height)];
            current_Y += height;
            index ++;
            if (index < subviews.count) {
                current_Y += lineSpacing;
            }
        }
    }
    intrinsicHeight += (current_Y +bottom);
    lineMaxWidth += (left +right);
    intrinsicWidth = [self initFullSafeAreaWidth:lineMaxWidth];
    return CGSizeMake(intrinsicWidth, intrinsicHeight);
}

#pragma mark -- RWAutoTagViewLineStyle_DynamicMulti 计算动态多行

- (CGSize)reloadRWAutoTagViewLineStyle_DynamicMulti {
    if (self.buttons.count == 0) {
        return CGSizeZero;
    }
    
    NSArray *subviews = self.subviews;
    CGFloat lineSpacing = self.lineSpacing;
    CGFloat lineitemSpacing = self.lineitemSpacing;
    
    CGFloat top = self.insets.top;
    CGFloat left = self.insets.left;
    CGFloat right = self.insets.right;
    CGFloat bottom = self.insets.bottom;
    
    CGFloat intrinsicHeight = top + bottom;
    CGFloat intrinsicWidth = left + right;
    CGFloat current_X = left;
    CGFloat current_Y = top;
    
    CGFloat lineMaxWidth = left + right;
    CGFloat lineMaxHeight = 0.0f;
    
    NSInteger index = 0;
    for (UIView *view in subviews) {
        if ([view isKindOfClass:[RWAutoTagButton class]]) {
            RWAutoTagButton *autoTagButton = (RWAutoTagButton *)view;
            CGSize size = autoTagButton.intrinsicContentSize;
            CGFloat width = size.width;
            CGFloat height = size.height;
            CGFloat lineitemMaxWidth = current_X +width +right;
            if ((width >= self.safeAreaLayoutMaxWidth) ||
                (lineitemMaxWidth >= self.safeAreaLayoutMaxWidth) ||
                ((lineitemMaxWidth + lineitemSpacing) >= self.safeAreaLayoutMaxWidth)) {
                current_X = left;
                
                current_Y += (lineSpacing +lineMaxHeight);
                intrinsicHeight += (lineSpacing +lineMaxHeight);
                width  = MIN(width, self.safeAreaLayoutMaxWidth - left - right);
//                autoTagButton.frame = CGRectMake(current_X, current_Y, width, height);
                [self autoTagButton:autoTagButton frame:CGRectMake(current_X, current_Y, width, height)];
                lineMaxHeight = height;
                current_X += (lineitemSpacing + width);
                lineMaxWidth = MAX(lineMaxWidth, current_X);
                index ++;
                if (index == subviews.count) {
                    intrinsicHeight += lineMaxHeight;
                }
                
            } else {
                lineMaxHeight = MAX(height, lineMaxHeight);
//                autoTagButton.frame = CGRectMake(current_X, current_Y, width, height);
                [self autoTagButton:autoTagButton frame:CGRectMake(current_X, current_Y, width, height)];
                current_X += (lineitemSpacing + width);
                lineMaxWidth = MAX(lineMaxWidth, current_X);
                index ++;
                if (index == subviews.count) {
                    intrinsicHeight += lineMaxHeight;
                }
            }
            
        }
    }

    intrinsicWidth = [self initFullSafeAreaWidth:lineMaxWidth];
    return CGSizeMake(intrinsicWidth, intrinsicHeight);
}

#pragma mark -- reloadRWAutoTagViewLineStyle_DynamicFixed 计算动态固定多行

- (CGSize)reloadRWAutoTagViewLineStyle_DynamicFixed {
    
    if (self.buttons.count == 0) {
            return CGSizeZero;
        }
        
        NSArray *subviews = self.subviews;
        CGFloat lineSpacing = self.lineSpacing;
        CGFloat lineitemSpacing = self.lineitemSpacing;
        
        CGFloat top = self.insets.top;
        CGFloat left = self.insets.left;
        CGFloat right = self.insets.right;
        CGFloat bottom = self.insets.bottom;
        
        CGFloat intrinsicHeight = top + bottom;
        CGFloat intrinsicWidth = left + right;
        CGFloat current_X = left;
        CGFloat current_Y = top;
        
        CGFloat lineMaxWidth = left + right;
        CGFloat lineMaxHeight = 0.0f;
        
        NSInteger index = 0;
        for (UIView *view in subviews) {
            if ([view isKindOfClass:[RWAutoTagButton class]]) {
                RWAutoTagButton *autoTagButton = (RWAutoTagButton *)view;
                CGSize size = autoTagButton.intrinsicContentSize;
                CGFloat width = size.width;
                CGFloat height = size.height;
                CGFloat lineitemMaxWidth = current_X +width +right;
                lineitemMaxWidth = ceilf(lineitemMaxWidth *100)/100;
                if ((width > self.safeAreaLayoutMaxWidth) ||
                    (lineitemMaxWidth > self.safeAreaLayoutMaxWidth)) {
                    current_X = left;
                    
                    current_Y += (lineSpacing +lineMaxHeight);
                    intrinsicHeight += (lineSpacing +lineMaxHeight);
                    width  = MIN(width, self.safeAreaLayoutMaxWidth - left - right);
    //                autoTagButton.frame = CGRectMake(current_X, current_Y, width, height);
                    [self autoTagButton:autoTagButton frame:CGRectMake(current_X, current_Y, width, height)];
                    lineMaxHeight = height;
                    current_X += (lineitemSpacing + width);
                    lineMaxWidth = MAX(lineMaxWidth, current_X);
                    index ++;
                    if (index == subviews.count) {
                        intrinsicHeight += lineMaxHeight;
                    }
                    
                } else {
                    lineMaxHeight = MAX(height, lineMaxHeight);
    //                autoTagButton.frame = CGRectMake(current_X, current_Y, width, height);
                    [self autoTagButton:autoTagButton frame:CGRectMake(current_X, current_Y, width, height)];
                    current_X += (lineitemSpacing + width);
                    lineMaxWidth = MAX(lineMaxWidth, current_X);
                    index ++;
                    if (index == subviews.count) {
                        intrinsicHeight += lineMaxHeight;
                    }
                }
                
            }
        }

        
        intrinsicWidth = [self initFullSafeAreaWidth:lineMaxWidth];
        return CGSizeMake(intrinsicWidth, intrinsicHeight);
}

#pragma mark --- 根据宽度显示样式 来返回宽度
- (CGFloat)initFullSafeAreaWidth:(CGFloat)newIntrinsicWidth {
    CGFloat fullSafeAreaWidth = CGFLOAT_MIN;
    switch (self.fullSafeAreaStyle) {
        case RWAutoTagViewFullSafeAreaStyle_MaxWidth:
            fullSafeAreaWidth = self.safeAreaLayoutMaxWidth;
            break;
            
        case RWAutoTagViewFullSafeAreaStyle_AutoWidth:
            fullSafeAreaWidth = newIntrinsicWidth;
            break;
            
        default:
            break;
    }
    return fullSafeAreaWidth;
}


#pragma mark --- autoTagButton 动画
- (void)autoTagButton:(RWAutoTagButton *)autoTagButton frame:(CGRect)frame {
    CGRect rect = CGRectMake(frame.origin.x, frame.origin.y, 0, frame.size.height);
    if (self.animationAutoTagButton && self.animationAutoTagButton == autoTagButton) {
        autoTagButton.frame = rect;
        [UIView animateWithDuration:1 animations:^{
            autoTagButton.frame = frame;
        }];
        self.isAnimation = NO;
        self.animationAutoTagButton = nil;
    } else {
        autoTagButton.frame = frame;
    }
}


#pragma mark - 废弃

/*  DEPRECATED_MSG_ATTRIBUTE(" 'RWAutoTagView','~> 0.1.4',初始化方法废弃")  */
- (instancetype)initWithAutoSortStyle:(RWAutoTagViewAutoSortStyle)autoSortStyle {
    self = [super init];
    if (self) {_autoSortStyle = autoSortStyle;}
    return self;
}

+ (instancetype)autoTagViewWithAutoSortStyle:(RWAutoTagViewAutoSortStyle)autoSortStyle {
    return [[self alloc]initWithAutoSortStyle:autoSortStyle];
}

/*
// Only override drawRect: if you perform RW drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
