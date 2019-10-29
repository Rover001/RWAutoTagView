//
//  RWAutoTagButtonViewController.m
//  RWAutoTagViewDemo
//
//  Created by linmao on 2019/10/29.
//  Copyright © 2019 曾云. All rights reserved.
//

#import "RWAutoTagButtonViewController.h"

@interface RWAutoTagButtonViewController ()
@property (weak, nonatomic) IBOutlet RWAutoTagButton *xib_AutoTagButton;




@property (weak, nonatomic) IBOutlet UIView *imageBackView;



@end

@implementation RWAutoTagButtonViewController
- (IBAction)style_text:(UIButton *)sender {
    self.xib_AutoTagButton.autoTagButtonStyle =RWAutoTagButtonStyle_Text;
     [self.xib_AutoTagButton setTitle:@"测试纯文字" forState:UIControlStateNormal];
    self.imageBackView.hidden = YES;
}
- (IBAction)style_image:(UIButton *)sender {
    self.xib_AutoTagButton.autoTagButtonStyle =RWAutoTagButtonStyle_Image;
    [self.xib_AutoTagButton setImage:[UIImage imageNamed:@"comment_selected"] forState:UIControlStateNormal];
    //bundle里面有默认图片
    self.imageBackView.hidden = YES;
    
}
- (IBAction)style_mingle:(UIButton *)sender {
    self.xib_AutoTagButton.autoTagButtonStyle =RWAutoTagButtonStyle_Mingle;
    [self.xib_AutoTagButton setImage:[UIImage imageNamed:@"comment_selected"] forState:UIControlStateNormal];
    [self imageInsetStyle_left:nil];
    self.imageBackView.hidden = NO;
}
- (IBAction)imageInsetStyle_left:(UIButton *)sender {
    self.xib_AutoTagButton.imageEdgeInsetStyle =RWAutoTagButtonImageEdgeInsetStyleLeft;
    [self.xib_AutoTagButton setTitle:@"图片在左边" forState:UIControlStateNormal];
//     [self.xib_AutoTagButton setImage:[UIImage imageNamed:@"comment_selected"] forState:UIControlStateNormal];
}
- (IBAction)imageInsetStyle_right:(UIButton *)sender {
    self.xib_AutoTagButton.imageEdgeInsetStyle =RWAutoTagButtonImageEdgeInsetStyleRight;
     [self.xib_AutoTagButton setTitle:@"图片在右边" forState:UIControlStateNormal];
//     [self.xib_AutoTagButton setImage:[UIImage imageNamed:@"comment_selected"] forState:UIControlStateNormal];
}
- (IBAction)imageInsetStyle_top:(UIButton *)sender {
    self.xib_AutoTagButton.imageEdgeInsetStyle =RWAutoTagButtonImageEdgeInsetStyleTop;
    [self.xib_AutoTagButton setTitle:@"图片在上边" forState:UIControlStateNormal];
//     [self.xib_AutoTagButton setImage:[UIImage imageNamed:@"comment_selected"] forState:UIControlStateNormal];
}
- (IBAction)imageInsetStyle_bottom:(UIButton *)sender {
    self.xib_AutoTagButton.imageEdgeInsetStyle =RWAutoTagButtonImageEdgeInsetStyleBottom;
    [self.xib_AutoTagButton setTitle:@"图片在下边" forState:UIControlStateNormal];
// [self.xib_AutoTagButton setImage:[UIImage imageNamed:@"comment_selected"] forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"xib、stortboard使用介绍以及效果";
//    self.xib_AutoTagButton.autoTagButtonStyle = RWAutoTagButtonStyle_Image;
    self.xib_AutoTagButton.backgroundColor = [UIColor redColor];
    [self.xib_AutoTagButton setTitle:@"测试纯文字" forState:UIControlStateNormal];
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
