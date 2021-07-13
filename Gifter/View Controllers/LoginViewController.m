//
//  LoginViewController.m
//  Gifter
//
//  Created by samanthaburak on 7/13/21.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property UIAlertController *loginAlert;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameTextField.placeholder = @"Username";
    self.passwordTextField.placeholder = @"Password";
    
    self.loginAlert = [UIAlertController alertControllerWithTitle:@"Invalid Login"
                                                          message:@"message"
                                                   preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {}];
    [self.loginAlert addAction:okAction];
}

- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
}

- (void)loginUser {
    self.loginAlert.title = @"Invalid Login";
    
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            
            self.loginAlert.message = [@"Error: " stringByAppendingString:error.localizedDescription];
            [self presentViewController:self.loginAlert animated:YES completion:^{}];
        } else {
            NSLog(@"User logged in successfully");
            
            // display view controller that needs to shown after successful login
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}


- (IBAction)didTapSignUp:(id)sender {
    [self performSegueWithIdentifier:@"registerSegue" sender:nil];
}

// Test the function below on phone
- (IBAction)didTapView:(id)sender {
    [self.view endEditing:true];
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
