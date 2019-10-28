//
//  UITableViewCell+StoryBoard.m
//  MaoBuTou
//
//  Created by 心冷如灰 on 2017/9/21.
//  Copyright © 2017年 心冷如灰. All rights reserved.
//

#import "UITableViewCell+StoryBoard.h"

@implementation UITableViewCell (StoryBoard)

- (instancetype)storyBoardCellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier index:(NSInteger) index {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][index];
}

@end
