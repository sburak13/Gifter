//
//  AddHolidayViewController.m
//  Gifter
//
//  Created by samanthaburak on 8/3/21.
//

#import "AddHolidayViewController.h"
#import <CCDropDownMenus/CCDropDownMenus.h>
#import <Parse/Parse.h>
#import "Person.h"
#import "SceneDelegate.h"
#import "HolidaysViewController.h"
#import "RecipientCell.h"
#import "Holiday.h"

@interface AddHolidayViewController () <UITableViewDataSource, UITableViewDelegate, CCDropDownMenuDelegate>

@property (nonatomic) NSArray *peopleArray;
@property (nonatomic) ManaDropDownMenu *menu;
@property (nonatomic) int currentlySelectedPersonIndex;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITableView *recipientsTableView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic) NSMutableArray *recipientsArray;

@end

@implementation AddHolidayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menu = [[ManaDropDownMenu alloc] initWithFrame:CGRectMake(self.placeholderMenuView.frame.origin.x, self.placeholderMenuView.frame.origin.y, self.placeholderMenuView.frame.size.width, self.placeholderMenuView.frame.size.height) title:@"Select"];
    self.menu.delegate = self;
    self.menu.activeColor = [UIColor systemBlueColor];
    
    [self getPeople];
    
    self.recipientsTableView.dataSource = self;
    self.recipientsTableView.delegate = self;
    
    self.recipientsArray = [NSMutableArray array];
}

- (void)getPeople {
    PFQuery *personQuery = [Person query];
    [personQuery orderByDescending:@"createdAt"];
    personQuery.limit = 20;

    [personQuery findObjectsInBackgroundWithBlock:^(NSArray<Person *> * _Nullable people, NSError * _Nullable error) {
        if (people) {
            self.peopleArray = people;
            self.menu.numberOfRows = people.count;
            self.menu.textOfRows = [self getArrayOfNames:people];
            [self.view addSubview:self.menu];
        }
        else {
            NSLog(@"Error getting people%@", error.localizedDescription);
        }
    }];
}

-(NSArray*)getArrayOfNames:(NSArray*)people{
    NSMutableArray* names = [NSMutableArray array];
    for (Person* person in people) {
        [names addObject:person.name];
    }
    return names;
}

- (void)dropDownMenu:(CCDropDownMenu *)dropDownMenu didSelectRowAtIndex:(NSInteger)index {
    self.currentlySelectedPersonIndex = index;
}

- (void)goToHolidaysScreen {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UITabBarController *tabBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeTabBarViewController"];
    tabBarViewController.selectedIndex = 1;
    sceneDelegate.window.rootViewController = (HolidaysViewController*) tabBarViewController;
}

- (IBAction)didTapBackButton:(id)sender {
    [self goToHolidaysScreen];
}

- (Person*)getPersonWithName:(NSString*)name {
    for (Person* person in self.peopleArray) {
        if ([person.name isEqualToString:name]) {
            return person;
        }
    }
    return nil;
}

- (NSArray*)getRecipientsObjectArray {
    NSMutableArray *array = [NSMutableArray array];
    for (NSString* name in self.recipientsArray) {
        Person *person = [self getPersonWithName:name];
        [array addObject:person];
    }
    return array;
}

- (IBAction)didTapDone:(id)sender {
    if ([self didFillOutAllFields]) {
        __weak AddHolidayViewController *weakSelf = self;
        [Holiday createHoliday:self.nameTextField.text withRecipients:[self getRecipientsObjectArray] withRecipientNames:self.recipientsArray withDate:[self.datePicker date] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            AddHolidayViewController *strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            }
            if (succeeded) {
                NSLog(@"Succesfully created holiday");
                [strongSelf goToHolidaysScreen];
            } else {
                UIAlertController *createHolidayAlert = [UIAlertController alertControllerWithTitle:@"Could Not Create Holiday"
                                                                                           message: [@"Error: " stringByAppendingString:error.localizedDescription]
                                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil];
                [createHolidayAlert addAction:okAction];
                [self presentViewController:createHolidayAlert animated:YES completion:nil];
                
            }
        }];
    } else {
        UIAlertController *missingInfoAlert = [UIAlertController alertControllerWithTitle:@"Could Not Add Holiday"
                                                                                  message: @"Please make sure to fill out all fields"
                                                                            preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [missingInfoAlert addAction:okAction];
        [self presentViewController:missingInfoAlert animated:YES completion:nil];
    }
}

- (BOOL)didFillOutAllFields {
    if (self.nameTextField.text.length == 0) {
        return false;
    }
    
    if (self.recipientsArray.count == 0) {
        return false;
    }
    if ([self.datePicker.date isEqual:nil]) {
        return false;
    }
    return true;
}

- (IBAction)didTapAddRecipient:(id)sender {
    UIAlertController *addRecipientAlert = [UIAlertController alertControllerWithTitle:@"Add Recipient Error"
                                                                              message: @"Error"
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    NSString *recipientName = self.menu.textOfRows[self.currentlySelectedPersonIndex];;
    
    if (self.recipientsArray.count < 3 && ![recipientName isEqualToString:@""] && ![self.recipientsArray containsObject:recipientName]) {
        [self.recipientsArray insertObject:recipientName atIndex:0];
        // self.addInterestTextField.text = @"";
        [self.recipientsTableView reloadData];
        
    } else if ([recipientName isEqualToString:@""]) {
        addRecipientAlert.message = @"Can't add empty recipient";
        [addRecipientAlert addAction:okAction];
        [self presentViewController:addRecipientAlert animated:YES completion:nil];
        
    } else if (self.recipientsArray.count >= 3) {
        addRecipientAlert.message = @"Can't add more than 3 recipients";
        [addRecipientAlert addAction:okAction];
        [self presentViewController:addRecipientAlert animated:YES completion:nil];
        
    } else if ([self.recipientsArray containsObject:recipientName]) {
        addRecipientAlert.message = @"Can't add the same recipient";
        [addRecipientAlert addAction:okAction];
        [self presentViewController:addRecipientAlert animated:YES completion:nil];
    }
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RecipientCell *cell = [self.recipientsTableView dequeueReusableCellWithIdentifier:@"RecipientCell"];
    NSString *recipient = self.recipientsArray[indexPath.row];
    cell.recipientLabel.text = recipient;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recipientsArray.count;
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
