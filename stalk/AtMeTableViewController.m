//
//  atMeTableViewController.m
//  stalk
//
//  Created by Coding on 28/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "AtMeTableViewController.h"
#import "WBStatusCellDelegateIMP.h"

@interface AtMeTableViewController ()
@property (nonatomic, strong) StatusDataSource *dataSource;
@property (nonatomic, strong) WBStatusCellDelegateIMP *cellDelegate;
@end

@implementation AtMeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellDelegate = [WBStatusCellDelegateIMP new];
    _cellDelegate.controller = self;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.delegate = self;
    self.tableView.tableFooterView = UIView.new;
    [self.tableView registerClass:[WBStatusCell class] forCellReuseIdentifier:@"AtMeStatusesCellID"];
    _dataSource = [[StatusDataSource alloc]initWithCellIdentifer:@"AtMeStatusesCellID" block:^(id cell, id statusLayout) {
        WBStatusCell *wbcell = (WBStatusCell *)cell;
        wbcell.layout = (WBStatusLayout *) statusLayout;
        wbcell.delegate = _cellDelegate;
    }];
    self.tableView.dataSource = _dataSource;

    self.navigationController.view.userInteractionEnabled = NO;
    UIActivityIndicatorView *indicator = [self activityIndicatorView];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    [self.dataSource loadAtMeStatusWithCompletion:^(void) {
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
    
    return [_dataSource objectAtIndex :indexPath.row].height + CellPadding;
}


@end
