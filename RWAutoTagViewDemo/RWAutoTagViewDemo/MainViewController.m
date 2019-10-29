//
//  MainViewController.m
//  RWAutoTagViewDemo
//
//  Created by linmao on 2019/10/28.
//  Copyright © 2019 曾云. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import "MainSectionView.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark  -  TableViewDelegate  -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    switch (section) {
        case 0:
            count = 2;
            break;
            
        case 1:
            count = 2;
            break;
            
        case 2:
            count = 1;
            break;
            
        default:
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MainTableViewCell *cell = [MainTableViewCell cellWithTableView:tableView identifier:@"Identifier_Main"];
    NSString *title = @"RWAutoTag介绍";
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 1:
                    title = @"使用代码创建";
                    break;
                    
                default:
                    title = @"Storyboard、Xib创建";
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 1:
                    title = @"使用代码创建";
                    break;
                    
                default:
                    title = @"Storyboard、Xib创建";
                    break;
            }
            break;
            
        default:
            break;
    }
    cell.title.text = title;
    return cell;;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MainSectionView *header = [MainSectionView initViewWithXibIndex:0];
    switch (section) {
        case 0:
            header.title.text = @"RWAutoTagView";
            break;
            
        case 1:
            header.title.text = @"RWAutoTagButton";
            break;
            
        case 2:
            header.title.text = @"RWAutoTag 类似Model";
            break;
            
        default:
            break;
    }
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  return [[UIView alloc]initWithFrame:CGRectZero];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"%ld",(long)indexPath.row);
    NSString *identifier = @"";
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 1:
                    identifier = @"RWAutoTagViewPureCode";
                    break;
                default:
                    identifier = @"RWAutoTagView";
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 1:
                    identifier = @"RWAutoTagButtonPureCode";
                    break;
                default:
                    identifier = @"RWAutoTagButton";
                    break;
            }
            break;
            
        default:
            break;
    }
    
    if (identifier.length) {
        UIViewController *viewController =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
        [self.navigationController pushViewController:viewController animated:YES];
    }
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
