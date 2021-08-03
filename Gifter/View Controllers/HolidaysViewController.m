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

@interface HolidaysViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSMutableArray *holidaysArray;

@end

@implementation HolidaysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.holidaysTableView.dataSource = self;
    self.holidaysTableView.delegate = self;
    
    [self loadHolidays];
}

- (void)loadHolidays {
    PFQuery *holidayQuery = [Holiday query];
    [holidayQuery orderByDescending:@"createdAt"];
    holidayQuery.limit = 20;

    [holidayQuery findObjectsInBackgroundWithBlock:^(NSArray<Holiday *> * _Nullable holidays, NSError * _Nullable error) {
        if (holidays) {
            self.holidaysArray = holidays;
            [self.holidaysTableView reloadData];
        }
        else {
            NSLog(@"Error getting holidayse%@", error.localizedDescription);
        }
    }];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
