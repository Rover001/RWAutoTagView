//
//  RWAutoTagViewPureCodeViewController.m
//  RWAutoTagViewDemo
//
//  Created by linmao on 2019/10/29.
//  Copyright © 2019 曾云. All rights reserved.
//

#import "RWAutoTagViewPureCodeViewController.h"

@interface RWAutoTagViewPureCodeViewController ()<RWAutoTagViewDataSource,RWAutoTagViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backView_Constraint_Height;
@property (nonatomic,strong) RWAutoTagView *autoTagView;/* <#注释#> */

@end

@implementation RWAutoTagViewPureCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"纯代码使用介绍以及效果";
    RWAutoTagView *autoTagView = [RWAutoTagView autoTagViewWithAutoSortStyle:RWAutoTagViewAutoSortStyleNormal];
    autoTagView.dataSource = self;
    autoTagView.delegate = self;
    autoTagView.insets = UIEdgeInsetsMake(10, 10, 10, 10);
    autoTagView.backgroundColor = [UIColor cyanColor];
    autoTagView.autoSortStyle = RWAutoTagViewAutoSortStyleAscending;
//        autoTagView.rw_y  = 40.0f;
    [autoTagView layoutSubviews];
    [self.backView addSubview:autoTagView];
    self.autoTagView = autoTagView;
    self.backView_Constraint_Height.constant = autoTagView.intrinsicContentSize.height;
}


- (IBAction)autoSortNormal:(UIButton *)sender {
    
    self.autoTagView.autoSortStyle = RWAutoTagViewAutoSortStyleNormal;
    self.backView_Constraint_Height.constant = self.autoTagView.intrinsicContentSize.height;
 
    NSLog(@"RWAutoTagViewAutoSortStyleNormal:%f  %@",self.autoTagView.intrinsicContentSize.height,NSStringFromCGSize(self.autoTagView.rw_size));
}
- (IBAction)autoSortDescending:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.autoTagView.autoSortStyle = RWAutoTagViewAutoSortStyleDescending;
    self.backView_Constraint_Height.constant = self.autoTagView.intrinsicContentSize.height;
    
}
- (IBAction)autoSortAseending:(UIButton *)sender {
    self.autoTagView.autoSortStyle = RWAutoTagViewAutoSortStyleAscending;
    self.backView_Constraint_Height.constant = self.autoTagView.intrinsicContentSize.height;
}

- (IBAction)lineStyleSingle:(UIButton *)sender {
    self.autoTagView.lineStyle = RWAutoTagViewLineStyle_SingleLine;
    self.backView_Constraint_Height.constant = self.autoTagView.intrinsicContentSize.height;
}
- (IBAction)lineStyleAutoLine:(UIButton *)sender {
    self.autoTagView.lineStyle = RWAutoTagViewLineStyle_AutoLine;
    self.backView_Constraint_Height.constant = self.autoTagView.intrinsicContentSize.height;
}

- (IBAction)fullSafeAreaStyleAuto:(UIButton *)sender {
    self.autoTagView.fullSafeAreaStyle = RWAutoTagViewFullSafeAreaStyle_AutoWidth;
}
- (IBAction)fullSafeAreaStyle:(UIButton *)sender {
    self.autoTagView.fullSafeAreaStyle = RWAutoTagViewFullSafeAreaStyle_MaxWidth;
}



#pragma mark - RWAutoTagViewDataSource
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

#pragma mark - RWAutoTagViewDelegate
- (void)autoTagView:(RWAutoTagView *)autoTagView didSelectAutoTagButtonAtIndex:(NSInteger)index {
    NSLog(@"%ld",(long)index);
}

- (void)autoTagView:(RWAutoTagView *)autoTagView autoLayoutAutoTagButtonAtIndex:(NSInteger )index {
    NSLog(@"%@",NSStringFromCGSize(autoTagView.rw_size));
//    self.autoTagView_BackView_Height.constant = autoTagView.rw_size.height;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
