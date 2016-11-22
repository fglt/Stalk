//
//  TopicControllerViewController.m
//  stalk
//
//  Created by Coding on 22/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//


#import "TopicController.h"
#import "StatusDataSource.h"
#import "WBStatusCell.h"

@interface TopicController ()<WBStatusCellDelegate>
@property (nonatomic, strong) StatusDataSource *dataSource;
@end

@implementation TopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = self.topic;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.delegate = self;
    _dataSource = [[StatusDataSource alloc]initWithCellIdentifer:@"TopicStatusesCellID" block:^(id cell, id statusLayout) {
        WBStatusCell *wbcell = (WBStatusCell *)cell;
        wbcell.layout = (WBStatusLayout *) statusLayout;
        wbcell.delegate = self;
    }];
    self.tableView.dataSource = _dataSource;
    self.navigationController.view.userInteractionEnabled = NO;
    UIActivityIndicatorView *indicator = [self activityIndicatorView];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    [self.dataSource loadDataAboutTopic:self.topic completionHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator removeFromSuperview];
            self.navigationController.view.userInteractionEnabled = YES;
            [self.tableView reloadData];
        });
    }];
}

- (UIActivityIndicatorView *)activityIndicatorView{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.size = CGSizeMake(50, 50);
    indicator.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    indicator.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.670];
    indicator.clipsToBounds = YES;
    
    indicator.layer.cornerRadius = 6;
    return indicator;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [_dataSource objectAtIndex:indexPath.row].height;
}
@end
