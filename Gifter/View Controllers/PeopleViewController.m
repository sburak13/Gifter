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

@interface PeopleViewController ()

@end

@implementation PeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
