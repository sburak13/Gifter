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
@property (weak, nonatomic) IBOutlet UITextField *addInterestTextField;
@property (weak, nonatomic) IBOutlet UITextField *budgetTextField;
@property (nonatomic) NSMutableArray *peopleArray;

@end

@implementation AddEditPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadPeople];

    self.interestsTableView.dataSource = self;
    self.interestsTableView.delegate = self;
    
    self.interestsArray = [NSMutableArray array];
}

- (void)goToPeopleScreen {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    PeopleViewController *peopleViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeTabBarViewController"];
    sceneDelegate.window.rootViewController = peopleViewController;
}

- (IBAction)didTapBackButton:(id)sender {
    [self goToPeopleScreen];
}

- (IBAction)tapView:(id)sender {
    [self.view endEditing:true];
}

- (IBAction)didTapDone:(id)sender {
    if ([self didFillOutAllFields]) {
        if ([self nameFieldIsUnique:self.nameTextField.text]) {
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *budgetNum;
            if ([self checkNumeric:self.budgetTextField.text]) {
                budgetNum = [f numberFromString:self.budgetTextField.text];
                __weak AddEditPersonViewController *weakSelf = self;
                [Person createPerson:self.nameTextField.text withInterests:self.interestsArray withBudget:budgetNum withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                    AddEditPersonViewController *strongSelf = weakSelf;
                    if (!strongSelf) {
                        return;
                    }
                    if (succeeded) {
                        NSLog(@"Succesfully created person");
                        [strongSelf goToPeopleScreen];
                    } else {
                        UIAlertController *createPersonAlert = [UIAlertController alertControllerWithTitle:@"Could Not Create Person"
                                                                                                   message: [@"Error: " stringByAppendingString:error.localizedDescription]
                                                                                            preferredStyle:(UIAlertControllerStyleAlert)];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                           style:UIAlertActionStyleDefault
                                                                         handler:nil];
                        [createPersonAlert addAction:okAction];
                        [self presentViewController:createPersonAlert animated:YES completion:nil];
                        
                    }
                }];
            } else {
                UIAlertController *nonnumericBudgetAlert = [UIAlertController alertControllerWithTitle:@"Budget Not Numeric"
                                                                                           message:@"Please try again"
                                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil];
                [nonnumericBudgetAlert addAction:okAction];
                [self presentViewController:nonnumericBudgetAlert animated:YES completion:nil];
            }
        } else {
            UIAlertController *nonuniqueNameAlert = [UIAlertController alertControllerWithTitle:@"Person Name Not Unique"
                                                                                       message:@"Please try again"
                                                                                preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [nonuniqueNameAlert addAction:okAction];
            [self presentViewController:nonuniqueNameAlert animated:YES completion:nil];
        }
    } else {
        UIAlertController *missingInfoAlert = [UIAlertController alertControllerWithTitle:@"Could Not Add Person"
                                                                                  message: @"Please make sure to fill out all fields"
                                                                            preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [missingInfoAlert addAction:okAction];
        [self presentViewController:missingInfoAlert animated:YES completion:nil];
    }
}

- (void)loadPeople {
    PFQuery *personQuery = [PFQuery queryWithClassName:@"Person"];
    [personQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [personQuery orderByDescending:@"createdAt"];
    // personQuery.limit = 20;

    [personQuery findObjectsInBackgroundWithBlock:^(NSArray<Person *> * _Nullable people, NSError * _Nullable error) {
        if (people) {
            self.peopleArray = people;
        }
        else {
            NSLog(@"Error getting people%@", error.localizedDescription);
        }
    }];
}

- (BOOL)nameFieldIsUnique:(NSString*)name {
    for (Person* person in self.peopleArray) {
        if ([person.name isEqualToString:name]) {
            return false;
        }
    }
    return true;
}

- (BOOL)checkNumeric:(NSString*)val {
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [val rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound && val.length > 0;
}

- (BOOL)didFillOutAllFields {
    if (self.nameTextField.text.length == 0) {
        return false;
    }
    if (self.interestsArray.count == 0) {
        return false;
    }
    if (self.budgetTextField.text.length == 0) {
        return false;
    }
    return true;
}

- (IBAction)didTapAddInterest:(id)sender {
    UIAlertController *addInterestAlert = [UIAlertController alertControllerWithTitle:@"Add Interest Error"
                                                                              message: @"Error"
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    NSString *interest = self.addInterestTextField.text;
    
    int maxInterests = 6;
    if (self.interestsArray.count < maxInterests && ![interest isEqualToString:@""]) {
        [self.interestsArray insertObject:interest atIndex:0];
        self.addInterestTextField.text = @"";
        [self.interestsTableView reloadData];
        
    } else if ([interest isEqualToString:@""]) {
        addInterestAlert.message = @"Can't add empty interest";
        [addInterestAlert addAction:okAction];
        [self presentViewController:addInterestAlert animated:YES completion:nil];
        
    } else if (self.interestsArray.count >= maxInterests) {
        addInterestAlert.message = [NSString stringWithFormat:@"Can't add more than %d interests", maxInterests];
        [addInterestAlert addAction:okAction];
        [self presentViewController:addInterestAlert animated:YES completion:nil];
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    InterestCell *cell = [self.interestsTableView dequeueReusableCellWithIdentifier:@"InterestCell"];
    NSString *interest = self.interestsArray[indexPath.row];
    cell.interestLabel.text = interest;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.interestsArray.count;
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
