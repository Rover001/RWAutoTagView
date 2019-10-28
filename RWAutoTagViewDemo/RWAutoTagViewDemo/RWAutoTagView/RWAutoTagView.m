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
@property (nonatomic,assign) NSInteger animationIndex;; /**< 第几个需要执行动画 默认 -1 */

@end

@implementation RWAutoTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"initWithFrame");
        [self initAttribute];
//        [self reloadData];
    }
    return self;
}

- (instancetype)initWithAutoSortStyle:(RWAutoTagViewAutoSortStyle)autoSortStyle {
    self = [super init];
    if (self) {
        self.autoSortStyle = autoSortStyle;
//        [self reloadData];
    }
    return self;
}

+ (instancetype)autoTagViewWithAutoSortStyle:(RWAutoTagViewAutoSortStyle)autoSortStyle {
    return [[self alloc]initWithAutoSortStyle:autoSortStyle];
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"initWithCoder");
        [self initAttribute];
    }
    return self;
}

- (void)initAttribute {
    self.insets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.lineSpacing = 10;
    self.lineitemSpacing = 10;
    self.safeAreaLayoutMaxWidth = [UIScreen mainScreen].bounds.size.width;
    self.showSingleLineSpacing = NO;
    self.isItemSort = YES;
    self.lineStyle = RWAutoTagViewLineStyle_AutoLine;
    self.currentCount = 0;
    self.autoSortStyle = RWAutoTagViewAutoSortStyleNormal;
    self.buttons = [NSMutableArray array];
    self.isAnimation = NO;
    self.animationIndex = -1;
    if (_dataSource) {
        [self reloadData];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self reloadData];
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


- (void)addAutoTagButton {
    
    NSInteger count = [self getAutoTagButtonNumbers];
    self.currentCount = count;
    
    for (NSInteger i = 0; i<count; i++) {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(autoTagView:autoTagButtonForAtIndex:)]) {
            RWAutoTagButton *autoTagButton = [self.dataSource autoTagView:self autoTagButtonForAtIndex:i];
            autoTagButton.tag = i+1000;
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(safeAreaLayoutMaxWidthInAutoTagView:)]) {
                autoTagButton.safeAreaLayoutMaxWidth = [self.dataSource safeAreaLayoutMaxWidthInAutoTagView:self];
            }
            [autoTagButton addTarget:self action:@selector(autoTagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//            autoTagButton.backgroundColor = [UIColor grayColor];
            [self addSubview:autoTagButton];
            [_buttons addObject:autoTagButton];
        }
    }
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

- (void)insertAutoTagButtonAtIndex:(NSInteger)index {
    [self autoTagButtonAtIndex:index buttons:self.buttons.count errMsg:[NSString stringWithFormat:@"%s",__func__]];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(autoTagView:autoTagButtonForAtIndex:)]) {
        
        NSInteger number = [self getAutoTagButtonNumbers];
        if (index >= number) {
            NSString *errMsg = [NSString stringWithFormat:@"%@  index:%ld  数组 bounds [0 .. %d]",[NSString stringWithFormat:@"%s",__func__],(long)index,number -1];
            NSAssert(index < number,errMsg);
        }
        
        
        if (number >= self.currentCount) {
            NSString *errMsg = [NSString stringWithFormat:@"%@  delegate Number:%ld  数组 bounds [0 .. %d]",[NSString stringWithFormat:@"%s",__func__],(long)number,self.currentCount -1];
            NSAssert(number < self.currentCount,errMsg);
        }
        self.currentCount  ++;
        
        RWAutoTagButton *autoTagButton = [self.dataSource autoTagView:self autoTagButtonForAtIndex:index];
        autoTagButton.tag = index+1000;
        [autoTagButton addTarget:self action:@selector(autoTagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (index <0 || index >=_buttons.count) {
            [_buttons addObject:autoTagButton];
        } else {
            [_buttons insertObject:autoTagButton atIndex:index];
        }
        [self setNeedsLayout];
    } else {
        
    }
}

- (void)removeAutoTagButtonAtIndex:(NSInteger)index {
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


- (CGSize)intrinsicContentSize {
    [super intrinsicContentSize];
    if (!self.buttons.count) {
        return CGSizeZero;
    }


    NSArray *subviews = self.subviews;
    UIView *currentView = nil;

    CGFloat top = self.insets.top;
    CGFloat left = self.insets.left;
    CGFloat bottom = self.insets.bottom;
    CGFloat right = self.insets.right;

    CGFloat lineSpacing = self.lineSpacing;
    CGFloat lineitemSpacing = self.lineitemSpacing;

    CGFloat current_X = left;

    CGFloat intrinsicHeight = 0.0f;
    CGFloat intrinsicWidth = left + right;

    switch (self.lineStyle) {
        case RWAutoTagViewLineStyle_SingleLine:
        {
           for (UIView *view in subviews) {
               CGSize size = view.intrinsicContentSize;
               intrinsicWidth += size.width;
            }

            intrinsicWidth += lineitemSpacing * (subviews.count - 1) + right;
            intrinsicHeight += ((UIView *)subviews.firstObject).intrinsicContentSize.height + bottom;

        }
           break;

        case RWAutoTagViewLineStyle_AutoLine:
       {
           NSInteger lineCount = 0;
           for (UIView *view in subviews) {
               if ([view isKindOfClass:[RWAutoTagButton class]]) {
                   RWAutoTagButton *tagButton = (RWAutoTagButton *)view;
                   CGSize size = tagButton.intrinsicContentSize;
                   if (currentView) {
                       CGFloat width = size.width;
                       current_X += lineitemSpacing;
                       if (current_X + width + right <= self.safeAreaLayoutMaxWidth) {
                           current_X += size.width;
                       } else {
                           lineCount ++;
                           intrinsicHeight += lineSpacing;
                            CGFloat width = MIN(size.width, self.safeAreaLayoutMaxWidth - left - right);
                           current_X = left + width;
                           intrinsicHeight += size.height +lineSpacing;
                      }
                   } else {
                       intrinsicHeight += size.height;
                       current_X += size.width;
                   }
                   currentView = tagButton;
                   intrinsicWidth = MAX(intrinsicWidth, current_X + right);
                   if (intrinsicWidth >=self.safeAreaLayoutMaxWidth) {
                       intrinsicWidth = self.safeAreaLayoutMaxWidth;
                   }
               }
           }

           intrinsicHeight += (top +bottom);
       }
           break;

       default:
           break;
   }
    return CGSizeMake(intrinsicWidth, intrinsicHeight);
}


#pragma mark - RW accessors

- (void)setLineStyle:(RWAutoTagViewLineStyle)lineStyle {
    if (_lineStyle !=lineStyle) {
        _lineStyle = lineStyle;
//        [self invalidateIntrinsicContentSize];
        [self setNeedsLayout];
    }
}

- (void)setSafeAreaLayoutMaxWidth:(CGFloat)safeAreaLayoutMaxWidth {
    if (_safeAreaLayoutMaxWidth != safeAreaLayoutMaxWidth) {
        _safeAreaLayoutMaxWidth = safeAreaLayoutMaxWidth;
//        [self invalidateIntrinsicContentSize];
        [self setNeedsLayout];
    }
}



- (void)setAutoSortStyle:(RWAutoTagViewAutoSortStyle)autoSortStyle {
    if (_autoSortStyle != autoSortStyle) {
        _autoSortStyle = autoSortStyle;
        if (self.isItemSort) {
//            [self invalidateIntrinsicContentSize];
            if (_autoSortStyle == RWAutoTagViewAutoSortStyleNormal) {
                [self reloadData];
            } else {
//               [self setNeedsLayout];
                [self reloadData];
            }
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadAutoTagButton];
}


- (void)reloadAutoTagButton {
    [self reloadItemAutoSort];
    
    NSArray *subviews = self.subviews;
    UIView *currentView = nil;
    
    CGFloat top = self.insets.top;
    CGFloat left = self.insets.left;
    CGFloat right = self.insets.right;
    
    CGFloat lineSpacing = self.lineSpacing;
    CGFloat lineitemSpacing = self.lineitemSpacing;
    
    CGFloat current_X = left;
    CGFloat current_Y = top;
    
    switch (self.lineStyle) {
        case RWAutoTagViewLineStyle_SingleLine:
        {
            for (UIView *view in subviews) {
                CGSize size = view.intrinsicContentSize;
                view.frame = CGRectMake(current_X, current_Y, size.width, size.height);
                current_X += size.width;
                current_X += lineitemSpacing;
                currentView = view;
            }
        }
            break;
       
        case RWAutoTagViewLineStyle_AutoLine:
        {
            NSInteger index = 0;
            for (UIView *view in subviews) {
                CGSize size = view.intrinsicContentSize;
                if (currentView) {
                    CGFloat width = size.width;
                    current_X += lineitemSpacing;
                    if (current_X + width + right <= self.safeAreaLayoutMaxWidth) {
                        view.frame = CGRectMake(current_X, CGRectGetMinY(currentView.frame), size.width, size.height);
                        current_X += size.width;
                    } else {
                        current_Y += lineSpacing;
                        CGFloat width = MIN(size.width, self.safeAreaLayoutMaxWidth - left - right);
                        CGRect rect = CGRectMake(left, current_Y, width, size.height);
                        view.frame = CGRectMake(left, current_Y,0, size.height);
                        [UIView animateWithDuration:1 animations:^{
                          view.frame = rect;
                        }];
                        current_X = left + width;
                        current_Y += rect.size.height;
                    }
                } else {
                    CGFloat width = MIN(size.width, self.safeAreaLayoutMaxWidth - left - right);
                    CGRect rect = CGRectMake(left, current_Y, width, size.height);
                    view.frame = CGRectMake(left, current_Y,width, size.height);
//                    view.alpha = 0;
//                    view.height = size.height;
//                   [UIView animateWithDuration:0 animations:^{
//                       view.width = width;
//                       view.alpha = 1;
//                   }];
                    
                    current_X += width;
                    current_Y += rect.size.height;
                }
                currentView = view;
                index ++;
            }
        }
            break;
            
        default:
            break;
    }
    
    self.rw_size = [self intrinsicContentSize];
    NSLog(@"rw_size:%@",NSStringFromCGSize(self.rw_size));
}


- (void)reloadItemAutoSort {
    
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
  
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[RWAutoTagButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (RWAutoTagButton *button in _buttons) {
        [self addSubview:button];
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
