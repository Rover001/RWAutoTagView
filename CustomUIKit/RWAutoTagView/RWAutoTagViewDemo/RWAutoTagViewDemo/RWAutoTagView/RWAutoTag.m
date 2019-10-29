//
//  RWAutoTag.m
//  RWAutoTagViewDemo
//
//  Created by 曾云 on 2019/10/27.
//  Copyright © 2019 曾云. All rights reserved.
//

#import "RWAutoTag.h"

@implementation RWAutoTag
- (instancetype)init
{
    self = [super init];
    if (self) {
        _style = RWAutoTagStyle_Text;
        _imageEdgeInsetStyle = RWAutoTagImageEdgeInsetStyle_Left;
        _lineitemSpacing = 0.0f;
        _text = @"";
        _safeAreaLayoutMaxWidth = [UIScreen mainScreen].bounds.size.width;
        _attributedText = [[NSAttributedString alloc]init];
        _paddingInsets =  UIEdgeInsetsMake(0,0,0,0);
        _fontSize = 13.0f;
        _enable = YES;
    }
    return self;
}


- (instancetype)initWithText:(NSString *)text {
    self = [self init];
    if (self) {
        self.text = text;
    }
    return self;
}
- (instancetype)initWithAttributedText:(NSAttributedString *)attributedText {
    self = [self init];
    if (self) {
        self.attributedText = attributedText;
    }
    return self;
}

- (instancetype)initWithTagStyle:(RWAutoTagStyle)style {
    self = [self init];
       if (self) {
           self.style = style;
       }
       return self;
}


+ (instancetype)autoTagWithText:(NSString *)text {
    return [[self alloc]initWithText:text];
}
+ (instancetype)autoTagWithAttributedText:(NSAttributedString *)attributedText {
    return [[self alloc] initWithAttributedText:attributedText];
}

+ (instancetype)autoTagWithTagStyle:(RWAutoTagStyle)style {
    return [[self alloc]initWithTagStyle:style];
}

@end
