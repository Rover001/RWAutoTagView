//
//  RWAutoTagButton.m
//  RWAutoTagViewDemo
//
//  Created by 曾云 on 2019/10/27.
//  Copyright © 2019 曾云. All rights reserved.
//

#import "RWAutoTagButton.h"
#import "RWAutoTag.h"
#import "UIView+RWExtension.h"
#import "NSBundle+RWAutoTag.h"

@interface RWAutoTagButton ()


@end

@implementation RWAutoTagButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        NSLog(@"CustomAutoTagButton  initWithFrame");
        [self initAttribute];
        [self initAutoButtonSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
//        NSLog(@"CustomAutoTagButton initWithCoder");
        [self initAttribute];
        [self initAutoButtonSubViews];
    }
    return self;
}


- (void)initAttribute {
    self.rw_itemSpacing = 0.0f;
    self.rw_safeAreaLayoutMaxWidth = [UIScreen mainScreen].bounds.size.width;
    self.rw_autoTagButtonStyle = RWAutoTagButtonStyle_Text;
    self.rw_imageStyle =  RWAutoTagButtonImageStyle_Left;
    self.clipsToBounds = YES;
    self.rw_isDynamicFixed = NO;
    self.rw_dynamicFixedSize = CGSizeZero;
}

- (void)initAutoButtonSubViews {
    
    switch (self.rw_autoTagButtonStyle) {
        case RWAutoTagButtonStyle_Text:
//            [self setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            break;
            
        case RWAutoTagButtonStyle_Image:
            [self setAttributedTitle:[[NSAttributedString alloc]init] forState:UIControlStateNormal];
            [self setTitle:@"" forState:UIControlStateNormal];
            [self setImage:[NSBundle rw_autotagImage] forState:UIControlStateNormal];
//            [self setImage:[NSBundle rw_autotagImage] forState:UIControlStateHighlighted];
            break;
            
        case RWAutoTagButtonStyle_Mingle:
        {
            [self setImage:[NSBundle rw_autotagImage] forState:UIControlStateNormal];
//            [self setImage:[NSBundle rw_autotagImage] forState:UIControlStateHighlighted];
        }
            break;
        case RWAutoTagButtonStyle_Custom:
        default:
            break;
    }
}




- (RWAutoTagButtonStyle)getAutoButtonStyleInAutoTagStyle:(RWAutoTagStyle)autoTagStyle {
    
    RWAutoTagButtonStyle autoTagButtonStyle = RWAutoTagButtonStyle_Text;
    switch (autoTagStyle) {
        case RWAutoTagStyle_Text:
            autoTagButtonStyle = RWAutoTagButtonStyle_Text;
            break;
            
        case RWAutoTagStyle_Image:
            autoTagButtonStyle = RWAutoTagButtonStyle_Image;
            break;
            
        case RWAutoTagStyle_Mingle:
            autoTagButtonStyle = RWAutoTagButtonStyle_Mingle;
            break;
            
        case RWAutoTagStyle_Custom:
            autoTagButtonStyle = RWAutoTagButtonStyle_Custom;
            break;
            
        default:
            break;
    }
    
    return autoTagButtonStyle;
}

#pragma mark - Set Attribute

- (void)setRw_imageStyle:(RWAutoTagButtonImageStyle)rw_imageStyle {
    if (_rw_imageStyle != rw_imageStyle) {
        _rw_imageStyle = rw_imageStyle;
        [self initAutoButtonSubViews];
        [self setNeedsLayout];
    }
}

- (void)setRw_autoTagButtonStyle:(RWAutoTagButtonStyle)rw_autoTagButtonStyle {
    if (_rw_autoTagButtonStyle != rw_autoTagButtonStyle) {
        _rw_autoTagButtonStyle = rw_autoTagButtonStyle;
        [self initAutoButtonSubViews];
        [self setNeedsLayout];
       }
}

- (void)setRw_safeAreaLayoutMaxWidth:(CGFloat)rw_safeAreaLayoutMaxWidth {
    if (_rw_safeAreaLayoutMaxWidth != rw_safeAreaLayoutMaxWidth) {
        _rw_safeAreaLayoutMaxWidth = rw_safeAreaLayoutMaxWidth;
        [self setNeedsLayout];
    }
}


- (void)setRw_itemSpacing:(CGFloat)rw_itemSpacing {
    if (_rw_itemSpacing != rw_itemSpacing) {
        _rw_itemSpacing = rw_itemSpacing;
        [self setNeedsLayout];
    }
}

- (void)setRw_isDynamicFixed:(BOOL)rw_isDynamicFixed {
    if (_rw_isDynamicFixed != rw_isDynamicFixed) {
        _rw_isDynamicFixed = rw_isDynamicFixed;
        [self setNeedsLayout];
    }
}




#pragma mark - layout contentSize

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutContentSize];
}

- (CGSize)intrinsicContentSize {
   return [self layoutContentSize];
}

- (CGSize)layoutContentSize {
    CGSize newSize = CGSizeMake(0, 0);
    
    switch (self.rw_autoTagButtonStyle) {
        case RWAutoTagButtonStyle_Text:
            newSize = [self reloadAutoButtonStyle_Text];
            break;
        
        case RWAutoTagButtonStyle_Image:
            newSize = [self reloadAutoButtonStyle_Image];
            break;
            
        case RWAutoTagButtonStyle_Mingle:
            newSize = [self reloadAutoButtonStyle_Mingle];
            break;
            
        case RWAutoTagButtonStyle_Custom:
            newSize = [self reloadAutoButtonStyle_Custom];
            break;
            
        default:
            break;
    };
    self.rw_size = newSize;
    return newSize;
}



#pragma mark -- UIEdgeInsets

- (CGFloat)getInsetTop {return self.contentEdgeInsets.top;}
- (CGFloat)getInsetLeft {return self.contentEdgeInsets.left;}
- (CGFloat)getInsetRight {return self.contentEdgeInsets.right;}
- (CGFloat)getInsetBottom {return self.contentEdgeInsets.bottom;}

#pragma mark -- UIImageView UIEdgeInsets CGSize

- (CGFloat)getImageInsetTop {return self.imageEdgeInsets.top;};
- (CGFloat)getImageInsetLeft {return self.imageEdgeInsets.left;}
- (CGFloat)getImageInsetRight {return self.imageEdgeInsets.right;}
- (CGFloat)getImageInsetBottom {return self.imageEdgeInsets.bottom;}
- (CGFloat)getImageWidth {return self.currentImage.size.width;}
- (CGFloat)getImageHeight {return self.currentImage.size.height;}
- (CGFloat)getMaxImageHeight {
    return [self getImageHeight] + [self getImageInsetTop] + [self getImageInsetBottom];
}
- (CGFloat)getMaxImageWidth {
    return [self getImageWidth ] + [self getImageInsetLeft] + [self getImageInsetRight];
}


#pragma mark -- UILabel UIEdgeInsets CGSize

- (CGFloat)getTextInsetTop {return self.titleEdgeInsets.top;}
- (CGFloat)getTextInsetLeft {return self.titleEdgeInsets.left;}
- (CGFloat)getTextInsetRight {return self.titleEdgeInsets.right;}
- (CGFloat)getTextInsetBottom {return self.titleEdgeInsets.bottom;}
- (CGFloat)getTextHeight {return self.titleLabel.intrinsicContentSize.height;}
- (CGFloat)getMaxTextHeight {
    return [self getTextHeight] + [self getTextInsetTop] + [self getTextInsetBottom];
}
- (CGFloat)getTextWidth {return self.titleLabel.intrinsicContentSize.width;}
- (CGFloat)getMaxTextWidth {
    return [self getTextWidth ] + [self getTextInsetLeft] + [self getTextInsetRight];
}




#pragma mark -- reloadRWAutoTagButtonStyle_Text 计算纯文字

- (CGSize)reloadAutoButtonStyle_Text {

    CGFloat horizontal = [self getInsetLeft] + [self getInsetRight];
    CGFloat label_horizontal = [self getTextInsetLeft] + [self getTextInsetRight];
    CGFloat vertical = [self getInsetTop] + [self getInsetBottom];
    CGFloat label_vertical = [self getTextInsetTop] + [self getTextInsetBottom];
    
    CGFloat intrinsicHeight = vertical;
    CGFloat intrinsicWidth = horizontal;
    
    intrinsicHeight +=  [self getMaxTextHeight];
    if (self.rw_isDynamicFixed) {
        intrinsicWidth = self.rw_dynamicFixedSize.width;
        if (self.rw_dynamicFixedSize.height != UITableViewAutomaticDimension) {
            intrinsicHeight = self.rw_dynamicFixedSize.height;
        }
    } else {
        intrinsicWidth += [self getMaxTextWidth];
    }
    intrinsicWidth = [self initSafeAreaWidth:intrinsicWidth];
    CGFloat label_X = [self getInsetLeft] + [self getTextInsetLeft];
    CGFloat label_Y = [self getInsetTop] + [self getTextInsetTop];
    CGFloat label_Width = [self getTextWidth];
    CGFloat label_Height = [self getTextHeight];
    
    if (intrinsicWidth >=self.rw_safeAreaLayoutMaxWidth) {
        label_Width = intrinsicWidth - horizontal - label_horizontal;
    }
    
    if (self.rw_isDynamicFixed) {
        if (label_Width > self.rw_dynamicFixedSize.width) {
            label_Width = self.rw_dynamicFixedSize.width - horizontal - label_horizontal;
        }
        label_X = (intrinsicWidth - label_Width)/2;
        if (self.rw_dynamicFixedSize.height != UITableViewAutomaticDimension) {
//            label_Y = (intrinsicHeight - label_Height)/2;
            double new_label_height = intrinsicHeight - vertical - label_vertical;
            if (new_label_height > label_Height) {
                //label_Height = new_label_height;
                label_Y += (new_label_height - label_Height)/2;
            }
        }
    }
    
    self.titleLabel.frame = CGRectMake(label_X, label_Y,label_Width, label_Height);
    self.imageView.frame = CGRectMake(0, 0,0,0);
    
    return CGSizeMake(intrinsicWidth, intrinsicHeight);
}


#pragma mark -- reloadAutoButtonStyle_Image 计算纯图片

- (CGSize)reloadAutoButtonStyle_Image {
//    self.rw_imageStyle = RWAutoTagButtonImageStyle_Center;
    CGFloat horizontal = [self getInsetLeft] + [self getInsetRight];
    CGFloat image_horizontal = [self getImageInsetLeft] + [self getImageInsetRight];
    
    CGFloat vertical = [self getInsetTop] + [self getInsetBottom];
    CGFloat image_vertical = [self getImageInsetTop] + [self getImageInsetBottom];
    
    
    CGFloat intrinsicHeight = vertical;
    CGFloat intrinsicWidth = horizontal;
    
    intrinsicHeight +=  [self getMaxImageHeight];
    if (self.rw_isDynamicFixed) {
        intrinsicWidth = self.rw_dynamicFixedSize.width;
        if (self.rw_dynamicFixedSize.height != UITableViewAutomaticDimension) {
            intrinsicHeight = self.rw_dynamicFixedSize.height;
        }
    } else {
        intrinsicWidth += [self getMaxImageWidth];
    }
        
    intrinsicWidth = [self initSafeAreaWidth:intrinsicWidth];
    
    
    CGFloat image_X = [self getInsetLeft] + [self getImageInsetLeft];
    CGFloat image_Y = [self getInsetTop] + [self getImageInsetTop];
    CGFloat image_Width = [self getImageWidth];
    CGFloat image_Height = [self getImageHeight];
    CGFloat aspectRatio = image_Width/image_Height;
    
    
    
    if (self.rw_isDynamicFixed) {
        image_Width = intrinsicWidth - horizontal - image_horizontal;
        if (self.rw_dynamicFixedSize.height != UITableViewAutomaticDimension) {
            image_Height = self.rw_dynamicFixedSize.height - vertical - image_vertical;
        }
    } else {
        if (image_Width +horizontal + image_horizontal >= intrinsicWidth) {
            image_Width = intrinsicWidth - horizontal - image_horizontal;
            image_Height = image_Width/aspectRatio;
        }
    }
    
    self.imageView.frame = CGRectMake(image_X, image_Y,image_Width,image_Height);
    self.titleLabel.frame = CGRectMake(0, 0,0, 0);
    return CGSizeMake(intrinsicWidth, intrinsicHeight);
}

#pragma mark -- reloadAutoButtonStyle_Mingle 计算图文结合

- (CGSize)reloadAutoButtonStyle_Mingle {
    
    CGFloat rw_itemSpacing = self.rw_itemSpacing;
    CGFloat intrinsicHeight = [self getInsetTop] + [self getInsetBottom];
    CGFloat intrinsicWidth = [self getInsetLeft] + [self getInsetRight];
    CGFloat image_X = 0.0f;
    CGFloat image_Y = 0.0f;
    CGFloat image_Width = [self getImageWidth];
    CGFloat image_Height = [self getImageHeight];
    CGFloat image_AspectRatio = image_Width/image_Height;
    CGFloat label_X = 0.0f;
    CGFloat label_Y = 0.0f;
    CGFloat label_Width = [self getTextWidth];
    CGFloat label_Height = [self getTextHeight];
   
    
    CGFloat horizontal = [self getInsetLeft] + [self getInsetRight];
    CGFloat image_horizontal = [self getImageInsetLeft] + [self getImageInsetRight];
    CGFloat label_horizontal = [self getTextInsetLeft] + [self getTextInsetRight];
    CGFloat vertical = [self getInsetTop] + [self getInsetBottom];
    CGFloat image_vertical = [self getImageInsetTop] + [self getImageInsetBottom];
//    CGFloat label_vertical = [self getTextInsetTop] + [self getTextInsetBottom];
   
    CGFloat maxImageHeight = [self getMaxImageHeight];
    CGFloat maxImageWidth = [self getMaxImageWidth];
    CGFloat maxTextHeight = [self getMaxTextHeight];
    CGFloat maxTextWidth = [self getMaxTextWidth];
    
    if (self.rw_isDynamicFixed) {
        if (image_Width > self.rw_dynamicFixedSize.width) {
            image_Width = self.rw_dynamicFixedSize.width - image_horizontal - horizontal;
        }
        if (label_Width > self.rw_dynamicFixedSize.width) {
            label_Width = self.rw_dynamicFixedSize.width -label_horizontal - horizontal;
        }

        if (maxImageWidth > self.rw_dynamicFixedSize.width) {
            maxImageWidth = self.rw_dynamicFixedSize.width - horizontal;
            image_Width = maxImageWidth - image_horizontal;
        }

        if (maxTextWidth > self.rw_dynamicFixedSize.width) {
            maxTextWidth = self.rw_dynamicFixedSize.width - horizontal;
            label_Width = maxTextWidth - label_horizontal;
        }
    }
    
    
    
    
    
    
    switch (self.rw_imageStyle) {
        case RWAutoTagImageEdgeInsetStyle_Top:
        case RWAutoTagImageEdgeInsetStyle_Bottom:{
            intrinsicHeight += maxImageHeight + maxTextHeight +rw_itemSpacing;
            
            if (self.rw_isDynamicFixed) {
                intrinsicWidth = self.rw_dynamicFixedSize.width;
                if (self.rw_dynamicFixedSize.height != UITableViewAutomaticDimension) {
                    intrinsicHeight = self.rw_dynamicFixedSize.height;
                }
           } else {
               intrinsicWidth += MAX(maxImageWidth, maxTextWidth);
           }
            
            intrinsicWidth = [self initSafeAreaWidth:intrinsicWidth];
            
            
            label_X = (intrinsicWidth - label_Width)/2;
             if (maxTextWidth > maxImageWidth) {
                 label_X = [self getInsetLeft] + [self getTextInsetLeft];
             }
            
             image_X = (intrinsicWidth - image_Width)/2;
             if (maxImageWidth > maxTextWidth) {
                 image_X = [self getInsetLeft] + [self getImageInsetLeft];
             }
            
            if (self.rw_imageStyle == RWAutoTagImageEdgeInsetStyle_Top) {/* 🐱 图片在上边 */
                image_Y = [self getInsetTop] + [self getImageInsetTop];
                label_Y = image_Y +image_Height + [self getImageInsetBottom] +rw_itemSpacing + [self getTextInsetTop];
                label_Width = intrinsicWidth;
                if (intrinsicWidth < ( MAX(maxTextWidth, maxImageWidth) + horizontal) ) {
                    if (maxTextWidth > maxImageWidth) {
                        label_Width = intrinsicWidth - horizontal - label_horizontal;
                    }
               }
                
                if (self.rw_isDynamicFixed) {
                    label_Width = MAX(intrinsicWidth - horizontal - label_horizontal, 0.0f);
                }
                
            } else if (self.rw_imageStyle == RWAutoTagImageEdgeInsetStyle_Bottom) {
                
                label_Y = [self getInsetTop] + [self getTextInsetTop];
                image_Y = label_Y +label_Height + [self getTextInsetBottom] +rw_itemSpacing + [self getImageInsetTop];
                label_Width = intrinsicWidth;
                if (intrinsicWidth < ( MAX(maxTextWidth, maxImageWidth) + horizontal) ) {
                    if (maxTextWidth > maxImageWidth) {
                        label_Width = intrinsicWidth - horizontal - label_horizontal;
                    }
                }
                
                if (self.rw_isDynamicFixed) {
                    label_Width = MAX(intrinsicWidth - horizontal - label_horizontal, 0.0f);
                }
            }
        }
            break;
            
        case RWAutoTagImageEdgeInsetStyle_Left:
        case RWAutoTagImageEdgeInsetStyle_Right: {
            
            intrinsicHeight += MAX(maxImageHeight, maxTextHeight);
            if (self.rw_isDynamicFixed) {
                intrinsicWidth = self.rw_dynamicFixedSize.width;
                if (self.rw_dynamicFixedSize.height != UITableViewAutomaticDimension) {
                    intrinsicHeight = self.rw_dynamicFixedSize.height;
                }
            } else {
                intrinsicWidth += MIN(self.rw_safeAreaLayoutMaxWidth - horizontal, maxImageWidth + maxTextWidth + rw_itemSpacing);
            }
            
            intrinsicWidth = [self initSafeAreaWidth:intrinsicWidth];
            
            image_Y = (intrinsicHeight-image_Height)/2;
            if (maxImageHeight > maxTextHeight) {
                image_Y = [self getInsetTop] + [self getImageInsetTop];
            }
            
            label_Y = (intrinsicHeight-label_Height)/2;
           if (maxTextHeight > maxImageHeight) {
               label_Y = [self getTextInsetTop] + [self getTextInsetTop];
           }
            
            
            if (self.rw_imageStyle == RWAutoTagImageEdgeInsetStyle_Left) {
                
                image_X = [self getInsetLeft] + [self getImageInsetLeft];
                label_X = image_X +image_Width +rw_itemSpacing +[self getImageInsetRight] +[self getTextInsetLeft];
                
                if (intrinsicWidth <=(label_Width + label_X + [self getInsetRight] + [self getTextInsetRight])) {
                    label_Width = intrinsicWidth - label_X - [self getInsetRight] -  [self getTextInsetRight];
                   }
                
                if (self.rw_isDynamicFixed) {
                    
                    /*  固定宽 动态高  */
                    image_X = ((intrinsicWidth - horizontal) - (image_Width +label_Width) - rw_itemSpacing)/2;
                    label_X = image_X +image_Width +rw_itemSpacing + image_horizontal;
                    if (intrinsicWidth <= (maxImageWidth + maxTextWidth + horizontal +rw_itemSpacing)) {
                        image_X = [self getInsetLeft] + [self getImageInsetLeft];
                        if (maxImageWidth >= (intrinsicWidth- horizontal)) {
                            image_X = (intrinsicWidth - image_Width)/2;
                        }
                        label_X = image_X +image_Width +rw_itemSpacing + [self getImageInsetRight] + [self getTextInsetLeft];
                        label_Width = intrinsicWidth - label_X - [self getInsetRight] -  [self getTextInsetRight];
                        if (label_Width <0) {
                            label_Width = 0;
                        }
                    }
                    
                    
                    /*  固定宽 固定高  */
                    if (self.rw_dynamicFixedSize.height != UITableViewAutomaticDimension) {
                        double new_fixedSize_height = intrinsicHeight - vertical - image_vertical;
                        image_Height = new_fixedSize_height;
                        image_Width = image_AspectRatio *image_Height;
                        label_X = image_X + image_Width + image_horizontal + rw_itemSpacing;
                        if (new_fixedSize_height > label_Height) {
                           label_Y = (new_fixedSize_height - label_Height)/2 + [self getTextInsetTop];
                        }
                        label_Width = MAX(intrinsicWidth - horizontal - image_horizontal - label_horizontal - image_Width - rw_itemSpacing, 0.0f);
                    }
                }
            } else if (self.rw_imageStyle == RWAutoTagImageEdgeInsetStyle_Right) {
                label_X = [self getInsetLeft] + [self getTextInsetLeft];
                image_X =  intrinsicWidth - image_Width - [self getInsetRight] - [self getImageInsetRight];
                label_Width = image_X - label_X -  rw_itemSpacing - [self getTextInsetRight] - [self getImageInsetLeft];
                if (self.rw_isDynamicFixed) {
                    /*  固定宽 动态高  */
                   label_X = ((self.rw_dynamicFixedSize.width - horizontal) - (image_Width +label_Width) - rw_itemSpacing)/2;
                   image_X = label_X +label_Width +rw_itemSpacing;
                    if (intrinsicWidth <= (maxImageWidth + maxTextWidth + rw_itemSpacing + horizontal) ) {
                        image_X =  intrinsicWidth - image_Width - [self getInsetRight] - [self getImageInsetRight];
                        if (maxImageWidth >=(intrinsicWidth- horizontal)) {
                            image_X  = (intrinsicWidth - image_Width)/2;
                        }
                        
                        label_X = [self getInsetLeft] +[self getTextInsetLeft];
                        label_Width = MAX(image_X - label_X -  rw_itemSpacing - [self getTextInsetRight] - [self getImageInsetLeft], 0.0f);
                    }
                    
                    /*  固定宽 固定高  */
                    if (self.rw_dynamicFixedSize.height != UITableViewAutomaticDimension) {
                        double new_fixedSize_height = intrinsicHeight - vertical - image_vertical;
                        image_Height = new_fixedSize_height;
                        image_Width = image_AspectRatio *image_Height;
                        if (new_fixedSize_height > label_Height) {
                           label_Y = (new_fixedSize_height - label_Height)/2 + [self getTextInsetTop];
                        }
                        label_Width = MAX(intrinsicWidth - horizontal - image_horizontal - label_horizontal - image_Width - rw_itemSpacing, 0.0f);
                        image_X = intrinsicWidth - image_Width - [self getInsetRight] - [self getImageInsetRight];
                    }
               }
            }
        }
            break;
    
        default:
            break;
    }
    
    
    self.imageView.frame = CGRectMake(image_X, image_Y,image_Width,image_Height);
    self.titleLabel.frame = CGRectMake(label_X, label_Y,label_Width, label_Height);
    if (self.rw_isDynamicFixed) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        if (self.rw_dynamicFixedSize.height != UITableViewAutomaticDimension) {
            intrinsicHeight = self.rw_dynamicFixedSize.height;
        }
    }
    
    
   return CGSizeMake(intrinsicWidth, intrinsicHeight);
}


#pragma mark --- CustomAutoTagStyle_Custom Frame

- (CGSize)reloadAutoButtonStyle_Custom {
    self.imageView.frame = CGRectMake(0, 0,0,0);
    self.titleLabel.frame = CGRectMake(0, 0,0, 0);
   return CGSizeMake(0, 0);
}

- (void)reloadAutoTagButtonFrame {
    
    CGSize newSize = CGSizeMake(0, 0);
    
    switch (self.rw_autoTagButtonStyle) {
        case RWAutoTagButtonStyle_Text:
            newSize = [self reloadAutoButtonStyle_Text];
            break;
        
        case RWAutoTagButtonStyle_Image:
            newSize = [self reloadAutoButtonStyle_Image];
            break;
            
        case RWAutoTagButtonStyle_Mingle:
            newSize = [self reloadAutoButtonStyle_Mingle];
            break;
            
        case RWAutoTagButtonStyle_Custom:
            newSize = [self reloadAutoButtonStyle_Custom];
            break;
            
        default:
            break;
    };
    self.rw_size = newSize;
}

- (CGFloat)initSafeAreaWidth:(CGFloat)newIntrinsicWidth {
    if (newIntrinsicWidth >=self.rw_safeAreaLayoutMaxWidth) {
        newIntrinsicWidth = self.rw_safeAreaLayoutMaxWidth;
    }
    return newIntrinsicWidth;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
//     NSLog(@"drawRect%@ %@",NSStringFromCGRect(rect),NSStringFromUIEdgeInsets(self.contentEdgeInsets));
//    [self reloadAutoTagButtonFrame];
}

@end
