//
//  ViewController.m
//  RWAutoTagViewDemo
//
//  Created by 曾云 on 2019/10/27.
//  Copyright © 2019 曾云. All rights reserved.
//

#import "ViewController.h"

#import "RWAutoTagHeader.h"
#import "UIView+RWExtension.h"

@interface ViewController ()<RWAutoTagViewDataSource,RWAutoTagViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    RWAutoTagView *autoTagView = [RWAutoTagView autoTagViewWithAutoSortStyle:RWAutoTagViewAutoSortStyleNormal];
        autoTagView.dataSource = self;
        autoTagView.delegate = self;
        autoTagView.insets = UIEdgeInsetsMake(10, 10, 10, 10);
        autoTagView.backgroundColor = [UIColor cyanColor];
    //    autoTagView.itemAutoSortStyle = CustomAutoTagViewItemAutoSortStyleAscending;
        autoTagView.rw_y  = 40.0f;
    //    [autoTagView layoutSubviews];
        [self.view addSubview:autoTagView];
        NSLog(@"%ld",(long)autoTagView.autoSortStyle);
        NSLog(@"%@",NSStringFromCGSize(autoTagView.intrinsicContentSize));
    //    [autoTagView reloadData];
        autoTagView.autoTagButtonClickBlock = ^(RWAutoTagView * _Nonnull autoTagView, NSInteger index) {
             NSLog(@"%s %ld",__func__,index);
        };
}


- (NSInteger)numberOfAutoTagButtonInAutoTagView:(RWAutoTagView *)autoTagView {
    return 6;
}

- (RWAutoTagButton *)autoTagView:(RWAutoTagView *)autoTagView autoTagButtonForAtIndex:(NSInteger)index {
    NSString *text = @"图文结合";
    RWAutoTagStyle autoTagStyle = RWAutoTagStyle_Mingle;
    if (index == 0) {
        text = @"只有图片";
        autoTagStyle = RWAutoTagStyle_Image;
    } else if (index == 1) {
        autoTagStyle = RWAutoTagStyle_Text;
        text = @"只有文字";
    }
    RWAutoTag *autoTag = [RWAutoTag autoTagWithTagStyle:autoTagStyle];
    autoTag.safeAreaLayoutMaxWidth = self.view.rw_size.width;
    if (autoTagStyle == RWAutoTagStyle_Mingle) {
        RWAutoTagImageEdgeInsetStyle imageEdgeInsetStyle = RWAutoTagImageEdgeInsetStyle_Top;
        text = @"图文结合,图在上面";
        if (index == 2) {
            imageEdgeInsetStyle = RWAutoTagImageEdgeInsetStyle_Left;
            text = @"图文结合,图在左边";
        } else if (index == 3) {
            imageEdgeInsetStyle = RWAutoTagImageEdgeInsetStyle_Right;
            text = @"图文结合,图在右边";
        } else if (index == 4) {
            imageEdgeInsetStyle = RWAutoTagImageEdgeInsetStyle_Bottom;
            text = @"图文结合,图在下边";
        }
        autoTag.imageEdgeInsetStyle = imageEdgeInsetStyle;
    }
    autoTag.text = text;
    return [RWAutoTagButton autoTagButtonWithAutoTag:autoTag];
}


- (void)autoTagView:(RWAutoTagView *)autoTagView didSelectAutoTagButtonAtIndex:(NSInteger)index {
    NSLog(@"%ld",index);
}



@end
