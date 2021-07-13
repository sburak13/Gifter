//
//  AddEditPersonViewController.m
//  Gifter
//
//  Created by samanthaburak on 7/13/21.
//

#import "AddEditPersonViewController.h"
#import "SceneDelegate.h"
#import "PeopleViewController.h"

@interface AddEditPersonViewController ()

@end

@implementation AddEditPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTapBackButton:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // Remember to set the Storyboard ID to LoginViewController
    PeopleViewController *peopleViewController = [storyboard instantiateViewControllerWithIdentifier:@"PeopleNavViewController"];
    sceneDelegate.window.rootViewController = peopleViewController;
}

@end
