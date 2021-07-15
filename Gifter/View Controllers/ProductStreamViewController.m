//
//  ProductStreamViewController.m
//  Gifter
//
//  Created by samanthaburak on 7/13/21.
//

#import "ProductStreamViewController.h"
#import "SceneDelegate.h"
#import "PeopleViewController.h"
#import "APIManager.h"

@interface ProductStreamViewController ()

@property (weak, nonatomic) IBOutlet UITableView *giftTableView;

@end

@implementation ProductStreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    APIManager *api = [APIManager shared];
    
    [api getSearchResultsFor:@"Jeans" completion:^(NSDictionary *data, NSError *error) {
        if(error){
            NSLog(@"Error getting search results: %@", error.localizedDescription);
        }
        
        else{
            NSLog(@"Search data: %@", data);
        }
    }];
}

- (IBAction)didTapBackButton:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // Remember to set the Storyboard ID to LoginViewController
    PeopleViewController *peopleViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeTabBarViewController"];
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
