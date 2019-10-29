//
//  UIBaseStoryBoardTableViewCell.m
//  MaoBuTou
//
//  Created by 心冷如灰 on 2017/9/21.
//  Copyright © 2017年 心冷如灰. All rights reserved.
//

#import "UIBaseStoryBoardTableViewCell.h"

@implementation UIBaseStoryBoardTableViewCell




+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier {
    return [self cellWithTableView:tableView identifier:identifier index:0];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier index:(NSInteger) index {
    
    UIBaseStoryBoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [cell storyBoardCellWithTableView:tableView identifier:identifier index:index];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


//- (UIBaseStoryBoardTableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//     return [self.viewController.mainTableView cellForRowAtIndexPath:indexPath];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
