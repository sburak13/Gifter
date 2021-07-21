//
//  GiftBasketsViewController.m
//  Gifter
//
//  Created by samanthaburak on 7/20/21.
//

#import "GiftBasketsViewController.h"
#import "SceneDelegate.h"
#import "PeopleViewController.h"
#import "ProductStreamViewController.h"
#import "GiftBasket.h"

@interface GiftBasketsViewController ()

@property (strong, nonatomic) NSMutableArray *arrayOfGiftBaskets;
@property (nonatomic) int *numItemsInBasket;

@end

@implementation GiftBasketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // ProductStreamViewController *productStreamViewController =[[ProductStreamViewController alloc] init];
    // NSMutableArray *allGifts = productStreamViewController.arrayOfGifts;
    self.numItemsInBasket = 2;
    self.arrayOfGifts = self.person.giftSuggestions;
    NSLog(@"GIFTS!!!!: %@", self.arrayOfGifts);
    [self loadGiftBaskets];
    NSLog(@"Gift Baskets: %@", self.arrayOfGiftBaskets);
}

- (IBAction)didTapBackButton:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // Remember to set the Storyboard ID to LoginViewController
    PeopleViewController *peopleViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeTabBarViewController"];
    sceneDelegate.window.rootViewController = peopleViewController;
}

- (void)loadGiftBaskets {
    self.arrayOfGiftBaskets = [NSMutableArray array];
    while (self.arrayOfGifts.count >= self.numItemsInBasket) {
        NSMutableArray *gifts = [NSMutableArray new];
        while (gifts.count < self.numItemsInBasket) {
            id gift = self.arrayOfGifts[arc4random_uniform(self.arrayOfGifts.count)];
            [gifts addObject:gift];
            [self.arrayOfGifts removeObject:gift];
        }
        GiftBasket *giftBasket = [[GiftBasket alloc] init:gifts];
        [self.arrayOfGiftBaskets addObject:giftBasket];
    }
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
