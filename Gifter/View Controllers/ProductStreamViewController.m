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
#import "Gift.h"
#import "GiftCell.h"

@interface ProductStreamViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *giftTableView;
@property (nonatomic) NSMutableArray *giftsDictionaryArray; // array of NSDictionaries
@property (nonatomic) NSMutableArray *arrayOfGifts; // array of Gifts

@end

@implementation ProductStreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.giftTableView.dataSource = self;
    self.giftTableView.delegate = self;
    
    self.giftsDictionaryArray = [NSMutableArray array];
    [self loadGifts];
    
}

- (void)loadGifts {
    
    NSMutableArray *interests = self.person.interests;
    NSLog(@"Name %@", self.person.name);
    
    for (NSString* interest in interests) {
        NSLog(@"INTEREST %@", interest);
        /*
        NSData * data =[interest dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"Data = %@",data);
        NSString * convertedStr =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Converted String = %@",convertedStr);
        */
        NSString *editedInterest = [interest stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [[APIManager shared] getSearchResultsFor:editedInterest completion:^(NSDictionary *gifts, NSError *error) {
            if(error){
                NSLog(@"Error getting search results: %@", error.localizedDescription);
            }
            else{
                NSArray *giftDetails = gifts[@"searchProductDetails"];
                // NSLog(@"Search data: %@", giftDetails);
                // NSLog(@"Items in array: %@", giftDetails.count);
                for (NSDictionary* gift in giftDetails) {
                    [self.giftsDictionaryArray addObject:gift];
                }
                NSLog(@"Gifts: %@", self.giftsDictionaryArray);
                self.arrayOfGifts = [Gift giftsWithArray: self.giftsDictionaryArray];
                NSLog(@"More Gifts: %@", self.arrayOfGifts);
                [self.giftTableView reloadData];
            }
        }];
        
    }
}

- (IBAction)didTapBackButton:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // Remember to set the Storyboard ID to LoginViewController
    PeopleViewController *peopleViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeTabBarViewController"];
    sceneDelegate.window.rootViewController = peopleViewController;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    GiftCell *cell = [self.giftTableView dequeueReusableCellWithIdentifier:@"GiftCell"];
    Gift *gift = self.arrayOfGifts[indexPath.row];
    cell.gift = gift;
    NSLog(@"%@", cell.gift.descrip);
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfGifts.count;
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
