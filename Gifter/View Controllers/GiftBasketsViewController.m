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

@property UIAlertController *giftsAlert;
@property (strong, nonatomic) NSMutableArray *arrayOfGifts;
@property (strong, nonatomic) NSMutableArray *arrayOfGiftBaskets;
@property (nonatomic) int numItemsInBasket;
@property (strong, nonatomic) NSArray *pickerData;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UITableView *giftBasketTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *noGiftBasketsLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadingGiftsLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortingSegmentedControl;

@end

@implementation GiftBasketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.giftsAlert = [UIAlertController alertControllerWithTitle:@"Invalid Gift Search"
                                                          message:@"message"
                                                   preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [self.giftsAlert addAction:okAction];
    
    self.giftBasketTableView.dataSource = self;
    self.giftBasketTableView.delegate = self;
    
    self.pickerData = [self createPickerData];
    
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    [self.activityIndicator startAnimating];
    self.activityIndicator.layer.zPosition = 1;
    
    self.loadingGiftsLabel.hidden = NO;
    self.loadingGiftsLabel.layer.zPosition = 1;
    
    self.noGiftBasketsLabel.layer.zPosition = 1;
    
    [self loadGifts];
    
}

- (void)loadGifts {
    NSMutableArray *interests = self.person.interests;
    
    for (NSString* interest in interests) {
        NSString *editedInterest = [interest stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        
        [[APIManager shared] getSearchResultsFor:editedInterest completion:^(NSDictionary *gifts, NSError *error) {
            if(error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Error getting search results: %@", error.localizedDescription);
                    self.giftsAlert.message = [@"Gift search error: " stringByAppendingString:error.localizedDescription];
                    [self presentViewController:self.giftsAlert animated:YES completion:^{}];
                }
            }
            else {
                NSArray *giftDetails = gifts[@"products"];
                NSMutableArray *giftsDictionaryArray = [NSMutableArray array];
                
                for (NSDictionary* gift in giftDetails) {
                    NSNumber *giftPrice = gift[@"price"][@"current_price"];
                    
                    if (!([giftPrice isEqualToNumber:@(0)])) {
                        NSString *giftTitle = gift[@"title"];
                        
                        if (!(giftTitle.length > 9 && [[giftTitle substringToIndex:9] isEqualToString: @"Sponsored"])) {
                            [giftsDictionaryArray addObject:gift];
                        }
                    }
                }
                
                self.arrayOfGifts = [Gift giftsWithArray: giftsDictionaryArray];
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.picker.hidden = NO;
                    self.sortingSegmentedControl.hidden = NO;
                    self.loadingGiftsLabel.hidden = YES;
                    [self.activityIndicator stopAnimating];
                    self.numItemsInBasket = 1;
                    [self loadGiftBaskets];
                    [self sortAscendingPrice];
                    [self.giftBasketTableView reloadData];
                });
            }
        }];
    }
}

- (IBAction)didTapBackButton:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    PeopleViewController *peopleViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeTabBarViewController"];
    sceneDelegate.window.rootViewController = peopleViewController;
}

- (void) combination: (NSMutableArray*)arr data: (NSMutableArray*)data start:(int)start end:(int)end index:(int)index r:(int)r {
    if (index == r) {
        GiftBasket *basket = [[GiftBasket alloc] init:[NSMutableArray arrayWithArray:data]];
        if (basket.totalPrice < [self.person.budgetAmt floatValue]) {
            [self.arrayOfGiftBaskets addObject:basket];
        }
        return;
    }
    
    for(int i = start; i <= end && end - i + 1 >= r - index; i++) {
        [data replaceObjectAtIndex:index withObject:arr[i]];
        [self combination:arr data:data start:i+1 end:end index:index+1 r:r];
    }
}

- (void)loadGiftBaskets {
    self.arrayOfGiftBaskets = [NSMutableArray array];
    
    NSMutableArray *combo = [NSMutableArray array];
    for (int i = 0; i < self.numItemsInBasket; i++) {
        [combo addObject:@"blank"];
    }
    
    [self combination:self.arrayOfGifts data:combo start:0 end:self.arrayOfGifts.count-1 index:0 r:self.numItemsInBasket];
}

- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        [self sortAscendingPrice];
    } else {
        [self sortDescendingPrice];
    }
    
    [self.giftBasketTableView reloadData];
}

- (void) sortAscendingPrice {
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"totalPrice"
                                               ascending:YES];
    self.arrayOfGiftBaskets = [self.arrayOfGiftBaskets sortedArrayUsingDescriptors:@[sortDescriptor]];
    
}

- (void) sortDescendingPrice {
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"totalPrice"
                                               ascending:NO];
    self.arrayOfGiftBaskets = [self.arrayOfGiftBaskets sortedArrayUsingDescriptors:@[sortDescriptor]];
    
}

- (NSArray *)createPickerData {
    NSMutableArray *choices = [NSMutableArray array];
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
    
    NSString *selectedEntry = [self.pickerData objectAtIndex:row];
    NSString *stringNum = [selectedEntry substringFromIndex: [selectedEntry length] - 1];
    
    self.numItemsInBasket = [stringNum intValue];
    NSLog([NSString stringWithFormat:@"Num Items %d", self.numItemsInBasket]);
    
    [self loadGiftBaskets];
    
    NSInteger selectedSegment = self.sortingSegmentedControl.selectedSegmentIndex;
    if (selectedSegment == 0) {
        [self sortAscendingPrice];
    } else {
        [self sortDescendingPrice];
    }
    
    [self.giftBasketTableView reloadData];
    
    if (self.arrayOfGiftBaskets.count == 0) {
        self.noGiftBasketsLabel.hidden = NO;
    } else {
        self.noGiftBasketsLabel.hidden = YES;
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
