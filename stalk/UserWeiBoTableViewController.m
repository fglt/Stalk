//
//  UserWeiBoTableViewController.m
//  stalk
//
//  Created by Coding on 12/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "UserWeiBoTableViewController.h"
#import "FGLTUser.h"
#import "FGLTStatus.h"
#import "AppDelegate.h"
#import "WBStatusCell.h"
#import "WBHttpRequest+STalk.h"
#import "WBRequestQueue.h"

@interface UserWeiBoTableViewController ()
@property (nonatomic, strong) NSArray *statuesList;
@end

@implementation UserWeiBoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [WBHttpRequest requestForStatusesOfPath:@"user_timeline" withAccessToken:appDelegate.wbAuthorizeResponse.accessToken andOtherProperties:nil queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        NSDictionary *dict = [result objectForKey:@"statuses"];
        
        self.statuesList = [WBStatusLayout statusLayoutsWithStatuses:[FGLTStatus statuesWithDict:dict]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
//    for(WBStatusLayout *layout in self.statuesList){
//        [layout resetFrame];
//    }
//    [self.tableView reloadData];
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.statuesList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WBStatusCell * cell = [[WBStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ALLStatusesCellID"];
    cell.layout = _statuesList[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WBStatusLayout *info = _statuesList[indexPath.row];
    return info.cellHeight;
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
