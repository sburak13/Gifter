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
                    NSNumber *giftPrice = gift[@"price"][@"current_price"];
                    if (!([giftPrice isEqualToNumber:@(0)])) {
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

- (void) combination: (NSMutableArray*)arr data: (NSMutableArray*)data start:(int)start end:(int)end index:(int)index r:(int)r {
    if(index == r) {
        /*for(int j = 0; j < r; j++)
            System.out.print(data[j]+" ");
        System.out.println();
         */
        // NSArray *gifts = [NSArray initWithArray:data];
        
        GiftBasket *basket = [[GiftBasket alloc] init:[NSMutableArray arrayWithArray:data]];
        [self.arrayOfGiftBaskets addObject:basket];
        return;
    }
    
    for(int i = start; i <= end && end - i + 1 >= r - index; i++) {
        // data[index] = arr[i];
        [data replaceObjectAtIndex:index withObject:arr[i]];
        
        // combination(arr, data, i+1, end, index+1, r);
        [self combination:arr data:data start:i+1 end:end index:index+1 r:r];
    }
    
}


- (void)loadGiftBaskets {
    /*
     NSMutableArray *tempArray = [NSMutableArray array]; //[[NSMutableArray alloc] initWithCapacity:self.arrayOfGifts.count];
    for (Gift* element in self.arrayOfGifts) {
        [tempArray addObject:element];
    }
     */
    self.arrayOfGiftBaskets = [NSMutableArray array];
    //[self permute:self.arrayOfGifts range:NSMakeRange(0, self.arrayOfGiftBaskets.count)];
    // NSLog(@"%@", self.arrayOfGiftBaskets);
    
    NSMutableArray *combo = [NSMutableArray array];
    for (int i = 0; i < self.numItemsInBasket; i++) {
        [combo addObject:@"blank"];
    }
    [self combination:self.arrayOfGifts data:combo start:0 end:self.arrayOfGifts.count-1 index:0 r:self.numItemsInBasket];
    NSLog(@"%@", self.arrayOfGiftBaskets);
    
}
    
    /*
    for (int i = 0; i < self.arrayOfGifts.count; i++) {
        NSLog(@"running");
        if (self.numItemsInBasket >= 2) {
            for (int j = 1; j < self.arrayOfGifts.count; j++) {
                if (self.numItemsInBasket >= 3) {
                    for (int k = 2; k < self.arrayOfGifts.count; k++) {
                        if (self.numItemsInBasket >= 4) {
                            for (int l = 3; l < self.arrayOfGifts.count; l++) {
                                if (self.numItemsInBasket >= 5) {
                                    for (int m = 4; m < self.arrayOfGifts.count; m++) {
                                        GiftBasket *basket = [[GiftBasket alloc] init];
                                        [basket addGift:self.arrayOfGifts[i]];
                                        [basket addGift:self.arrayOfGifts[j]];
                                        [basket addGift:self.arrayOfGifts[k]];
                                        [basket addGift:self.arrayOfGifts[l]];
                                        [basket addGift:self.arrayOfGifts[m]];
                                        if (basket.totalPrice < [self.person.budgetAmt floatValue]) {
                                            [self.arrayOfGiftBaskets addObject:basket];
                                        }
                                    }
                                } else {
                                    GiftBasket *basket = [[GiftBasket alloc] init];
                                    [basket addGift:self.arrayOfGifts[i]];
                                    [basket addGift:self.arrayOfGifts[j]];
                                    [basket addGift:self.arrayOfGifts[k]];
                                    [basket addGift:self.arrayOfGifts[l]];
                                    if (basket.totalPrice < [self.person.budgetAmt floatValue]) {
                                        [self.arrayOfGiftBaskets addObject:basket];
                                    }
                                }
                            }
                        } else {
                            GiftBasket *basket = [[GiftBasket alloc] init];
                            [basket addGift:self.arrayOfGifts[i]];
                            [basket addGift:self.arrayOfGifts[j]];
                            [basket addGift:self.arrayOfGifts[k]];
                            if (basket.totalPrice < [self.person.budgetAmt floatValue]) {
                                [self.arrayOfGiftBaskets addObject:basket];
                            }
                        }
                    }
                } else {
                    GiftBasket *basket = [[GiftBasket alloc] init];
                    [basket addGift:self.arrayOfGifts[i]];
                    [basket addGift:self.arrayOfGifts[j]];
                    if (basket.totalPrice < [self.person.budgetAmt floatValue]) {
                        [self.arrayOfGiftBaskets addObject:basket];
                    }
                }
            }
        } else {
            GiftBasket *basket = [[GiftBasket alloc] init];
            [basket addGift:self.arrayOfGifts[i]];
            if (basket.totalPrice < [self.person.budgetAmt floatValue]) {
                [self.arrayOfGiftBaskets addObject:basket];
            }
        }
    }
    
    
    NSLog(@"No gifts in gift basket");
    */
    
    /*
    
    
    NSMutableArray * combos = [NSMutableArray array];
    // Loop through all possible index subsets
    for( uint64_t index_mask = 0; index_mask < UINT64_MAX; index_mask++ ){
        // Check the size of this subset; pass if it's not right.
        uint64_t num_set_bits = __builtin_popcountll(index_mask);
        if( num_set_bits != self.numItemsInBasket ){
            continue;
        }

        // If the size is correct, collect the subarray
        NSIndexSet * indexes = [NSIndexSet WSSIndexSetFromMask:index_mask];
        GiftBasket *basket = [[GiftBasket alloc] init:[self.arrayOfGifts objectsAtIndexes:indexes]];
    }
     */
    
    
    
    // [self getCombosOfLength:self.numItemsInBasket withTotalArrayLenth:self.arrayOfGifts.count withGiftBasket:basket];
    /*
     while (tempArray.count >= self.numItemsInBasket) {
        NSMutableArray *gifts = [NSMutableArray new];
        while (gifts.count < self.numItemsInBasket) {
            id gift = tempArray[arc4random_uniform(tempArray.count)];
            [gifts addObject:gift];
            [tempArray removeObject:gift];
        }
        GiftBasket *giftBasket = [[GiftBasket alloc] init:gifts];
        if (giftBasket.totalPrice < [self.person.budgetAmt floatValue])
        [self.arrayOfGiftBaskets addObject:giftBasket];
    }
     */
    
    /*
    [1 2 3 4 5] choose 2
    
    1 2
    1 3
    1 4
    1 5
    
    [2 3 4 5] choose 2
    
    2 3
    2 4
    2 5
    
    [3 4 5] choose 2
    
    3 4
    3 5
    
    [4 5] choose 2
    4 5
    
    
    while (tempArray.count >= self.numItemsInBasket) {
        for (int i = 0; i < tempArray.count; i++) {
            for (int j = i + 1; j < tempArray.count; j++) {
                id gift = tempArray[j];
            }
        }
    }
     */



/*
-(void)getCombosOfLength:(int)k withTotalArrayLenth:(int)n withGiftBasket:(GiftBasket *)basket {
    // invalid input
    if (k > n) {
        NSLog(@"Invalid input");
        return;
    }
    
    // base case: combination size is `k`
    if (k == 0) {
        NSLog(@"Base case reached");
        [self.arrayOfGiftBaskets addObject:basket];
        basket = [[GiftBasket alloc] init];
        return;
    }
    
    // start from the next index till the first index
    for (int i = n - 1; i >= 0; i--)
    {
        // add current element `arr[i]` to the output and recur for next index
        // `i-1` with one less element `k-1`
        id gift = self.arrayOfGifts[i];
        [basket addGift:gift];
        [self getCombosOfLength:k - 1 withTotalArrayLenth:i withGiftBasket:basket];
    }
     
}
 */


/*- (void)permute:(NSMutableArray *)word range:(NSRange)range {
    static NSMutableArray *copyOfWord;
    if (!copyOfWord) {
        copyOfWord = [word copy];
    }
    if (range.location == range.length) {
        GiftBasket *basket = [[GiftBasket alloc] init:copyOfWord];
        [self.arrayOfGiftBaskets addObject:basket];
        copyOfWord = nil; // We're done now.  Set back to `nil` so next call can use it
    } else {
        for (int i = range.location; i < range.length; ++i) {
            NSString *currentWord = copyOfWord[range.location];
            copyOfWord[range.location] = copyOfWord[range.length];
            copyOfWord[range.length] = currentWord;

            [self permute:copyOfWord range:NSMakeRange(range.location + 1, range.length)];
        }
    }
}
*/

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
