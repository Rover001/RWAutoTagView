//
//  RWAutoTagViewViewController.m
//  RWAutoTagViewDemo
//
//  Created by linmao on 2019/10/28.
//  Copyright © 2019 曾云. All rights reserved.
//

#import "RWAutoTagViewViewController.h"

@interface RWAutoTagViewViewController ()

@property (weak, nonatomic) IBOutlet UIView *autoTagView_BackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *autoTagView_BackView_Height;




@property (weak, nonatomic) IBOutlet RWAutoTagView *xib_AutoTagView;

@property (nonatomic,assign) NSInteger  count;/* st */

@property (nonatomic,strong) UIButton *sortButton;/* 排序 */
@property (weak, nonatomic) IBOutlet UIButton *normal;

@property (nonatomic,strong) UIButton *lineButton;/* 排列 */
@property (weak, nonatomic) IBOutlet UIButton *autoLine;

@property (nonatomic,strong) UIButton *fullButton;/* 宽样式 */
@property (weak, nonatomic) IBOutlet UIButton *full;

@end

@implementation RWAutoTagViewViewController

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
    self.count = 3;
    self.sortButton = self.normal;
    self.lineButton = self.autoLine;
    self.fullButton = self.full;
    
     NSLog(@"%f %f",self.view.frame.size.width,[UIScreen mainScreen].bounds.size.width);
    self.navigationItem.title = @"xib、stortboard使用介绍以及效果";
    self.xib_AutoTagView.insets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.autoTagView_BackView_Height.constant = self.xib_AutoTagView.intrinsicContentSize.height;
    self.xib_AutoTagView.backgroundColor = [UIColor cyanColor];
   
}
- (IBAction)autoSortNormal:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = !sender.selected;
        [self reloadSortButton:sender];
        self.xib_AutoTagView.autoSortStyle = RWAutoTagViewAutoSortStyleNormal;
        self.autoTagView_BackView_Height.constant = self.xib_AutoTagView.intrinsicContentSize.height;
    }
}
- (IBAction)autoSortDescending:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = !sender.selected;
        [self reloadSortButton:sender];
        self.xib_AutoTagView.autoSortStyle = RWAutoTagViewAutoSortStyleDescending;
        self.autoTagView_BackView_Height.constant = self.xib_AutoTagView.intrinsicContentSize.height;
    }
}

- (IBAction)autoSortAseending:(UIButton *)sender {
    if (!sender.selected) {
       sender.selected = !sender.selected;
       [self reloadSortButton:sender];
       self.xib_AutoTagView.autoSortStyle = RWAutoTagViewAutoSortStyleAscending;
       self.autoTagView_BackView_Height.constant = self.xib_AutoTagView.intrinsicContentSize.height;
   }
    
}

- (IBAction)lineStyleSingle:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = !sender.selected;
        [self reloadLineButton:sender];
        self.xib_AutoTagView.lineStyle = RWAutoTagViewLineStyle_SingleLine;
        self.autoTagView_BackView_Height.constant = self.xib_AutoTagView.intrinsicContentSize.height;
    }
}
- (IBAction)lineStyleAutoLine:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = !sender.selected;
        [self reloadLineButton:sender];
        self.xib_AutoTagView.lineStyle = RWAutoTagViewLineStyle_AutoLine;
        self.autoTagView_BackView_Height.constant = self.xib_AutoTagView.intrinsicContentSize.height;
    }
}

- (IBAction)fullSafeAreaStyleAuto:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = !sender.selected;
        [self reloadFullButton:sender];
        self.xib_AutoTagView.fullSafeAreaStyle = RWAutoTagViewFullSafeAreaStyle_AutoWidth;
    }
}
- (IBAction)fullSafeAreaStyle:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = !sender.selected;
        [self reloadFullButton:sender];
        self.xib_AutoTagView.fullSafeAreaStyle = RWAutoTagViewFullSafeAreaStyle_MaxWidth;
    }
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
        text = @"图文结合,图在上面图文结合,图在上面图文结合,图在上面图文结合,图在上面图文结合,图在上面";
        if (index == 2) {
            imageEdgeInsetStyle = RWAutoTagImageEdgeInsetStyle_Left;
            text = @"图文结合,图在左边图文结合,图在左边图文结合,图在左边图文结合,图在左边";
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
