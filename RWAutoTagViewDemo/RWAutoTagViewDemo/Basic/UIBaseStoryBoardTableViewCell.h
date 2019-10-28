//
//  UIBaseStoryBoardTableViewCell.h
//  MaoBuTou
//
//  Created by 心冷如灰 on 2017/9/21.
//  Copyright © 2017年 心冷如灰. All rights reserved.
//

#import <UIKit/UIKit.h>

//IB_DESIGNABLE

@interface UIBaseStoryBoardTableViewCell : UITableViewCell

@property (nonatomic,strong) IBInspectable  UIColor *border_Color;

//@property (nonatomic,strong) UIBaseViewController *viewController;

/**
 这个方法是给使用StoryBoard获取ViewController里面的cell使用
 
 @param tableView ViewController 里面的cell
 @param identifier StoryBoard ->ViewController->UITableViewCell的标记（identifier）
 @return 返回 cell
 */

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

/**
  这个方法是给使用StoryBoard获取ViewController里面的cell使用
 
  @param tableView ViewController 里面的cell
  @param identifier StoryBoard ->ViewController->UITableViewCell的标记（identifier）
  @param index 取cell里面的第几个  可能cell里面有不同的样式
  @return 返回 cell
  */


+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier index:(NSInteger) index;



//自己实现
//- (UIBaseStoryBoardTableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;



@end
