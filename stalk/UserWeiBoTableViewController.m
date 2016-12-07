//
//  UserWeiBoTableViewController.m
//  stalk
//
//  Created by Coding on 12/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "UserWeiBoTableViewController.h"
#import "WBStatusCell.h"
#import "StatusDataSource.h"
#import "SendStatusViewController.h"
#import "WBStatusCellDelegateIMP.h"


@interface UserWeiBoTableViewController ()
@property (nonatomic, strong) StatusDataSource *dataSource;
@property (nonatomic, strong) WBStatusCellDelegateIMP *cellDelegate;
@end

@implementation UserWeiBoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cellDelegate = [WBStatusCellDelegateIMP new];
    _cellDelegate.controller = self;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.delegate = self;
    _dataSource = [[StatusDataSource alloc]initWithCellIdentifer:@"MyStatusesCellID" block:^(id cell, id statusLayout) {
        WBStatusCell *wbcell = (WBStatusCell *)cell;
        wbcell.layout = (WBStatusLayout *) statusLayout;
        wbcell.delegate = _cellDelegate;
    }];
    self.tableView.dataSource = _dataSource;
    [self setRefresh];
    
    self.navigationController.view.userInteractionEnabled = NO;
    UIActivityIndicatorView *indicator = [self activityIndicatorView];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    [self.dataSource loadMyStatusWithCompletion:^(void) {
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

- (void)setRefresh{
    UIRefreshControl *rc = [ [UIRefreshControl alloc] init];
    [rc addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = rc;
}

- (void)refreshData{
    if(self.refreshControl.isRefreshing){
        [_dataSource updateMyStatusesWithCompletion:^{
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }];
    }
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [_dataSource cellHeightAtIndex:indexPath.row];
}

- (IBAction)sendStatus:(UIBarButtonItem *)sender {
    SendStatusViewController *sendController = [SendStatusViewController new];
    sendController.messageType = SendMessageTypeStatus;
    [self.navigationController pushViewController:sendController animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


//#pragma mark - Navigation
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    [segue destinationViewController].
//}


@end
