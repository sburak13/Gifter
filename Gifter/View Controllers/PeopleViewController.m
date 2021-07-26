//
//  PeopleViewController.m
//  Gifter
//
//  Created by samanthaburak on 7/13/21.
//

#import "PeopleViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "PersonCell.h"
#import "ProductStreamViewController.h"
#import "GiftBasketsViewController.h"

@interface PeopleViewController () <UITableViewDataSource, UITableViewDelegate>

@property UIAlertController *peopleAlert;
@property UIAlertController *logoutAlert;
@property (nonatomic) NSMutableArray *peopleArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation PeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.peopleAlert = [UIAlertController alertControllerWithTitle:@"People Screen Error"
                                                          message:@"message"
                                                   preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {}];
    [self.peopleAlert addAction:okAction];
    
    self.logoutAlert = [UIAlertController alertControllerWithTitle:@"Invalid Logout"
                                                          message:@"message"
                                                   preferredStyle:(UIAlertControllerStyleAlert)];

    [self.logoutAlert addAction:okAction];
    
    self.peopleTableView.dataSource = self;
    self.peopleTableView.delegate = self;
    
    [self loadPeople];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadPeople) forControlEvents:UIControlEventValueChanged];
    [self.peopleTableView insertSubview:self.refreshControl atIndex: 0];
}

- (void)loadPeople {
    PFQuery *personQuery = [Person query];
    [personQuery orderByDescending:@"createdAt"];
    personQuery.limit = 20;

    [personQuery findObjectsInBackgroundWithBlock:^(NSArray<Person *> * _Nullable people, NSError * _Nullable error) {
        if (people) {
            self.peopleArray = people;
            [self.peopleTableView reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            NSLog(@"Error getting people%@", error.localizedDescription);
            
            self.peopleAlert.message = [@"Error: " stringByAppendingString:error.localizedDescription];
        }
    }];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                              delegate:nil
                                                         delegateQueue:[NSOperationQueue mainQueue]];
        session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
        NSURLSessionDataTask *task = [session dataTaskWithRequest:self.peopleArray
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
            [self.peopleTableView reloadData];

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
            
            self.logoutAlert.message = [@"User log out error: " stringByAppendingString:error.localizedDescription];
        } else {
            NSLog(@"Logout succeeded");
        }

    }];
}

- (IBAction)didTapAdd:(id)sender {
    [self performSegueWithIdentifier:@"addEditSegue" sender:nil];
}

- (IBAction)didTapEdit:(id)sender {
    [self performSegueWithIdentifier:@"addEditSegue" sender:nil];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PersonCell *cell = [self.peopleTableView dequeueReusableCellWithIdentifier:@"PersonCell"];
    Person *person = self.peopleArray[indexPath.row];
    cell.person = person;
    NSLog(@"%@", cell.person.name);
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.peopleArray.count;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"streamSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.peopleTableView indexPathForCell:tappedCell];
        Person *person = self.peopleArray[indexPath.row];
        NSLog(@"person's name %@", person.name);
        UINavigationController *navController = segue.destinationViewController;
        GiftBasketsViewController *giftBasketsViewController = navController.topViewController;
        giftBasketsViewController.person = person;
        
        /*
        UITabBarController *tabBarController = segue.destinationViewController;
        UINavigationController *navController = tabBarController.viewControllers.firstObject;
        ProductStreamViewController *productStreamViewController = navController.topViewController;
        productStreamViewController.person = person;
        */
        
        /*
        UINavigationController *navController2 = tabBarController.viewControllers.lastObject;
        GiftBasketsViewController *giftBasketsViewController = navController2.topViewController;
        giftBasketsViewController.person = person;
        */
        
        /* Nav Controller Code
        UINavigationController *navController = segue.destinationViewController;
        ProductStreamViewController *productStreamViewController = navController.topViewController;
        productStreamViewController.person = person;
        */
    }
}


@end
