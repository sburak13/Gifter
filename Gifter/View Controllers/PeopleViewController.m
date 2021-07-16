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

@interface PeopleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSMutableArray *peopleArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation PeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.peopleTableView.dataSource = self;
    self.peopleTableView.delegate = self;
    
    [self loadPeople];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadPeople) forControlEvents:UIControlEventValueChanged];
    [self.peopleTableView insertSubview:self.refreshControl atIndex: 0];
}

- (void)loadPeople {
    // construct PFQuery
    PFQuery *personQuery = [Person query];
    [personQuery orderByDescending:@"createdAt"];
    personQuery.limit = 20;

    // fetch data asynchronously
    [personQuery findObjectsInBackgroundWithBlock:^(NSArray<Person *> * _Nullable people, NSError * _Nullable error) {
        if (people) {
            // do something with the data fetched
            self.peopleArray = people;
            [self.peopleTableView reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            // handle error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
        // Create NSURL and NSURLRequest
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                              delegate:nil
                                                         delegateQueue:[NSOperationQueue mainQueue]];
        session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
        NSURLSessionDataTask *task = [session dataTaskWithRequest:self.peopleArray
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
           // ... Use the new data to update the data source ...

           // Reload the tableView now that there is new data
            [self.peopleTableView reloadData];

           // Tell the refreshControl to stop spinning
            [refreshControl endRefreshing];

        }];
    
        [task resume];
}



- (IBAction)didTapLogout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // Remember to set the Storyboard ID to LoginViewController
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        
        if (error){
            NSLog(@"Error when logging out");
        } else {
            NSLog(@"Logout succeeded");
        }
        
        // If above didn't work, add: [[UIApplication sharedApplication].keyWindow setRootViewController: loginViewController];
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
        // person = tappedCell.person;
        NSLog(@"person's name %@", person.name);
        
        //ProductStreamViewController *productStreamViewController = [segue destinationViewController];
        
        // UINavigationController *streamNC = self.tabBarController.viewControllers.firstObject;
        // productStreamViewController = (ProductStreamViewController *)streamNC.viewControllers.firstObject;
        // productStreamViewController.person = person;
        
        
        
        /*Get a pointer to the selected row*/
            // NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

        UINavigationController *navController = segue.destinationViewController;

            /*Get a pointer to the ViewController we will segue to*/
        ProductStreamViewController *productStreamViewController = navController.topViewController;
        productStreamViewController.person = person;

    }
}


@end
