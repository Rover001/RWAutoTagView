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

- (instancetype)initAutoTagViewWithRangeStyle:(RWAutoTagViewRangeStyle)rangeStyle {
    self = [super init];
    if (self) {self.rw_rangeStyle = rangeStyle;}
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
    self.rw_insets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.rw_lineSpacing = 10.0f;
    self.rw_itemSpacing = 10.0f;
    self.rw_safeAreaLayoutMaxWidth = [UIScreen mainScreen].bounds.size.width;
    self.rw_fullSafeAreaStyle = RWAutoTagViewFullSafeAreaStyle_MaxWidth;
    self.rw_showSingleLineSpacing = NO;
    self.rw_rangeStyle = RWAutoTagViewRangeStyle_DynamicMulti;
    _rw_equallyNumber = 0;
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
           autoTagButton.rw_isDynamicFixed = NO;
           if (autoTagButton.tag <= 0) {
               autoTagButton.tag = i+10000;
           }
           autoTagButton.rw_safeAreaLayoutMaxWidth = self.rw_safeAreaLayoutMaxWidth - self.rw_insets.left - self.rw_insets.right;
           
           if (self.dataSource && [self.dataSource respondsToSelector:@selector(safeAreaLayoutMaxWidthInAutoTagView:)]) {
               CGFloat safeAreaLayoutMaxWidth = [self.dataSource safeAreaLayoutMaxWidthInAutoTagView:self];
               if (safeAreaLayoutMaxWidth > self.rw_safeAreaLayoutMaxWidth) {
                   safeAreaLayoutMaxWidth = self.rw_safeAreaLayoutMaxWidth;
               }
               autoTagButton.rw_safeAreaLayoutMaxWidth = safeAreaLayoutMaxWidth - self.rw_insets.left - self.rw_insets.right;
           }
           if (self.rw_rangeStyle == RWAutoTagViewRangeStyle_DynamicFixed ||
               self.rw_rangeStyle == RWAutoTagViewRangeStyle_DynamicFixedEqually) {
               BOOL isFixedEqually = NO;
               BOOL isFixed = NO;
               CGFloat autoTagButton_Width = autoTagButton.rw_safeAreaLayoutMaxWidth;
               CGFloat autoTagButton_Height = UITableViewAutomaticDimension;
               autoTagButton.rw_isDynamicFixed = YES;
               /*  代理返回宽高  */
               if (self.dataSource && [self.dataSource respondsToSelector:@selector(autoTagView:autoTagButtonSizeForAtIndex:)]) {
                   autoTagButton_Width = [self.dataSource autoTagView:self autoTagButtonSizeForAtIndex:i].width;
                   autoTagButton_Height = [self.dataSource autoTagView:self autoTagButtonSizeForAtIndex:i].height;
                   if (autoTagButton_Width > autoTagButton.rw_safeAreaLayoutMaxWidth) {
                       autoTagButton_Width = autoTagButton.rw_safeAreaLayoutMaxWidth;
                   }
                   isFixed = YES;
                   isFixedEqually = YES;
               } else {
                   /*  代理返回宽度  */
                   if (self.dataSource && [self.dataSource respondsToSelector:@selector(autoTagView:autoTagButtonWidthForAtIndex:)]) {
                       autoTagButton_Width = [self.dataSource autoTagView:self autoTagButtonWidthForAtIndex:i];
                       if (autoTagButton_Width > autoTagButton.rw_safeAreaLayoutMaxWidth) {
                           autoTagButton_Width = autoTagButton.rw_safeAreaLayoutMaxWidth;
                       }
                       isFixed = YES;
                       
                   }
                   
                   /*  代理返回高度  */
                   
                   if (self.dataSource && [self.dataSource respondsToSelector:@selector(autoTagView:autoTagButtonHeightForAtIndex:)]) {
                       autoTagButton_Height = [self.dataSource autoTagView:self autoTagButtonHeightForAtIndex:i];
                       isFixed = YES;
                       isFixedEqually = YES;
                   }
               }
               autoTagButton.rw_dynamicFixedSize = CGSizeMake(autoTagButton_Width, autoTagButton_Height);
               NSAssert(isFixed == YES,@"请实现代理🐱\n🐱🐱- (CGFloat)autoTagView:(RWAutoTagView *)autoTagView autoTagButtonWidthForAtIndex:(NSInteger)index🐱🐱\n🐱或者🐱\n🐱🐱- (CGSize)autoTagView:(RWAutoTagView *)autoTagView autoTagButtonSizeForAtIndex:(NSInteger)index🐱🐱\n🐱");
               if (self.rw_rangeStyle == RWAutoTagViewRangeStyle_DynamicFixedEqually) {
                   _rw_equallyNumber = 1;
                   if (self.dataSource && [self.dataSource respondsToSelector:@selector(equallyNumberOfAutoTagButtonInautoTagView:)]) {
                       _rw_equallyNumber = [self.dataSource equallyNumberOfAutoTagButtonInautoTagView:self];
                       if (_rw_equallyNumber <=0) {
                           _rw_equallyNumber = 1;
                       }
                       isFixedEqually = YES;
                   }
//                   NSLog(@"autoTagButton.safeAreaLayoutMaxWidth:%f",autoTagButton.rw_safeAreaLayoutMaxWidth);
                   autoTagButton_Width = (autoTagButton.rw_safeAreaLayoutMaxWidth - (self.rw_itemSpacing *(self.rw_equallyNumber -1)))/self.rw_equallyNumber;
                   autoTagButton.rw_dynamicFixedSize = CGSizeMake(autoTagButton_Width, autoTagButton_Height);
                   NSAssert(isFixedEqually == YES,@"请实现代理🐱\n🐱🐱- (CGFloat)autoTagView:(RWAutoTagView *)autoTagView autoTagButtonWidthForAtIndex:(NSInteger)index🐱🐱\n🐱或者🐱\n🐱🐱- (CGSize)autoTagView:(RWAutoTagView *)autoTagView autoTagButtonSizeForAtIndex:(NSInteger)index🐱🐱\n🐱");
               }
               
           }
           [autoTagButton addTarget:self action:@selector(autoTagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//           NSLog(@"%@",NSStringFromCGSize([autoTagButton intrinsicContentSize]));
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
        [self.delegate autoTagView:self didSelectAutoTagButtonAtIndex:autoTagButton.tag];
    }
    
    /* 🐱 Block 回调 */
    if (self.rw_autoTagButtonClickBlock) {
        self.rw_autoTagButtonClickBlock(self, autoTagButton.tag);
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

- (void)setRw_rangeStyle:(RWAutoTagViewRangeStyle)rw_rangeStyle {
    if (_rw_rangeStyle != rw_rangeStyle) {
        _rw_rangeStyle = rw_rangeStyle;
        [self reloadData];
    }
}

- (void)setRw_insets:(UIEdgeInsets)rw_insets {
    _rw_insets = rw_insets;
    [self reloadData];
}

- (void)setRw_safeAreaLayoutMaxWidth:(CGFloat)rw_safeAreaLayoutMaxWidth {
    if (_rw_safeAreaLayoutMaxWidth != rw_safeAreaLayoutMaxWidth) {
        _rw_safeAreaLayoutMaxWidth = rw_safeAreaLayoutMaxWidth;
        [self reloadData];
    }
}


- (void)setFullSafeAreaStyle:(RWAutoTagViewFullSafeAreaStyle)fullSafeAreaStyle {
    if (_fullSafeAreaStyle != fullSafeAreaStyle) {
        _fullSafeAreaStyle = fullSafeAreaStyle;
        [self setNeedsLayout];
        self.rw_size = [self intrinsicContentSize];
    }
}
- (void)setRw_lineSpacing:(CGFloat)rw_lineSpacing {
    if (_rw_lineSpacing != rw_lineSpacing) {
        _rw_lineSpacing = rw_lineSpacing;
        [self setNeedsLayout];
    }
}

- (void)setRw_itemSpacing:(CGFloat)rw_itemSpacing {
   if (_rw_itemSpacing != rw_itemSpacing) {
       _rw_itemSpacing = rw_itemSpacing;
       [self setNeedsLayout];
    }
}
- (void)setRw_showSingleLineSpacing:(BOOL)rw_showSingleLineSpacing {
    if (_rw_showSingleLineSpacing != rw_showSingleLineSpacing) {
        _rw_showSingleLineSpacing = rw_showSingleLineSpacing;
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
    return [self viewWithTag:index];
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
//    NSLog(@"rw_size:%@",NSStringFromCGSize(self.rw_size));
}

- (CGSize)intrinsicContentSize {
    return [self layoutContentSize];
}

- (CGSize)layoutContentSize {
    
    CGSize newSize = CGSizeZero;
    
    switch (self.rw_rangeStyle) {
        case RWAutoTagViewRangeStyle_DynamicSingle:
        {
            newSize = [self reloadRWAutoTagViewRangeStyle_DynamicSingle];
        }
            break;
       
        case RWAutoTagViewRangeStyle_DynamicMulti:
        {
            newSize = [self reloadRWAutoTagViewRangeStyle_DynamicMulti];
        }
            break;
            
        case RWAutoTagViewRangeStyle_DynamicFixed:
        {
            newSize = [self reloadRWAutoTagViewRangeStyle_DynamicFixed];
        }
            break;
            
        case RWAutoTagViewRangeStyle_DynamicFixedEqually:
        {
            newSize = [self reloadRWAutoTagViewRangeStyle_DynamicFixed];
        }
            break;
        default:
            break;
    }
    self.rw_size = newSize;
    return newSize;
}

#pragma mark -- RWAutoTagViewRangeStyle_DynamicSingle 计算动态单行

- (CGSize)reloadRWAutoTagViewRangeStyle_DynamicSingle {
    if (self.buttons.count == 0) {
        return CGSizeZero;
    }
    NSArray *subviews = self.subviews;
    CGFloat lineSpacing = self.rw_lineSpacing;
    
    CGFloat top = self.rw_insets.top;
    CGFloat left = self.rw_insets.left;
    CGFloat right = self.rw_insets.right;
    CGFloat bottom = self.rw_insets.bottom;
    
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
            if ((size.width >= self.rw_safeAreaLayoutMaxWidth) ||
                (width + left +right) >= self.rw_safeAreaLayoutMaxWidth) {
                width = self.rw_safeAreaLayoutMaxWidth - left -right;
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

#pragma mark -- RWAutoTagViewRangeStyle_DynamicMulti 计算动态多行

- (CGSize)reloadRWAutoTagViewRangeStyle_DynamicMulti {
    if (self.buttons.count == 0) {
        return CGSizeZero;
    }
    
    NSArray *subviews = self.subviews;
    CGFloat rw_lineSpacing = self.rw_lineSpacing;
    CGFloat rw_itemSpacing = self.rw_itemSpacing;
    
    CGFloat top = self.rw_insets.top;
    CGFloat left = self.rw_insets.left;
    CGFloat right = self.rw_insets.right;
    CGFloat bottom = self.rw_insets.bottom;
    
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
            if ((width >= self.rw_safeAreaLayoutMaxWidth) ||
                (lineitemMaxWidth >= self.rw_safeAreaLayoutMaxWidth) ||
                ((lineitemMaxWidth + rw_itemSpacing) >= self.rw_safeAreaLayoutMaxWidth)) {
                current_X = left;
                if ((index  > 0) && (index < subviews.count)) {
                   current_Y += rw_lineSpacing;
                    intrinsicHeight += rw_lineSpacing;
                }
                current_Y += lineMaxHeight;
                intrinsicHeight += (lineMaxHeight);
                width  = MIN(width, self.rw_safeAreaLayoutMaxWidth - left - right);
//                autoTagButton.frame = CGRectMake(current_X, current_Y, width, height);
                [self autoTagButton:autoTagButton frame:CGRectMake(current_X, current_Y, width, height)];
                lineMaxHeight = height;
                current_X += (rw_itemSpacing + width);
                lineMaxWidth = MAX(lineMaxWidth, current_X);
                index ++;
                if (index == subviews.count) {
                    intrinsicHeight += lineMaxHeight;
                }
                
            } else {
                
                lineMaxHeight = MAX(height, lineMaxHeight);
//                autoTagButton.frame = CGRectMake(current_X, current_Y, width, height);
                [self autoTagButton:autoTagButton frame:CGRectMake(current_X, current_Y, width, height)];
                current_X += (rw_itemSpacing + width);
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

#pragma mark -- RWAutoTagViewRangeStyle_DynamicFixedEqually | RWAutoTagViewRangeStyle_DynamicFixed 计算动态固定多行

- (CGSize)reloadRWAutoTagViewRangeStyle_DynamicFixed {
    
    if (self.buttons.count == 0) {
            return CGSizeZero;
        }
        
        NSArray *subviews = self.subviews;
        CGFloat lineSpacing = self.rw_lineSpacing;
        CGFloat lineitemSpacing = self.rw_itemSpacing;
        
        CGFloat top = self.rw_insets.top;
        CGFloat left = self.rw_insets.left;
        CGFloat right = self.rw_insets.right;
        CGFloat bottom = self.rw_insets.bottom;
        
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
                if ((width > self.rw_safeAreaLayoutMaxWidth) ||
                    (lineitemMaxWidth > self.rw_safeAreaLayoutMaxWidth)) {
                    current_X = left;
                    
                    current_Y += (lineSpacing +lineMaxHeight);
                    intrinsicHeight += (lineSpacing +lineMaxHeight);
                    width  = MIN(width, self.rw_safeAreaLayoutMaxWidth - left - right);
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
    switch (self.rw_fullSafeAreaStyle) {
        case RWAutoTagViewFullSafeAreaStyle_MaxWidth:
            fullSafeAreaWidth = self.rw_safeAreaLayoutMaxWidth;
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
