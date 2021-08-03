//
//  HolidaysViewController.m
//  Gifter
//
//  Created by samanthaburak on 8/2/21.
//

#import "HolidaysViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "HolidayCell.h"
#import "SpecificHolidayViewController.h"

@interface HolidaysViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSMutableArray *holidaysArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;


@end

@implementation HolidaysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.holidaysTableView.dataSource = self;
    self.holidaysTableView.delegate = self;
    
    [self loadHolidays];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadHolidays) forControlEvents:UIControlEventValueChanged];
    [self.holidaysTableView insertSubview:self.refreshControl atIndex: 0];
}

- (void)loadHolidays {
    PFQuery *holidayQuery = [Holiday query];
    [holidayQuery orderByDescending:@"createdAt"];
    holidayQuery.limit = 20;

    [holidayQuery findObjectsInBackgroundWithBlock:^(NSArray<Holiday *> * _Nullable holidays, NSError * _Nullable error) {
        if (holidays) {
            self.holidaysArray = (NSMutableArray*)holidays;
            
            /*
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                       ascending:YES];
            self.holidaysArray = (NSMutableArray*)[self.holidaysArray sortedArrayUsingDescriptors:@[sortDescriptor]];
            */
            
            [self.holidaysTableView reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            NSLog(@"Error getting holidayse%@", error.localizedDescription);
        }
    }];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                              delegate:nil
                                                         delegateQueue:[NSOperationQueue mainQueue]];
        session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
        NSURLSessionDataTask *task = [session dataTaskWithRequest:self.holidaysArray
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
            [self.holidaysTableView reloadData];

            [refreshControl endRefreshing];

        }];
    
        [task resume];
}

- (IBAction)didTapLogout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error){
            NSLog(@"User log out failed: %@", error.localizedDescription);
        } else {
            NSLog(@"Logout succeeded");
        }
    }];
}

- (IBAction)didTapAdd:(id)sender {
    [self performSegueWithIdentifier:@"addHolidaySegue" sender:nil];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HolidayCell *cell = [self.holidaysTableView dequeueReusableCellWithIdentifier:@"HolidayCell"];
    Holiday *holiday = self.holidaysArray[indexPath.row];
    cell.holiday = holiday;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.holidaysArray.count;
}

- (id)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
   return [self getRowActions:tableView indexPath:indexPath];
}

- (id)getRowActions:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
   UIContextualAction *delete = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
                                                                        title:@"Delete"
                                                                      handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
       NSLog(@"Delete Holiday");
       PFObject *holiday = self.holidaysArray[indexPath.row];
       [holiday deleteInBackground];
       
       [self.holidaysArray removeObjectAtIndex:indexPath.row];
       [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                          }];
   delete.backgroundColor = [UIColor redColor];
   UISwipeActionsConfiguration *swipeActionConfig = [UISwipeActionsConfiguration configurationWithActions:@[delete]];
   swipeActionConfig.performsFirstActionWithFullSwipe = NO;
   return swipeActionConfig;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"holidaySegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.holidaysTableView indexPathForCell:tappedCell];
        Holiday *holiday = self.holidaysArray[indexPath.row];
        UINavigationController *navController = segue.destinationViewController;
        SpecificHolidayViewController *specificHolidayViewController = navController.topViewController;
        specificHolidayViewController.holiday = holiday;
    }
}


@end
