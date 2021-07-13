//
//  ProductStreamViewController.m
//  Gifter
//
//  Created by samanthaburak on 7/13/21.
//

#import "ProductStreamViewController.h"
#import "SceneDelegate.h"
#import "PeopleViewController.h"

@interface ProductStreamViewController ()

@end

@implementation ProductStreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapBackButton:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // Remember to set the Storyboard ID to LoginViewController
    PeopleViewController *peopleViewController = [storyboard instantiateViewControllerWithIdentifier:@"PeopleNavViewController"];
    sceneDelegate.window.rootViewController = peopleViewController;
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
