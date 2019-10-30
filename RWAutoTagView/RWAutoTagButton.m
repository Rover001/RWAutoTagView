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
    self.imageEdgeInsetStyle =  RWAutoTagButtonImageEdgeInsetStyleLeft;
    self.autoTag = [[RWAutoTag alloc]init];
    self.backgroundColor = [UIColor redColor];
    self.imageView.backgroundColor = [UIColor redColor];
    self.titleLabel.backgroundColor = [UIColor blueColor];
    self.clipsToBounds = YES;
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
    
    if (autoTagButton) {
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


- (RWAutoTagButtonImageEdgeInsetStyle)getAutoButtonImageEdgeInsetStyleInImageEdgeInsetStyle:(RWAutoTagImageEdgeInsetStyle)imageInsetStyle {
    RWAutoTagButtonImageEdgeInsetStyle imageEdgeInsetStyle = RWAutoTagButtonImageEdgeInsetStyleLeft;
       switch (imageInsetStyle) {
           case RWAutoTagImageEdgeInsetStyle_Top:
               imageEdgeInsetStyle = RWAutoTagButtonImageEdgeInsetStyleTop;
               break;
               
           case RWAutoTagImageEdgeInsetStyle_Left:
               imageEdgeInsetStyle = RWAutoTagButtonImageEdgeInsetStyleLeft;
               break;
               
           case RWAutoTagImageEdgeInsetStyle_Right:
               imageEdgeInsetStyle = RWAutoTagButtonImageEdgeInsetStyleRight;
               break;
               
           case RWAutoTagImageEdgeInsetStyle_Bottom:
               imageEdgeInsetStyle = RWAutoTagButtonImageEdgeInsetStyleBottom;
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
        self.imageEdgeInsetStyle = [self getAutoButtonImageEdgeInsetStyleInImageEdgeInsetStyle:autoTag.imageEdgeInsetStyle];
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


#pragma mark - CustomAutoTagButton

- (void)setImageEdgeInsetStyle:(RWAutoTagButtonImageEdgeInsetStyle)imageEdgeInsetStyle {
    if (_imageEdgeInsetStyle != imageEdgeInsetStyle) {
        _imageEdgeInsetStyle = imageEdgeInsetStyle;
        if (self.autoTagButtonStyle == RWAutoTagButtonStyle_Image ||
            self.autoTagButtonStyle == RWAutoTagButtonStyle_Mingle) {
            [self initAutoButtonSubViews];
//            [self invalidateIntrinsicContentSize];
            [self setNeedsLayout];
        }
    }
}

- (void)setAutoTagButtonStyle:(RWAutoTagButtonStyle)autoTagButtonStyle {
    if (_autoTagButtonStyle != autoTagButtonStyle) {
        _autoTagButtonStyle = autoTagButtonStyle;
        [self initAutoButtonSubViews];
//        [self invalidateIntrinsicContentSize];
        [self setNeedsLayout];
    }
}

- (void)setSafeAreaLayoutMaxWidth:(CGFloat)safeAreaLayoutMaxWidth {
    if (_safeAreaLayoutMaxWidth != safeAreaLayoutMaxWidth) {
        _safeAreaLayoutMaxWidth = safeAreaLayoutMaxWidth;
//        [self invalidateIntrinsicContentSize];
        self.autoTag.safeAreaLayoutMaxWidth = safeAreaLayoutMaxWidth;
        [self setNeedsLayout];
    }
}


#pragma mark - CustomAutoTagButton Frame

- (CGSize)intrinsicContentSize {
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
    }
    
   return newSize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadAutoTagButtonFrame];
}


#pragma mark -- Label imageView Frame

- (CGFloat)getImageViewInsetsTop {return self.imageEdgeInsets.top;}
- (CGFloat)getImageViewInsetsLeft {return self.imageEdgeInsets.left;}
- (CGFloat)getImageViewInsetsRight {return self.imageEdgeInsets.right;}
- (CGFloat)getImageViewInsetsBottom {return self.imageEdgeInsets.bottom;}
- (CGFloat)getImageViewHeight {return self.currentImage.size.height;}
- (CGFloat)getImageViewMaxHeight {
    return [self getImageViewHeight] + [self getImageViewInsetsTop] + [self getImageViewInsetsBottom];
}
- (CGFloat)getImageViewWidth {return self.currentImage.size.width;}
- (CGFloat)getImageViewMaxWidth {
    return [self getImageViewWidth ] + [self getImageViewInsetsLeft] + [self getImageViewInsetsRight];
}


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


- (CGFloat)getContentInsetsTop {return self.contentEdgeInsets.top;}
- (CGFloat)getContentInsetsLeft {return self.contentEdgeInsets.left;}
- (CGFloat)getContentInsetsRight {return self.contentEdgeInsets.right;}
- (CGFloat)getContentInsetsBottom {return self.contentEdgeInsets.bottom;}

#pragma mark --- CustomAutoTagStyle_Text Frame

- (CGSize)reloadAutoButtonStyle_Text {
    /*
    intrinsicHeight +=  maxLabelHeight;
    intrinsicWidth += maxLabelWidth;
    intrinsicWidth = [self intrinsicSafeWidth:intrinsicWidth];
    label_X = [self getContentInsetsLeft];
    label_Y = [self getContentInsetsTop];
    if (intrinsicWidth >=self.safeAreaLayoutMaxWidth) {
        label_Width = intrinsicWidth - [self getContentInsetsLeft] - [self getContentInsetsRight];
    }
     */
    CGFloat intrinsicHeight = [self getContentInsetsTop] + [self getContentInsetsBottom];
    CGFloat intrinsicWidth = [self getContentInsetsLeft] + [self getContentInsetsRight];

    intrinsicHeight +=  [self getLabelMaxHeight];
    intrinsicWidth += [self getLabelMaxWidth];
    intrinsicWidth = [self intrinsicSafeWidth:intrinsicWidth];
    CGFloat label_X = [self getContentInsetsLeft];
    CGFloat label_Y = [self getContentInsetsTop];
    CGFloat label_Width = [self getLabelWidth];
    CGFloat label_Height = [self getLabelHeight];
    if (intrinsicWidth >=self.safeAreaLayoutMaxWidth) {
        label_Width = intrinsicWidth - [self getContentInsetsLeft] - [self getContentInsetsRight];
    }
    self.titleLabel.frame = CGRectMake(label_X, label_Y,label_Width, label_Height);
    self.imageView.frame = CGRectMake(0, 0,0,0);
   return CGSizeMake(intrinsicWidth, intrinsicHeight);
}


#pragma mark --- CustomAutoTagStyle_Image Frame

- (CGSize)reloadAutoButtonStyle_Image {
    /*
    intrinsicHeight += maxImageHeight;
    intrinsicWidth += maxImageWidth;
    intrinsicWidth = [self intrinsicSafeWidth:intrinsicWidth];
    image_X = [self getContentInsetsLeft];
    image_Y = [self getContentInsetsTop];
     */
    CGFloat intrinsicHeight = [self getContentInsetsTop] + [self getContentInsetsBottom];
    CGFloat intrinsicWidth = [self getContentInsetsLeft] + [self getContentInsetsRight];
    intrinsicHeight +=  [self getImageViewMaxHeight];
    intrinsicWidth += [self getImageViewMaxWidth];
    intrinsicWidth = [self intrinsicSafeWidth:intrinsicWidth];
    CGFloat image_X = [self getContentInsetsLeft];
    CGFloat image_Y = [self getContentInsetsTop];
    CGFloat image_Width = [self getImageViewWidth];
    CGFloat image_Height = [self getImageViewHeight];
    self.imageView.frame = CGRectMake(image_X, image_Y,image_Width,image_Height);
    self.titleLabel.frame = CGRectMake(0, 0,0, 0);
   return CGSizeMake(intrinsicWidth, intrinsicHeight);
}

#pragma mark --- CustomAutoTagStyle_Mingle Frame

- (CGSize)reloadAutoButtonStyle_Mingle {
    /*
    intrinsicHeight += maxImageHeight;
    intrinsicWidth += maxImageWidth;
    intrinsicWidth = [self intrinsicSafeWidth:intrinsicWidth];
    image_X = [self getContentInsetsLeft];
    image_Y = [self getContentInsetsTop];
     */
    CGFloat lineitemSpacing = self.lineitemSpacing;
    CGFloat intrinsicHeight = [self getContentInsetsTop] + [self getContentInsetsBottom];
    CGFloat intrinsicWidth = [self getContentInsetsLeft] + [self getContentInsetsRight];
    CGFloat image_X = 0.0f;
    CGFloat image_Y = 0.0f;
    CGFloat image_Width = [self getImageViewWidth];
    CGFloat image_Height = [self getImageViewHeight];
    CGFloat label_X = 0.0f;
    CGFloat label_Y = 0.0f;
    CGFloat label_Width = [self getLabelWidth];
    CGFloat label_Height = [self getLabelHeight];
   
   
    CGFloat maxImageHeight = [self getImageViewMaxHeight];
    CGFloat maxImageWidth = [self getImageViewMaxWidth];
    CGFloat maxLabelHeight = [self getLabelMaxHeight];
    CGFloat maxLabelWidth = [self getLabelMaxWidth];
    
    
    switch (self.imageEdgeInsetStyle) {
        case RWAutoTagButtonImageEdgeInsetStyleTop:
        case RWAutoTagButtonImageEdgeInsetStyleBottom:{
            intrinsicHeight += maxImageHeight + maxLabelHeight +lineitemSpacing;
            intrinsicWidth += MAX(maxImageWidth, maxLabelWidth);
            intrinsicWidth = [self intrinsicSafeWidth:intrinsicWidth];
            label_X = (intrinsicWidth - label_Width)/2;
            if (maxLabelWidth > maxImageWidth) {
                label_X = [self getContentInsetsLeft];
            }
            
             image_X = (intrinsicWidth - image_Width)/2;
             if (maxImageWidth > maxLabelWidth) {
                 image_X = [self getContentInsetsLeft];
             }
            
            if (self.imageEdgeInsetStyle == RWAutoTagButtonImageEdgeInsetStyleTop) {
                image_Y = [self getContentInsetsTop];
                label_Y = image_Y +image_Height +lineitemSpacing;
            } else if (self.imageEdgeInsetStyle == RWAutoTagButtonImageEdgeInsetStyleBottom) {
                label_Y = [self getContentInsetsTop];
                image_Y = label_Y +label_Height +lineitemSpacing;
            }
            
            if (intrinsicWidth >=self.safeAreaLayoutMaxWidth) {
                label_Width = intrinsicWidth - [self getContentInsetsLeft] - [self getContentInsetsRight];
            }
        }
            break;
            
        case RWAutoTagButtonImageEdgeInsetStyleLeft:
        case RWAutoTagButtonImageEdgeInsetStyleRight: {
            
            intrinsicHeight += MAX(maxImageHeight, maxLabelHeight);
            intrinsicWidth += maxImageWidth + maxLabelWidth +lineitemSpacing;
            intrinsicWidth = [self intrinsicSafeWidth:intrinsicWidth];
            image_Y = (intrinsicHeight-image_Height)/2;
            if (maxImageHeight > maxLabelHeight) {
                image_Y = [self getContentInsetsTop];
            }
            
            label_Y = (intrinsicHeight-label_Height)/2;
           if (maxLabelHeight > maxImageHeight) {
               label_Y = [self getContentInsetsTop];
           }
            
            
            if (self.imageEdgeInsetStyle == RWAutoTagButtonImageEdgeInsetStyleLeft) {
                image_X = [self getContentInsetsLeft];
                label_X = image_X +image_Width +lineitemSpacing;
            } else if (self.imageEdgeInsetStyle == RWAutoTagButtonImageEdgeInsetStyleRight) {
                label_X = [self getContentInsetsLeft];
                image_X =  intrinsicWidth -maxImageWidth - lineitemSpacing - [self getContentInsetsRight];
            }
            
            if (intrinsicWidth >=self.safeAreaLayoutMaxWidth) {
                label_Width = intrinsicWidth -maxImageWidth - lineitemSpacing -[self getContentInsetsLeft] - [self getContentInsetsRight];
            }
        }
            break;
    
        default:
            break;
    }
    CGRect imageRect = CGRectMake(image_X, image_Y,image_Width,image_Height);
    CGRect titleRect = CGRectMake(label_X, label_Y,label_Width, label_Height);
    self.imageView.frame = imageRect;
    self.titleLabel.frame = titleRect;
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
    }
    
    self.rw_size = newSize;
}

- (CGFloat)intrinsicSafeWidth:(CGFloat)newIntrinsicWidth {
    if (newIntrinsicWidth >=self.safeAreaLayoutMaxWidth) {
        newIntrinsicWidth = self.safeAreaLayoutMaxWidth;
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
