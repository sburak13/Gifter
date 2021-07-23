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
#import "Gift.h"
#import "GiftBasketCell.h"
#import "APIManager.h"

@interface GiftBasketsViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *arrayOfGifts;
@property (strong, nonatomic) NSMutableArray *arrayOfGiftBaskets;
@property (nonatomic) int numItemsInBasket;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) NSArray *pickerData;
@property (weak, nonatomic) IBOutlet UITableView *giftBasketTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation GiftBasketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.giftBasketTableView.dataSource = self;
    self.giftBasketTableView.delegate = self;
    
    self.pickerData = [self createPickerData]; // @[@"Basket of 2", @"Basket of 3", @"Basket of 4", @"Basket of 5"];
    
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    // self.numItemsInBasket = 2;
    
    // self.arrayOfGifts = self.person.giftSuggestions;
    [self.activityIndicator startAnimating];
    self.activityIndicator.layer.zPosition = 1;
    
    [self loadGifts];
    NSLog(@"after load gifts");
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
        // NSString *editedInterest = [interest stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSString *editedInterest = [interest stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        [[APIManager shared] getSearchResultsFor:editedInterest completion:^(NSDictionary *gifts, NSError *error) {
            if(error){
                NSLog(@"Error getting search results: %@", error.localizedDescription);
            }
            else{
                NSArray *giftDetails = gifts[@"products"];
                // NSLog(@"Search data: %@", giftDetails);
                // NSLog(@"Items in array: %@", giftDetails.count);
                NSMutableArray *giftsDictionaryArray = [NSMutableArray array];
                for (NSDictionary* gift in giftDetails) {
                    if (!([gift[@"price"][@"current_price"] isEqualToNumber:@(0)])) {
                        [giftsDictionaryArray addObject:gift];
                    }
                }
                NSLog(@"Gifts: %@", giftsDictionaryArray);
                self.arrayOfGifts = [Gift giftsWithArray: giftsDictionaryArray];
                // self.person.giftSuggestions = self.arrayOfGifts;
                // NSLog(@"More Gifts: %@", self.arrayOfGifts);
                dispatch_async(dispatch_get_main_queue(), ^{
                       // whatever code you need to be run on the main queue such as reloadData
                    // [self.giftBasketTableView reloadData];
                    self.picker.hidden = NO;
                    [self.activityIndicator stopAnimating];
                });
                
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

- (void)loadGiftBaskets {
    NSMutableArray *tempArray = [NSMutableArray array]; //[[NSMutableArray alloc] initWithCapacity:self.arrayOfGifts.count];
    for (Gift* element in self.arrayOfGifts) {
        [tempArray addObject:element];
    }
    self.arrayOfGiftBaskets = [NSMutableArray array];
    while (tempArray.count >= self.numItemsInBasket) {
        NSMutableArray *gifts = [NSMutableArray new];
        while (gifts.count < self.numItemsInBasket) {
            id gift = tempArray[arc4random_uniform(tempArray.count)];
            [gifts addObject:gift];
            [tempArray removeObject:gift];
        }
        GiftBasket *giftBasket = [[GiftBasket alloc] init:gifts];
        [self.arrayOfGiftBaskets addObject:giftBasket];
    }
}

-(NSArray *)createPickerData {
    NSMutableArray *choices = [NSMutableArray array];
    [choices addObject: @"--Select--"];
    int lowBound = 1;
    int highBound = 5;
    for (int i = lowBound; i <= highBound; i++) {
        [choices addObject:[NSString stringWithFormat:@"Basket of %d", i]];
    }
    return choices;
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row != 0) {
        NSString *selectedEntry = [self.pickerData objectAtIndex:row];
        NSString *stringNum = [selectedEntry substringFromIndex: [selectedEntry length] - 1];
        self.numItemsInBasket = [stringNum intValue];
        NSLog([NSString stringWithFormat:@"Num Items %d", self.numItemsInBasket]);
        [self loadGiftBaskets];
        NSLog(@"Gift Baskets: %@", self.arrayOfGiftBaskets);
        [self.giftBasketTableView reloadData];
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    GiftBasketCell *cell = [self.giftBasketTableView dequeueReusableCellWithIdentifier:@"GiftBasketCell" forIndexPath:indexPath];
    GiftBasket *giftBasket = self.arrayOfGiftBaskets[indexPath.row];
    cell.giftBasket = giftBasket;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfGiftBaskets.count;
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
