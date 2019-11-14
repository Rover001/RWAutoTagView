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
    self.lineitemSpacing = 0.0f;
    self.safeAreaLayoutMaxWidth = [UIScreen mainScreen].bounds.size.width;
    self.autoTagButtonStyle = RWAutoTagButtonStyle_Text;
    self.imageStyle =  RWAutoTagButtonImageStyle_Left;
    self.autoTag = [[RWAutoTag alloc]init];
    self.backgroundColor = [UIColor redColor];
    self.imageView.backgroundColor = [UIColor yellowColor];
    self.titleLabel.backgroundColor = [UIColor blueColor];
    self.clipsToBounds = YES;
    self.isDynamicFixed = NO;
    self.dynamicFixedSize = CGSizeZero;
}

- (void)initAutoButtonSubViews {
    
    switch (self.autoTagButtonStyle) {
        case RWAutoTagButtonStyle_Text:
//            [self setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            break;
            
        case RWAutoTagButtonStyle_Image:
            [self setAttributedTitle:[[NSAttributedString alloc]init] forState:UIControlStateNormal];
            [self setTitle:@""forState:UIControlStateNormal];
            [self setImage:[NSBundle rw_autotagImage] forState:UIControlStateNormal];
            break;
            
        case RWAutoTagButtonStyle_Mingle:
        {
            [self setImage:[NSBundle rw_autotagImage] forState:UIControlStateNormal];
        }
            break;
        case RWAutoTagButtonStyle_Custom:
        default:
            break;
    }
}

#pragma mark CustomAutoTag

+ (instancetype)autoTagButtonWithAutoTag:(RWAutoTag *)autoTag {
    RWAutoTagButton *autoTagButton = [RWAutoTagButton buttonWithType:UIButtonTypeCustom];
    
    if (autoTag) {
        autoTagButton.autoTag = autoTag;
    }
    return autoTagButton;
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


- (RWAutoTagButtonImageStyle)getAutoButtonImageStyleInImageStyle:(RWAutoTagImageEdgeInsetStyle)imageStyle {
    RWAutoTagButtonImageStyle imageEdgeInsetStyle = RWAutoTagButtonImageStyle_Center;
       switch (imageStyle) {
           case RWAutoTagImageEdgeInsetStyle_Top:
               imageEdgeInsetStyle = RWAutoTagButtonImageStyle_Top;
               break;
               
           case RWAutoTagImageEdgeInsetStyle_Left:
               imageEdgeInsetStyle = RWAutoTagButtonImageStyle_Left;
               break;
               
           case RWAutoTagImageEdgeInsetStyle_Right:
               imageEdgeInsetStyle = RWAutoTagButtonImageStyle_Right;
               break;
               
           case RWAutoTagImageEdgeInsetStyle_Bottom:
               imageEdgeInsetStyle = RWAutoTagButtonImageStyle_Bottom;
               break;
               
           default:
               break;
       }
       
       return imageEdgeInsetStyle;
}

- (void)setAutoTag:(RWAutoTag *)autoTag {
    _autoTag = autoTag;
    if (_autoTag) {
        self.safeAreaLayoutMaxWidth = autoTag.safeAreaLayoutMaxWidth;
        self.autoTagButtonStyle = [self getAutoButtonStyleInAutoTagStyle:autoTag.style];
        self.imageStyle = [self getAutoButtonImageStyleInImageStyle:autoTag.imageEdgeInsetStyle];
        [self initAutoButtonSubViewsInAutoTag:autoTag];
    }
}

- (void)initAutoButtonSubViewsInAutoTag:(RWAutoTag *)autoTag {
    if (autoTag.attributedText.length) {
        [self setAttributedTitle:autoTag.attributedText forState:UIControlStateNormal];
    } else {
        [self setTitle:autoTag.text forState:UIControlStateNormal];
        self.titleLabel.font = autoTag.font ?: [UIFont systemFontOfSize: autoTag.fontSize];
    }
    
    self.contentEdgeInsets = autoTag.paddingInsets;
    self.userInteractionEnabled = autoTag.enable;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    if (autoTag.style == RWAutoTagStyle_Image) {
        [self setImage:[NSBundle rw_autotagImage] forState:UIControlStateNormal];
    }
//
    [self initAutoButtonSubViews];
    
   
}


#pragma mark - Set Attribute

- (void)setImageStyle:(RWAutoTagButtonImageStyle)imageStyle {
    if (_imageStyle != imageStyle) {
        _imageStyle = imageStyle;
        if (self.autoTagButtonStyle == RWAutoTagButtonStyle_Image ||
            self.autoTagButtonStyle == RWAutoTagButtonStyle_Mingle) {
            [self initAutoButtonSubViews];
            [self setNeedsLayout];
        }
    }
}


- (void)setAutoTagButtonStyle:(RWAutoTagButtonStyle)autoTagButtonStyle {
    if (_autoTagButtonStyle != autoTagButtonStyle) {
        _autoTagButtonStyle = autoTagButtonStyle;
        [self initAutoButtonSubViews];
        [self setNeedsLayout];
    }
}

- (void)setSafeAreaLayoutMaxWidth:(CGFloat)safeAreaLayoutMaxWidth {
    if (_safeAreaLayoutMaxWidth != safeAreaLayoutMaxWidth) {
        _safeAreaLayoutMaxWidth = safeAreaLayoutMaxWidth;
        self.autoTag.safeAreaLayoutMaxWidth = safeAreaLayoutMaxWidth;
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
    
    switch (self.autoTagButtonStyle) {
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

- (CGFloat)getContentInsetsTop {return self.contentEdgeInsets.top;}
- (CGFloat)getContentInsetsLeft {return self.contentEdgeInsets.left;}
- (CGFloat)getContentInsetsRight {return self.contentEdgeInsets.right;}
- (CGFloat)getContentInsetsBottom {return self.contentEdgeInsets.bottom;}

- (CGFloat)getInsetTop {return self.contentEdgeInsets.top;}
- (CGFloat)getInsetLeft {return self.contentEdgeInsets.left;}
- (CGFloat)getInsetRight {return self.contentEdgeInsets.right;}
- (CGFloat)getInsetBottom {return self.contentEdgeInsets.bottom;}

#pragma mark -- UIImageView UIEdgeInsets CGSize

- (CGFloat)getImageViewInsetsTop {return self.imageEdgeInsets.top;}
- (CGFloat)getImageViewInsetsLeft {return self.imageEdgeInsets.left;}
- (CGFloat)getImageViewInsetsRight {return self.imageEdgeInsets.right;}
- (CGFloat)getImageViewInsetsBottom {return self.imageEdgeInsets.bottom;}
- (CGFloat)getImageViewWidth {return self.currentImage.size.width;}
- (CGFloat)getImageViewHeight {return self.currentImage.size.height;}
- (CGFloat)getImageViewMaxHeight {
    return [self getImageHeight] + [self getImageInsetTop] + [self getImageInsetBottom];
}
- (CGFloat)getImageViewMaxWidth {
    return [self getImageViewWidth ] + [self getImageViewInsetsLeft] + [self getImageViewInsetsRight];
}



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

- (CGFloat)getLabelInsetsTop {return self.titleEdgeInsets.top;}
- (CGFloat)getLabelInsetsLeft {return self.titleEdgeInsets.left;}
- (CGFloat)getLabelInsetsRight {return self.titleEdgeInsets.right;}
- (CGFloat)getLabelInsetsBottom {return self.titleEdgeInsets.bottom;}
- (CGFloat)getLabelHeight {return self.titleLabel.intrinsicContentSize.height;}
- (CGFloat)getLabelMaxHeight {
    return [self getLabelHeight] + [self getLabelInsetsTop] + [self getLabelInsetsBottom];
}
- (CGFloat)getLabelWidth {return self.titleLabel.intrinsicContentSize.width;}
- (CGFloat)getLabelMaxWidth {
    return [self getLabelWidth ] + [self getLabelInsetsLeft] + [self getLabelInsetsRight];
}


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

    CGFloat lineInsets = [self getInsetLeft] + [self getInsetRight];
    CGFloat label_lineInsets = [self getTextInsetLeft] + [self getTextInsetRight];
    
    CGFloat intrinsicHeight = [self getInsetTop] + [self getInsetBottom];
    CGFloat intrinsicWidth = lineInsets;
    
    
    intrinsicHeight +=  [self getMaxTextHeight];
    if (self.isDynamicFixed) {
        intrinsicWidth = self.dynamicFixedSize.width;
    } else {
        intrinsicWidth += [self getMaxTextWidth];
    }
    intrinsicWidth = [self initSafeAreaWidth:intrinsicWidth];
    CGFloat label_X = [self getInsetLeft] + [self getTextInsetLeft];
    CGFloat label_Y = [self getInsetTop] + [self getTextInsetTop];
    CGFloat label_Width = [self getTextWidth];
    CGFloat label_Height = [self getTextHeight];
    
    if (intrinsicWidth >=self.safeAreaLayoutMaxWidth) {
        label_Width = intrinsicWidth - lineInsets - label_lineInsets;
    }
    
    if (self.isDynamicFixed) {
        if (label_Width > self.dynamicFixedSize.width) {
            label_Width = self.dynamicFixedSize.width - lineInsets - label_lineInsets;
        }
        label_X = (intrinsicWidth - label_Width)/2;
    }
    
    self.titleLabel.frame = CGRectMake(label_X, label_Y,label_Width, label_Height);
    self.imageView.frame = CGRectMake(0, 0,0,0);
    
    return CGSizeMake(intrinsicWidth, intrinsicHeight);
}


#pragma mark -- reloadAutoButtonStyle_Image 计算纯图片

- (CGSize)reloadAutoButtonStyle_Image {
    
    
    CGFloat lineInsets = [self getInsetLeft] + [self getInsetRight];
    CGFloat image_lineInsets = [self getImageInsetLeft] + [self getImageInsetRight];
    
    CGFloat intrinsicHeight = [self getContentInsetsTop] + [self getContentInsetsBottom];
    CGFloat intrinsicWidth = lineInsets;
    
    intrinsicHeight +=  [self getMaxImageHeight];
    if (self.isDynamicFixed) {
        intrinsicWidth = self.dynamicFixedSize.width;
    } else {
        intrinsicWidth += [self getMaxImageWidth];
    }
        
    intrinsicWidth = [self initSafeAreaWidth:intrinsicWidth];
    
    
    CGFloat image_X = [self getInsetLeft] + [self getImageInsetLeft];
    CGFloat image_Y = [self getInsetTop] + [self getImageInsetTop];
    CGFloat image_Width = [self getImageWidth];
    CGFloat image_Height = [self getImageHeight];
    
    if (intrinsicWidth >=self.safeAreaLayoutMaxWidth) {
           image_Width = intrinsicWidth - lineInsets - image_lineInsets;
       }
    
    if (self.isDynamicFixed) {
        if (image_Width > self.dynamicFixedSize.width) {
            image_Width = self.dynamicFixedSize.width;
        }
        image_X = (intrinsicWidth - image_Width)/2;
    }
    
    self.imageView.frame = CGRectMake(image_X, image_Y,image_Width,image_Height);
    self.titleLabel.frame = CGRectMake(0, 0,0, 0);
    return CGSizeMake(intrinsicWidth, intrinsicHeight);
}

#pragma mark -- reloadAutoButtonStyle_Mingle 计算图文结合

- (CGSize)reloadAutoButtonStyle_Mingle {
    
    CGFloat lineitemSpacing = self.lineitemSpacing;
    CGFloat intrinsicHeight = [self getInsetTop] + [self getInsetBottom];
    CGFloat intrinsicWidth = [self getInsetLeft] + [self getInsetRight];
    CGFloat image_X = 0.0f;
    CGFloat image_Y = 0.0f;
    CGFloat image_Width = [self getImageWidth];
    CGFloat image_Height = [self getImageHeight];
    CGFloat label_X = 0.0f;
    CGFloat label_Y = 0.0f;
    CGFloat label_Width = [self getTextWidth];
    CGFloat label_Height = [self getTextHeight];
   
    
    CGFloat lineInsets = [self getInsetLeft] + [self getInsetRight];
    CGFloat image_lineInsets = [self getImageInsetLeft] + [self getImageInsetRight];
    CGFloat label_lineInsets = [self getTextInsetLeft] + [self getTextInsetRight];
   
    CGFloat maxImageHeight = [self getMaxImageHeight];
    CGFloat maxImageWidth = [self getMaxImageWidth];
    CGFloat maxTextHeight = [self getMaxTextHeight];
    CGFloat maxTextWidth = [self getMaxTextWidth];
    
    if (self.isDynamicFixed) {
        if (image_Width > self.dynamicFixedSize.width) {
            image_Width = self.dynamicFixedSize.width - image_lineInsets - lineInsets;
        }

        if (label_Width > self.dynamicFixedSize.width) {
            label_Width = self.dynamicFixedSize.width -label_lineInsets - lineInsets;
        }

        if (maxImageWidth > self.dynamicFixedSize.width) {
            maxImageWidth = self.dynamicFixedSize.width - lineInsets;
            image_Width = maxImageWidth - image_lineInsets;
        }

        if (maxTextWidth > self.dynamicFixedSize.width) {
            maxTextWidth = self.dynamicFixedSize.width - lineInsets;
            label_Width = maxTextWidth - label_lineInsets;
        }
    }
    
    
    
    
    
    
    switch (self.imageStyle) {
        case RWAutoTagImageEdgeInsetStyle_Top:
        case RWAutoTagImageEdgeInsetStyle_Bottom:{
            intrinsicHeight += maxImageHeight + maxTextHeight +lineitemSpacing;
            
            if (self.isDynamicFixed) {
                    intrinsicWidth = self.dynamicFixedSize.width;
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
            
            if (self.imageStyle == RWAutoTagImageEdgeInsetStyle_Top) {/* 🐱 图片在上边 */
                image_Y = [self getInsetTop] + [self getImageInsetTop];
                label_Y = image_Y +image_Height + [self getImageInsetBottom] +lineitemSpacing + [self getTextInsetTop];
                
                if (intrinsicWidth < ( MAX(maxTextWidth, maxImageWidth) + lineInsets) ) {
                    if (maxTextWidth > maxImageWidth) {
                        label_Width = intrinsicWidth - lineInsets - label_lineInsets;
                    }
               }
                
            } else if (self.imageStyle == RWAutoTagImageEdgeInsetStyle_Bottom) {
                
                label_Y = [self getInsetTop] + [self getTextInsetTop];
                image_Y = label_Y +label_Height + [self getTextInsetBottom] +lineitemSpacing + [self getImageInsetTop];
                if (intrinsicWidth < ( MAX(maxTextWidth, maxImageWidth) + lineInsets) ) {
                    if (maxTextWidth > maxImageWidth) {
                        label_Width = intrinsicWidth - lineInsets - label_lineInsets;
                    }
                }
            }
        }
            break;
            
        case RWAutoTagImageEdgeInsetStyle_Left:
        case RWAutoTagImageEdgeInsetStyle_Right: {
            
            intrinsicHeight += MAX(maxImageHeight, maxTextHeight);
            if (self.isDynamicFixed) {
                 intrinsicWidth = self.dynamicFixedSize.width;
            } else {
                intrinsicWidth += MIN(self.safeAreaLayoutMaxWidth - lineInsets, maxImageWidth + maxTextWidth + lineitemSpacing);
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
            
            
            if (self.imageStyle == RWAutoTagImageEdgeInsetStyle_Left) {
                
                image_X = [self getInsetLeft] + [self getImageInsetLeft];
                label_X = image_X +image_Width +lineitemSpacing +[self getImageInsetRight] +[self getTextInsetLeft];
                
                if (intrinsicWidth <=(label_Width + label_X + [self getInsetRight] + [self getTextInsetRight])) {
                    label_Width = intrinsicWidth - label_X - [self getInsetRight] -  [self getTextInsetRight];
                   }
                
                if (self.isDynamicFixed) {
                    image_X = ((self.dynamicFixedSize.width - lineInsets) - (image_Width +label_Width) - lineitemSpacing)/2;
                    label_X = image_X +image_Width +lineitemSpacing + image_lineInsets;
                    if (intrinsicWidth <= (maxImageWidth + maxTextWidth + lineInsets +lineitemSpacing)) {
                        image_X = [self getInsetLeft] + [self getImageInsetLeft];
                        if (maxImageWidth >= (intrinsicWidth- lineInsets)) {
                            image_X = (intrinsicWidth - image_Width)/2;
                        }
                        label_X = image_X +image_Width +lineitemSpacing + [self getImageInsetRight] + [self getTextInsetLeft];
                        label_Width = intrinsicWidth - label_X - [self getInsetRight] -  [self getTextInsetRight];
                        if (label_Width <0) {
                            label_Width = 0;
                        }

                        
                                            }
                }
            } else if (self.imageStyle == RWAutoTagImageEdgeInsetStyle_Right) {
                label_X = [self getInsetLeft] + [self getTextInsetLeft];
                image_X =  intrinsicWidth - image_Width - [self getInsetRight] - [self getImageInsetRight];
                label_Width = image_X - label_X -  lineitemSpacing - [self getTextInsetRight] - [self getImageInsetLeft];
                if (self.isDynamicFixed) {
                   label_X = ((self.dynamicFixedSize.width - lineInsets) - (image_Width +label_Width) - lineitemSpacing)/2;
                   image_X = label_X +label_Width +lineitemSpacing;
                    if (intrinsicWidth <= (maxImageWidth + maxTextWidth + lineitemSpacing + lineInsets) ) {
                        image_X =  intrinsicWidth - image_Width - [self getInsetRight] - [self getImageInsetRight];
                        if (maxImageWidth >=(intrinsicWidth- lineInsets)) {
                            image_X  = (intrinsicWidth - image_Width)/2;
                        }
                        
                        label_X = [self getInsetLeft] +[self getTextInsetLeft];
                        label_Width = image_X - label_X -  lineitemSpacing - [self getTextInsetRight] - [self getImageInsetLeft];
                        if (label_Width <0) {
                            label_Width = 0;
                        }
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
    if (self.isDynamicFixed) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
   return CGSizeMake(intrinsicWidth, intrinsicHeight);
}


#pragma mark --- CustomAutoTagStyle_Custom Frame

- (CGSize)reloadAutoButtonStyle_Custom{
    self.imageView.frame = CGRectMake(0, 0,0,0);
    self.titleLabel.frame = CGRectMake(0, 0,0, 0);
   return CGSizeMake(0, 0);
}

- (void)reloadAutoTagButtonFrame {
    
    CGSize newSize = CGSizeMake(0, 0);
    
    switch (self.autoTagButtonStyle) {
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
    if (newIntrinsicWidth >=self.safeAreaLayoutMaxWidth) {
        newIntrinsicWidth = self.safeAreaLayoutMaxWidth;
    }
    return newIntrinsicWidth;
}

- (CGFloat)intrinsicSafeWidth:(CGFloat)newIntrinsicWidth {
    if (newIntrinsicWidth >=self.safeAreaLayoutMaxWidth) {
        newIntrinsicWidth = self.safeAreaLayoutMaxWidth;
        //- ([self getContentInsetsLeft] + [self getContentInsetsRight]);
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
