//
//  RWAutoTagButtonPureCodeViewController.m
//  RWAutoTagViewDemo
//
//  Created by linmao on 2019/10/29.
//  Copyright © 2019 曾云. All rights reserved.
//

#import "RWAutoTagButtonPureCodeViewController.h"

@interface RWAutoTagButtonPureCodeViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *imageBackView;

@property (nonatomic,strong) RWAutoTagButton *autoTagButton;/* <#注释#> */

@end

@implementation RWAutoTagButtonPureCodeViewController

- (IBAction)style_text:(UIButton *)sender {
    self.autoTagButton.autoTagButtonStyle =RWAutoTagButtonStyle_Text;
    [self.autoTagButton setTitle:@"测试纯文字" forState:UIControlStateNormal];
    self.imageBackView.hidden = YES;
}
- (IBAction)style_image:(UIButton *)sender {
    self.autoTagButton.autoTagButtonStyle =RWAutoTagButtonStyle_Image;
    //bundle里面有默认图片
    self.imageBackView.hidden = YES;
}
- (IBAction)style_mingle:(UIButton *)sender {
    self.autoTagButton.autoTagButtonStyle =RWAutoTagButtonStyle_Mingle;
    //bundle里面有默认图片
    [self.autoTagButton setTitle:@"图片在左边" forState:UIControlStateNormal];
     [self.autoTagButton setImage:[UIImage imageNamed:@"comment_selected"] forState:UIControlStateNormal];
    [self imageInsetStyle_left:nil];
    self.imageBackView.hidden = NO;
}
- (IBAction)imageInsetStyle_left:(UIButton *)sender {
    self.autoTagButton.imageEdgeInsetStyle =RWAutoTagButtonImageEdgeInsetStyleLeft;
     [self.autoTagButton setImage:[UIImage imageNamed:@"comment_selected"] forState:UIControlStateNormal];
    [self.autoTagButton setTitle:@"图片在左边" forState:UIControlStateNormal];
}
- (IBAction)imageInsetStyle_right:(UIButton *)sender {
    self.autoTagButton.imageEdgeInsetStyle =RWAutoTagButtonImageEdgeInsetStyleRight;
    [self.autoTagButton setTitle:@"图片在右边" forState:UIControlStateNormal];
}
- (IBAction)imageInsetStyle_top:(UIButton *)sender {
    self.autoTagButton.imageEdgeInsetStyle =RWAutoTagButtonImageEdgeInsetStyleTop;
     [self.autoTagButton setTitle:@"图片在上边" forState:UIControlStateNormal];
}
- (IBAction)imageInsetStyle_bottom:(UIButton *)sender {
    self.autoTagButton.imageEdgeInsetStyle =RWAutoTagButtonImageEdgeInsetStyleBottom;
    [self.autoTagButton setImage:[UIImage imageNamed:@"comment_selected"] forState:UIControlStateNormal];
    [self.autoTagButton setTitle:@"图片在下边" forState:UIControlStateNormal];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"纯代码使用介绍以及效果";
    // Do any additional setup after loading the view.
    
    RWAutoTagButton *autoTagButton = [RWAutoTagButton buttonWithType:UIButtonTypeCustom];
    autoTagButton.safeAreaLayoutMaxWidth = self.view.rw_w;
    [autoTagButton setTitle:@"纯代码创建" forState:UIControlStateNormal];
    autoTagButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    autoTagButton.backgroundColor = [UIColor redColor];
    autoTagButton.layer .cornerRadius = 4;
    autoTagButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    autoTagButton.frame = CGRectMake(30, 10, self.view.rw_size.width, self.view.rw_size.height);
    [self.backView addSubview:autoTagButton];
    self.autoTagButton = autoTagButton;
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
