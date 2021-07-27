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
                                                     handler:nil];
    [self.loginAlert addAction:okAction];
    
}

- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
}

- (IBAction)tapView:(id)sender {
    NSLog(@"hello");
    [self.view endEditing:true];
}

- (void)loginUser {
    self.loginAlert.title = @"Invalid Login";
    
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            
            self.loginAlert.message = [@"User log in error: " stringByAppendingString:error.localizedDescription];
            [self presentViewController:self.loginAlert animated:YES completion:^{}];
        } else {
            NSLog(@"User logged in successfully");
            
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}


- (IBAction)didTapSignUp:(id)sender {
    [self performSegueWithIdentifier:@"registerSegue" sender:nil];
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
