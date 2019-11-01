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

@end

@implementation RWAutoTagView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        NSLog(@"initWithFrame");
        [self initAttribute];
    }
    return self;
}

- (instancetype)initWithAutoSortStyle:(RWAutoTagViewAutoSortStyle)autoSortStyle {
    self = [super init];
    if (self) {
        self.autoSortStyle = autoSortStyle;
    }
    return self;
}

+ (instancetype)autoTagViewWithAutoSortStyle:(RWAutoTagViewAutoSortStyle)autoSortStyle {
    return [[self alloc]initWithAutoSortStyle:autoSortStyle];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
//        NSLog(@"initWithCoder");
        [self initAttribute];
    }
    return self;
}

- (void)initAttribute {
    self.insets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.lineSpacing = 10;
    self.lineitemSpacing = 10;
    self.safeAreaLayoutMaxWidth = [UIScreen mainScreen].bounds.size.width;
    self.fullSafeAreaStyle = RWAutoTagViewFullSafeAreaStyle_MaxWidth;
    self.showSingleLineSpacing = NO;
    self.isItemSort = YES;
    self.lineStyle = RWAutoTagViewLineStyle_AutoLine;
    self.currentCount = 0;
    self.autoSortStyle = RWAutoTagViewAutoSortStyleNormal;
    self.buttons = [NSMutableArray array];
    self.isAnimation = YES;
    if (_dataSource) {
        [self reloadData];
    }
}

#pragma amrk - 添加RWAutoTagButton
- (void)addAutoTagButton {
    if (!self.dataSource) {
        return;
    }
    
    NSInteger count = [self getAutoTagButtonNumbers];
    for (NSInteger i = 0; i<count; i++) {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(autoTagView:autoTagButtonForAtIndex:)]) {
            RWAutoTagButton *autoTagButton = [self.dataSource autoTagView:self autoTagButtonForAtIndex:i];
            autoTagButton.tag = i+1000;
            autoTagButton.safeAreaLayoutMaxWidth = self.safeAreaLayoutMaxWidth - self.insets.left - self.insets.right;
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(safeAreaLayoutMaxWidthInAutoTagView:)]) {
                autoTagButton.safeAreaLayoutMaxWidth = [self.dataSource safeAreaLayoutMaxWidthInAutoTagView:self] - self.insets.left - self.insets.right;
            }
            [autoTagButton addTarget:self action:@selector(autoTagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [autoTagButton setNeedsLayout];
            NSLog(@"%@",NSStringFromCGSize([autoTagButton intrinsicContentSize]));
            [_buttons addObject:autoTagButton];
        }
    }
    self.currentCount = _buttons.count;
    [self reloadAutoTagViewAutoSort];
}

#pragma mark - 按钮处理事件
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



- (void)setCurrentCount:(NSInteger)currentCount {
    if (_currentCount != currentCount) {
        _currentCount = currentCount;
    }
}

- (void)setDataSource:(id<RWAutoTagViewDataSource>)dataSource {
    if (_dataSource != dataSource) {
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

- (NSInteger)getAutoTagButtonNumbers {
    NSInteger number = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfAutoTagButtonInAutoTagView:)]) {
          number = [self.dataSource numberOfAutoTagButtonInAutoTagView:self];
       }
    return number;
}





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
        
        NSInteger number = [self getAutoTagButtonNumbers];
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
        if (index <0 || index >=_buttons.count) {
            [_buttons addObject:autoTagButton];
        } else {
            [_buttons insertObject:autoTagButton atIndex:index];
        }
        [self insertSubview:autoTagButton atIndex:index];
        if (animation) {
            self.animationAutoTagButton = autoTagButton;
        }
        [self reloadAutoTagViewAutoSort];
        [self setNeedsLayout];
    } else {
        
    }
}

- (void)removeAutoTagButtonAtIndex:(NSInteger)index autoTagButtonAtAnimation:(BOOL)animation {
    [self autoTagButtonAtIndex:index buttons:self.buttons.count-1 errMsg:[NSString stringWithFormat:@"%s",__func__]];
    if (self.buttons.count == 0) {
       NSString *errMsg = [NSString stringWithFormat:@"%s  index：%ld  数组 bounds [0 .. 0]",__func__,(long)index];
       NSAssert(self.buttons.count >0,errMsg);
   }
    [_buttons removeObjectAtIndex:index];
    [[self autoTagButtonAtIndex:index] removeFromSuperview];
    self.currentCount --;
    [self setNeedsLayout];
}


- (nullable __kindof RWAutoTagButton *)autoTagButtonAtIndex:(NSInteger)index {
    [self autoTagButtonAtIndex:index buttons:self.subviews.count errMsg:[NSString stringWithFormat:@"%s",__func__]];
    return [self viewWithTag:index +1000];
}


- (void)reloadData {
    
    /* 🐱 清除按钮数组 */
    [_buttons removeAllObjects];
    /* 🐱 清除self.subviews中的RWAutoTagButton对象 */
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[RWAutoTagButton class]]) {
            [subView removeFromSuperview];
        }
    }
    /* 🐱 重新创建RWAutoTagButton对象 */
    [self addAutoTagButton];
}





#pragma mark - Set

- (void)setLineStyle:(RWAutoTagViewLineStyle)lineStyle {
    if (_lineStyle !=lineStyle) {
        _lineStyle = lineStyle;
//        [self invalidateIntrinsicContentSize];
        [self setNeedsLayout];
//        self.rw_size = [self intrinsicContentSize];
    }
}

- (void)setInsets:(UIEdgeInsets)insets {
    _insets = insets;
    [self reloadData];
}

- (void)setSafeAreaLayoutMaxWidth:(CGFloat)safeAreaLayoutMaxWidth {
    if (_safeAreaLayoutMaxWidth != safeAreaLayoutMaxWidth) {
        _safeAreaLayoutMaxWidth = safeAreaLayoutMaxWidth;
//        [self invalidateIntrinsicContentSize];
        [self setNeedsLayout];
//        self.rw_size = [self intrinsicContentSize];
    }
}
- (void)setFullSafeAreaStyle:(RWAutoTagViewFullSafeAreaStyle)fullSafeAreaStyle {
    if (_fullSafeAreaStyle != fullSafeAreaStyle) {
        _fullSafeAreaStyle = fullSafeAreaStyle;
        [self setNeedsLayout];
        self.rw_size = [self intrinsicContentSize];
    }
}



- (void)setAutoSortStyle:(RWAutoTagViewAutoSortStyle)autoSortStyle {
    if (_autoSortStyle != autoSortStyle) {
        _autoSortStyle = autoSortStyle;
        if (self.isItemSort) {
            [self reloadData];
//            self.rw_size = [self intrinsicContentSize];
//            [self invalidateIntrinsicContentSize];
        }
    }
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    if (_lineSpacing != lineSpacing) {
        _lineSpacing = lineSpacing;
        [self setNeedsLayout];
    }
}




- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize newSize = CGSizeMake(0.0f, 0.0f);
    switch (self.lineStyle) {
        case RWAutoTagViewLineStyle_SingleLine:
        {
            newSize = [self reloadRWAutoTagViewLineStyle_SingleLine];
        }
            break;
       
        case RWAutoTagViewLineStyle_AutoLine:
        {
            newSize = [self reloadRWAutoTagViewLineStyle_AutoLine];
        }
            break;
            
        default:
            break;
    }
    
//    self.rw_size = newSize;
    NSLog(@"rw_size:%@",NSStringFromCGSize(self.rw_size));
}

- (CGSize)intrinsicContentSize {

    CGSize newSize = CGSizeZero;
    switch (self.lineStyle) {
        case RWAutoTagViewLineStyle_SingleLine:
        {
            newSize =  [self reloadRWAutoTagViewLineStyle_SingleLine];
        }
           break;

        case RWAutoTagViewLineStyle_AutoLine:
       {
           newSize = [self reloadRWAutoTagViewLineStyle_AutoLine];
       }
           break;

       default:
           break;
   }
//    NSLog(@"intrinsicContentSize:%@",NSStringFromCGSize(newSize));
    return newSize;
}

#pragma mark - RWAutoTagViewLineStyle_SingleLine Frame

- (CGSize)reloadRWAutoTagViewLineStyle_SingleLine {
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
    intrinsicWidth = [self intrinsicWidth:lineMaxWidth];
    self.rw_size = CGSizeMake(intrinsicWidth, intrinsicHeight);
    return CGSizeMake(intrinsicWidth, intrinsicHeight);
}

#pragma mark - RWAutoTagViewLineStyle_AutoLine Frame

- (CGSize)reloadRWAutoTagViewLineStyle_AutoLine {
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

    
    intrinsicWidth = [self intrinsicWidth:lineMaxWidth];
    self.rw_size = CGSizeMake(intrinsicWidth, intrinsicHeight);
    return CGSizeMake(intrinsicWidth, intrinsicHeight);
}

- (CGFloat)intrinsicWidth:(CGFloat)newIntrinsicWidth {
    CGFloat intrinsicWidth = CGFLOAT_MIN;
    switch (self.fullSafeAreaStyle) {
        case RWAutoTagViewFullSafeAreaStyle_MaxWidth:
            intrinsicWidth = self.safeAreaLayoutMaxWidth;
            break;
            
        case RWAutoTagViewFullSafeAreaStyle_AutoWidth:
            intrinsicWidth = newIntrinsicWidth;
            break;
            
        default:
            break;
    }
    return intrinsicWidth;
}

#pragma mark - autoTagButton 动画
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

#pragma mark - 排序更新处理
- (void)reloadAutoTagViewAutoSort {
    
    if (!self.isItemSort) {
        return;
    }
    
  NSArray *newButtons  =
    [_buttons sortedArrayUsingComparator:^NSComparisonResult(RWAutoTagButton *obj1, RWAutoTagButton *obj2) {
        
        double obj1_width = obj1.intrinsicContentSize.width;
        double obj2_width = obj2.intrinsicContentSize.width;
        switch (self.autoSortStyle) {
            case RWAutoTagViewAutoSortStyleDescending:/* 🐱 降序 */
            {
                return [[NSNumber numberWithFloat:obj1_width] compare:[NSNumber numberWithFloat:obj2_width]] == NSOrderedAscending;
            }
                break;
                
            case RWAutoTagViewAutoSortStyleAscending:/* 🐱 升序 */
            {
                 return [[NSNumber numberWithFloat:obj1_width] compare:[NSNumber numberWithFloat:obj2_width]] == NSOrderedDescending;
            }
                break;
             
            case RWAutoTagViewAutoSortStyleNormal:
            default:
                return NSOrderedSame;
                break;
        }
       return NSOrderedSame;
    }];
    
    [_buttons removeAllObjects];
    [_buttons addObjectsFromArray:newButtons];
  
    for (UIView *subView in self.subviews) {
           if ([subView isKindOfClass:[RWAutoTagButton class]]) {
               [subView removeFromSuperview];
           }
       }
    
    NSInteger index = 0;
    for (RWAutoTagButton *autoTagButton in _buttons) {
        autoTagButton.tag = index + 1000;
        [self addSubview:autoTagButton];
    }
}

/*
// Only override drawRect: if you perform RW drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
