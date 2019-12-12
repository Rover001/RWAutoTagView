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



@property (nonatomic,strong) UIButton *sortButton;/* 排序 */
@property (weak, nonatomic) IBOutlet UIButton *normal;

@property (nonatomic,strong) UIButton *lineButton;/* 排列 */
@property (weak, nonatomic) IBOutlet UIButton *autoLine;

@property (nonatomic,strong) UIButton *fullButton;/* 宽样式 */
@property (weak, nonatomic) IBOutlet UIButton *full;


@end

@implementation RWAutoTagViewPureCodeViewController


- (void)reloadSortButton:(UIButton *)sortButton {
    if (self.sortButton) {
        self.sortButton.selected = NO;
    }
    self.sortButton = sortButton;
}

- (void)reloadLineButton:(UIButton *)lineButton {
    if (self.lineButton) {
        self.lineButton.selected = NO;
    }
    self.lineButton = lineButton;
}


- (void)reloadFullButton:(UIButton *)fullButton {
    if (self.fullButton) {
        self.fullButton.selected = NO;
    }
    self.fullButton = fullButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sortButton = self.normal;
    self.lineButton = self.autoLine;
    self.fullButton = self.full;
    NSLog(@"viewDidLoad = %f",self.view.frame.size.width);
    self.navigationItem.title = @"纯代码使用介绍以及效果";
    RWAutoTagView *autoTagView = [[RWAutoTagView alloc]initAutoTagViewWithLineStyle:RWAutoTagViewLineStyle_DynamicFixedEquallyMulti];
    autoTagView.dataSource = self;
    autoTagView.delegate = self;
    autoTagView.insets = UIEdgeInsetsMake(10, 10, 10, 10);
    autoTagView.backgroundColor = [UIColor yellowColor];
//    autoTagView.autoSortStyle = RWAutoTagViewAutoSortStyleAscending;
//        autoTagView.rw_y  = 40.0f;
//    [autoTagView layoutSubviews];
    [self.backView addSubview:autoTagView];
    autoTagView.backgroundColor = [UIColor cyanColor];
    self.autoTagView = autoTagView;
    self.backView_Constraint_Height.constant = autoTagView.intrinsicContentSize.height;
}


- (IBAction)autoSortNormal:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = !sender.selected;
        [self reloadSortButton:sender];
//        self.autoTagView.autoSortStyle = RWAutoTagViewAutoSortStyleNormal;
        self.backView_Constraint_Height.constant = self.autoTagView.intrinsicContentSize.height;
    }
}
- (IBAction)autoSortDescending:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = !sender.selected;
        [self reloadSortButton:sender];
//        self.autoTagView.autoSortStyle = RWAutoTagViewAutoSortStyleDescending;
        self.backView_Constraint_Height.constant = self.autoTagView.intrinsicContentSize.height;
    }
}

- (IBAction)autoSortAseending:(UIButton *)sender {
    if (!sender.selected) {
       sender.selected = !sender.selected;
       [self reloadSortButton:sender];
       self.autoTagView.autoSortStyle = RWAutoTagViewAutoSortStyleAscending;
       self.backView_Constraint_Height.constant = self.autoTagView.intrinsicContentSize.height;
   }
    
}

- (IBAction)lineStyleSingle:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = !sender.selected;
        [self reloadLineButton:sender];
        self.autoTagView.lineStyle = RWAutoTagViewLineStyle_SingleLine;
        self.backView_Constraint_Height.constant = self.autoTagView.intrinsicContentSize.height;
    }
}
- (IBAction)lineStyleAutoLine:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = !sender.selected;
        [self reloadLineButton:sender];
        self.autoTagView.lineStyle = RWAutoTagViewLineStyle_AutoLine;
        self.backView_Constraint_Height.constant = self.autoTagView.intrinsicContentSize.height;
    }
}

- (IBAction)fullSafeAreaStyleAuto:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = !sender.selected;
        [self reloadFullButton:sender];
        self.autoTagView.fullSafeAreaStyle = RWAutoTagViewFullSafeAreaStyle_AutoWidth;
    }
}
- (IBAction)fullSafeAreaStyle:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = !sender.selected;
        [self reloadFullButton:sender];
        self.autoTagView.fullSafeAreaStyle = RWAutoTagViewFullSafeAreaStyle_MaxWidth;
    }
}




#pragma mark - RWAutoTagViewDataSource
//- (NSInteger)numberOfAutoTagButtonInAutoTagView:(RWAutoTagView *)autoTagView {
//    return 6;
//}
//
//- (RWAutoTagButton *)autoTagView:(RWAutoTagView *)autoTagView autoTagButtonForAtIndex:(NSInteger)index {
//    NSString *text = @"图文结合";
//    RWAutoTagStyle autoTagStyle = RWAutoTagStyle_Mingle;
//    if (index == 0) {
//        text = @"只有图片";
//        autoTagStyle = RWAutoTagStyle_Image;
//    } else if (index == 1) {
//        autoTagStyle = RWAutoTagStyle_Text;
//        text = @"只有文字只有文字只有文字";
//    }
//    RWAutoTag *autoTag = [RWAutoTag autoTagWithTagStyle:autoTagStyle];
//    if (autoTagStyle == RWAutoTagStyle_Mingle) {
//        RWAutoTagImageEdgeInsetStyle imageEdgeInsetStyle = RWAutoTagImageEdgeInsetStyle_Top;
//        text = @"图文结合,图在上面";
//        if (index == 2) {
//            imageEdgeInsetStyle = RWAutoTagImageEdgeInsetStyle_Left;
//            text = @"图文结合,图在左边图文结合,图在左边图文结合,图在左边图文结合,图在左边";
//        } else if (index == 3) {
//            imageEdgeInsetStyle = RWAutoTagImageEdgeInsetStyle_Right;
//            text = @"图文结合,图在右边";
//        } else if (index == 4) {
//            imageEdgeInsetStyle = RWAutoTagImageEdgeInsetStyle_Bottom;
//            text = @"图文结合,图在下边图文结合,图在左边图文结合,图在左边图文结合,图在左边";
//        }
//        autoTag.imageEdgeInsetStyle = imageEdgeInsetStyle;
//    }
//    autoTag.text = text;
//    return [RWAutoTagButton autoTagButtonWithAutoTag:autoTag];
//}


- (NSInteger)numberOfAutoTagButtonInAutoTagView:(RWAutoTagView *)autoTagView {
    return 2;
}

- (NSInteger)equallyNumberOfAutoTagButtonInautoTagView:(RWAutoTagView *)autoTagView {
    return 2;
}

- (RWAutoTagButton *)autoTagView:(RWAutoTagView *)autoTagView autoTagButtonForAtIndex:(NSInteger)index {
    RWAutoTagButton *autoTagButton = [RWAutoTagButton buttonWithType:UIButtonTypeCustom];
    autoTagButton.autoTagButtonStyle = RWAutoTagButtonStyle_Text;
    [autoTagButton setTitle:@"测试一下" forState:UIControlStateNormal];
    autoTagButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [autoTagButton setTitle:@"测试一下" forState:UIControlStateHighlighted];
    autoTagButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    return autoTagButton;
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
