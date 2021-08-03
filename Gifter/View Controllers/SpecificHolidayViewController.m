//
//  SpecificHolidayViewController.m
//  Gifter
//
//  Created by samanthaburak on 8/3/21.
//

#import "SpecificHolidayViewController.h"
#import "SceneDelegate.h"
#import "HolidaysViewController.h"
#import "SpecificHolidayRecipientCell.h"
#import "Person.h"

@interface SpecificHolidayViewController () <UITableViewDataSource, UITableViewDelegate>

// @property (nonatomic) NSMutableDictionary *recipientBasketDictionary;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation SpecificHolidayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.holiday.name;
    // self.recipientBasketDictionary = self.holiday.dictionary;
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    [self loadData];
    [self.mainTableView reloadData];
}

- (void)loadData {
    
}

- (IBAction)didTapBackButton:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UITabBarController *tabBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeTabBarViewController"];
    tabBarViewController.selectedIndex = 1;
    sceneDelegate.window.rootViewController = (HolidaysViewController*) tabBarViewController;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SpecificHolidayRecipientCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:@"SpecificHolidayRecipientCell"];
    NSArray *recipientNamesArray = self.holiday.dictionary.allKeys;
    NSString *personName = recipientNamesArray[indexPath.row];
    cell.personName = personName;
    return cell;
    
    /*
    PFQuery *query = [PFQuery queryWithClassName:@"Person"];
    [query whereKey:@"name" equalTo:personName];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
      if (!object) {
        NSLog(@"The getFirstObject request to get Person with specific name failed.");
      } else {
        NSLog(@"Successfully retrieved person.");
          cell.person = (Person*)object;
          return cell;
      }
    }];
     */
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.holiday.dictionary.count;
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
