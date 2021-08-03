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
                                                     handler:nil];
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
            [self presentViewController:self.peopleAlert animated:YES completion:nil];
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
            [self presentViewController:self.logoutAlert animated:YES completion:nil];
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

- (id)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getRowActions:tableView indexPath:indexPath];
}

- (id)getRowActions:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    UIContextualAction *delete = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
                                                                         title:@"Delete"
                                                                       handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSLog(@"Delete");
        PFObject *person = self.peopleArray[indexPath.row];
        [person deleteInBackground];
        [self.peopleArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                           }];
    delete.backgroundColor = [UIColor redColor];
    UISwipeActionsConfiguration *swipeActionConfig = [UISwipeActionsConfiguration configurationWithActions:@[delete]];
    swipeActionConfig.performsFirstActionWithFullSwipe = NO;
    return swipeActionConfig;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"streamSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.peopleTableView indexPathForCell:tappedCell];
        Person *person = self.peopleArray[indexPath.row];
        NSLog(@"person's name %@", person.name);
        UINavigationController *navController = segue.destinationViewController;
        GiftBasketsViewController *giftBasketsViewController = navController.topViewController;
        giftBasketsViewController.person = person;
    }
}


@end
