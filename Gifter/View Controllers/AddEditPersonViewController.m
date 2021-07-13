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

@interface AddEditPersonViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation AddEditPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
