//
//  RWAutoTagViewViewController.m
//  RWAutoTagViewDemo
//
//  Created by linmao on 2019/10/28.
//  Copyright © 2019 曾云. All rights reserved.
//

#import "RWAutoTagViewViewController.h"

@interface RWAutoTagViewViewController ()<RWAutoTagViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *autoTagView_BackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *autoTagView_BackView_Height;




@property (weak, nonatomic) IBOutlet RWAutoTagView *xib_AutoTagView;

@end

@implementation RWAutoTagViewViewController


- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        NSLog(@"RWAutoTagViewViewController:initWithCoder");
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      NSLog(@"RWAutoTagViewViewController:initWithNibName");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     NSLog(@"%f %f",self.view.frame.size.width,[UIScreen mainScreen].bounds.size.width);
    self.navigationItem.title = @"RWAutoTagView介绍以及效果";
    self.isXibLoadAutoTagView = NO;
    if (!self.isXibLoadAutoTagView) {
        self.xib_AutoTagView.insets = UIEdgeInsetsMake(10, 10, 10, 10);
        self.xib_AutoTagView.safeAreaLayoutMaxWidth = self.view.frame.size.width;
//        self.xib_AutoTagView.dataSource = self;
        self.autoTagView_BackView_Height.constant = self.xib_AutoTagView.intrinsicContentSize.height;
        
    } else {
//        self.xib_AutoTagView.hidden = YES;
//        RWAutoTagView *autoTagView = [RWAutoTagView autoTagViewWithAutoSortStyle:RWAutoTagViewAutoSortStyleNormal];
//        autoTagView.dataSource = self;
//        autoTagView.delegate = self;
//        autoTagView.insets = UIEdgeInsetsMake(10, 10, 10, 10);
//        autoTagView.backgroundColor = [UIColor cyanColor];
    //    autoTagView.itemAutoSortStyle = CustomAutoTagViewItemAutoSortStyleAscending;
//        autoTagView.rw_y  = 40.0f;
    //    [autoTagView layoutSubviews];
//        [self.autoTagView_BackView addSubview:autoTagView];
//        [autoTagView reloadData];
//        self.autoTagView_BackView_Height.constant = autoTagView.intrinsicContentSize.height;
    }
   
}
- (IBAction)autoSortNormal:(UIButton *)sender {
    
    self.xib_AutoTagView.autoSortStyle = RWAutoTagViewAutoSortStyleNormal;
    self.autoTagView_BackView_Height.constant = self.xib_AutoTagView.intrinsicContentSize.height;
 
    NSLog(@"RWAutoTagViewAutoSortStyleNormal:%f  %@",self.xib_AutoTagView.intrinsicContentSize.height,NSStringFromCGSize(self.xib_AutoTagView.rw_size));
}
- (IBAction)autoSortDescending:(UIButton *)sender {
    self.xib_AutoTagView.autoSortStyle = RWAutoTagViewAutoSortStyleDescending;
    self.autoTagView_BackView_Height.constant = self.xib_AutoTagView.intrinsicContentSize.height;
    NSLog(@"RWAutoTagViewAutoSortStyleDescending:%f  %@",self.xib_AutoTagView.intrinsicContentSize.height,NSStringFromCGSize(self.xib_AutoTagView.rw_size));
}
- (IBAction)autoSortAseending:(UIButton *)sender {
    self.xib_AutoTagView.autoSortStyle = RWAutoTagViewAutoSortStyleAscending;
    self.autoTagView_BackView_Height.constant = self.xib_AutoTagView.intrinsicContentSize.height;
NSLog(@"RWAutoTagViewAutoSortStyleAscending:%f  %@",self.xib_AutoTagView.intrinsicContentSize.height,NSStringFromCGSize(self.xib_AutoTagView.rw_size));
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
//    autoTag.safeAreaLayoutMaxWidth = [UIScreen mainScreen].bounds.size.width;
//    autoTag.safeAreaLayoutMaxWidth = 300.0f;
//    NSLog(@"%f %f",self.view.frame.size.width,[UIScreen mainScreen].bounds.size.width);
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

- (CGFloat)safeAreaLayoutMaxWidthInAutoTagView:(RWAutoTagView *)autoTagView {
    
    return [UIScreen mainScreen].bounds.size.width;
}


#pragma mark - RWAutoTagViewDelegate
- (void)autoTagView:(RWAutoTagView *)autoTagView didSelectAutoTagButtonAtIndex:(NSInteger)index {
    NSLog(@"%ld",(long)index);
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
