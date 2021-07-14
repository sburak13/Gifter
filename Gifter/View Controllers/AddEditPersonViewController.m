//
//  AddEditPersonViewController.m
//  Gifter
//
//  Created by samanthaburak on 7/13/21.
//

#import "AddEditPersonViewController.h"
#import "SceneDelegate.h"
#import "PeopleViewController.h"
#import "Person.h"
#import "InterestCell.h"

@interface AddEditPersonViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITableView *interestsTableView;
@property (nonatomic) NSMutableArray *interestsArray;

@end

@implementation AddEditPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.interestsTableView.dataSource = self;
    self.interestsTableView.delegate = self;
}

- (void)goToFriendsScreen {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // Remember to set the Storyboard ID to LoginViewController
    PeopleViewController *peopleViewController = [storyboard instantiateViewControllerWithIdentifier:@"PeopleNavViewController"];
    sceneDelegate.window.rootViewController = peopleViewController;
}

- (IBAction)didTapBackButton:(id)sender {
    [self goToFriendsScreen];
}

- (IBAction)didTapDone:(id)sender {
    
    
    [Person createPerson:self.nameTextField.text withInterests:NULL withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        
        if (succeeded) {
            NSLog(@"Succesfully created person");
            [self goToFriendsScreen];
            
        } else {
            UIAlertController *createPersonAlert = [UIAlertController alertControllerWithTitle:@"Could Not Create Person"
                                                                               message: [@"Error: " stringByAppendingString:error.localizedDescription]
                                                           preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {}];
            [createPersonAlert addAction:okAction];
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    InterestCell *cell = [self.interestsTableView dequeueReusableCellWithIdentifier:@"InterestCell"];
    NSString *interest = self.interestsArray[indexPath.row];
    cell.interestTextField.text = interest;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
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
