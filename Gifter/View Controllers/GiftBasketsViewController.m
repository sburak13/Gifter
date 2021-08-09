//
//  GiftBasketsViewController.m
//  Gifter
//
//  Created by samanthaburak on 7/20/21.
//

#import "GiftBasketsViewController.h"
#import "SceneDelegate.h"
#import "PeopleViewController.h"
#import "GiftBasket.h"
#import "Gift.h"
#import "GiftBasketCell.h"
#import "APIManager.h"
#import "CarouselDetailsViewController.h"

@interface GiftBasketsViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property UIAlertController *giftsAlert;
@property (strong, nonatomic) NSMutableArray *arrayOfGifts;
@property (strong, nonatomic) NSMutableArray *arrayOfGiftBaskets;
@property (strong, nonatomic) NSMutableArray *filteredArrayOfGiftBaskets;
@property (nonatomic) int numItemsInBasket;
@property (strong, nonatomic) NSArray *pickerData;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UITableView *giftBasketTableView;
@property (weak, nonatomic) IBOutlet UILabel *noGiftBasketsLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadingGiftsLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortingSegmentedControl;
@property (weak, nonatomic) IBOutlet UIImageView *loadingGiftImageView;
@property (weak, nonatomic) IBOutlet UIView *loadingContainerView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *optionsContainerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation GiftBasketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *nameSubstrings = [self.person.name componentsSeparatedByString:@" "];
    NSString *firstName = [nameSubstrings objectAtIndex:0];
    self.title = [@"Gift Baskets For " stringByAppendingString: firstName];
    
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
    
    self.loadingContainerView.hidden = NO;
    self.optionsContainerView.hidden = YES;
    
    self.loadingGiftsLabel.hidden = NO;
    self.loadingGiftsLabel.layer.zPosition = 1;
    
    [UIView animateWithDuration:1.0f
                      delay:0.0f
                    options: UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionBeginFromCurrentState
                 animations: ^(void){
        self.loadingGiftsLabel.alpha = 0;
    }
                 completion:NULL];
    
    self.loadingGiftImageView.hidden = NO;
    [self animateLoadingGiftImage];
    self.loadingGiftImageView.layer.zPosition = 1;
    
    self.noGiftBasketsLabel.layer.zPosition = 1;
    
    [self.giftBasketTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self loadGifts];
    
    self.searchBar.delegate = self;
}

- (int)tableViewRowHeight {
    return self.giftBasketTableView.rowHeight = self.numItemsInBasket * 75 + self.numItemsInBasket * 10 + 40;
}

- (void)animateLoadingGiftImage {
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount = INFINITY;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.duration = 2.0;
    
    int imageWidth = 30;
    int imageHeight = 30;
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGRect circleContainer = CGRectMake(self.view.frame.size.width / 2 - imageWidth / 2, self.view.frame.size.height / 2 - imageHeight / 2 - 30, imageWidth, imageHeight);
    CGPathAddEllipseInRect(curvedPath, NULL, circleContainer);

    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);

    [self.loadingGiftImageView.layer addAnimation:pathAnimation forKey:@"myCircleAnimation"];
}

- (void)loadGifts {
    self.arrayOfGifts = [NSMutableArray array];
    
    __block int resultsCount = 0;
    NSMutableArray *interests = self.person.interests;

    for (int i = 0; i < interests.count; i++) {
        NSString *interest = [interests objectAtIndex:i];
        NSString *editedInterest = [interest stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        
        [[APIManager shared] getSearchResultsFor:editedInterest completion:^(NSDictionary *gifts, NSError *error) {
            if(error) {
                NSLog(@"Error getting search results: %@", error.localizedDescription);
                /*
                self.giftsAlert.message = [@"Gift search error: " stringByAppendingString:error.localizedDescription];
                [self presentViewController:self.giftsAlert animated:YES completion:nil];
                */
            }
            else {
                NSMutableArray *giftsDictionaryArray = [NSMutableArray array];
                
                if (apiNum == 1) {
                
                    NSArray *giftDetails = gifts[@"products"];
                    NSLog(@"%@Interest", interest);
                    NSLog(@"%@ gift details", giftDetails);
                    
                    for (NSDictionary* gift in giftDetails) {
                        NSNumber *giftPrice = gift[@"price"][@"current_price"];
                        if (!([giftPrice isEqualToNumber:@(0)])) {
                            
                            NSString *giftTitle = gift[@"title"];
                            if (!(giftTitle.length > 9 && [[giftTitle substringToIndex:9] isEqualToString: @"Sponsored"])) {
                                [giftsDictionaryArray addObject:gift];
                            }
                        }
                    }
                    resultsCount = resultsCount + 1;
                    
                } else {
    
                    NSArray *giftDetails = gifts[@"searchProductDetails"];
                    NSLog(@"%@Interest", interest);
                    NSLog(@"%@ gift details", giftDetails);
                    
                    for (NSDictionary* gift in giftDetails) {
                        NSNumber *giftPrice = gift[@"price"];
                        if (!([giftPrice isEqualToNumber:@(0)])) {
                            
                            NSString *giftTitle = gift[@"productDescription"];
                            if (!(giftTitle.length > 9 && [[giftTitle substringToIndex:9] isEqualToString: @"Sponsored"])) {
                                [giftsDictionaryArray addObject:gift];
                            }
                        }
                    }
                    resultsCount = resultsCount + 1;
                    
                }
                
                [self.arrayOfGifts addObjectsFromArray:[Gift giftsWithArray: giftsDictionaryArray FromInterest:interest]];
                NSLog(@"%@ Gifts Array", self.arrayOfGifts);
                
                [self shuffleGifts];
                
                if (resultsCount == interests.count) {
                    dispatch_async(dispatch_get_main_queue(), ^{
    
                        self.giftBasketTableView.hidden = NO;
                        self.picker.hidden = NO;
                        self.sortingSegmentedControl.hidden = NO;
                        self.loadingGiftsLabel.hidden = YES;
                        self.loadingContainerView.hidden = YES;
                        
                        [self.loadingGiftImageView.layer removeAnimationForKey:@"myCircleAnimation"];
                        self.loadingGiftImageView.hidden = YES;
                        
                        self.optionsContainerView.hidden = NO;
                        
                        self.numItemsInBasket = 1;
                        // change table view cell height
                        self.giftBasketTableView.rowHeight = [self tableViewRowHeight];
                        
                        [self loadGiftBaskets];
    
                        [self sortAscendingPrice];
                        
                        [self.giftBasketTableView reloadData];
                        
                        [self checkNoGiftBaskets];
                    });
                }
                 
            }
        }];
    }
}

- (void)shuffleGifts {
    NSUInteger count = [self.arrayOfGifts count];
    for (NSUInteger i = 0; i < count; ++i) {
        int nElements = count - i;
        int n = (arc4random() % nElements) + i;
        [self.arrayOfGifts exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

/*
- (void)limitGiftBaskets:(int)num {
    while (self.filteredArrayOfGiftBaskets.count > num) {
        int rand = arc4random_uniform(self.filteredArrayOfGiftBaskets.count);
        [self.filteredArrayOfGiftBaskets removeObjectAtIndex:rand];
    }
}
 */

- (IBAction)didTapBackButton:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    PeopleViewController *peopleViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeTabBarViewController"];
    sceneDelegate.window.rootViewController = peopleViewController;
}

- (void)combination:(NSMutableArray*)arr data:(NSMutableArray*)data start:(int)start end:(int)end index:(int)index r:(int)r {
    
    if (self.arrayOfGiftBaskets.count == 500) {
        // [self.activityIndicator stopAnimating];
        return;
    }
    
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
    
    NSLog(@"hi %d", self.arrayOfGiftBaskets.count);
}

- (void)loadGiftBaskets {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator startAnimating];
    });
    
    self.arrayOfGiftBaskets = [NSMutableArray array];
    
    NSMutableArray *combo = [NSMutableArray array];
    for (int i = 0; i < self.numItemsInBasket; i++) {
        [combo addObject:@"blank"];
    }
    
    NSLog(@"NEW LOADING");
    
    [self combination:self.arrayOfGifts data:combo start:0 end:self.arrayOfGifts.count-1 index:0 r:self.numItemsInBasket];
    
    self.filteredArrayOfGiftBaskets = self.arrayOfGiftBaskets;
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
    });
    
    
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

- (void)sortAscendingPrice {
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"totalPrice"
                                               ascending:YES];
    self.filteredArrayOfGiftBaskets = [self.filteredArrayOfGiftBaskets sortedArrayUsingDescriptors:@[sortDescriptor]];
    
}

- (void)sortDescendingPrice {
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"totalPrice"
                                               ascending:NO];
    self.filteredArrayOfGiftBaskets = [self.filteredArrayOfGiftBaskets sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (NSArray *)createPickerData {
    NSMutableArray *choices = [NSMutableArray array];
    int lowBound = 2;
    int highBound = 5;
    [choices addObject:[NSString stringWithFormat:@"Single Gift"]];
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

    self.arrayOfGiftBaskets = [NSMutableArray array];
    [self.giftBasketTableView reloadData];

    NSString *selectedEntry = [self.pickerData objectAtIndex:row];
    
    if (row != 0) {
        NSString *stringNum = [selectedEntry substringFromIndex: [selectedEntry length] - 1];
        self.numItemsInBasket = [stringNum intValue];
    } else {
        self.numItemsInBasket = 1;
    }
    
    self.giftBasketTableView.rowHeight = [self tableViewRowHeight];
    
    [self loadGiftBaskets];
    
    if (self.searchBar.text.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(giftNames CONTAINS[cd] %@)", self.searchBar.text];
        self.filteredArrayOfGiftBaskets = [self.arrayOfGiftBaskets filteredArrayUsingPredicate:predicate];
    }
    else {
        self.filteredArrayOfGiftBaskets = self.arrayOfGiftBaskets;
    }
    
    NSInteger selectedSegment = self.sortingSegmentedControl.selectedSegmentIndex;
    if (selectedSegment == 0) {
        [self sortAscendingPrice];
    } else {
        [self sortDescendingPrice];
    }
    
    [self.giftBasketTableView reloadData];

    [self checkNoGiftBaskets];
}

- (void)checkNoGiftBaskets {
    if (self.filteredArrayOfGiftBaskets.count == 0) {
        self.noGiftBasketsLabel.hidden = NO;
        self.giftBasketTableView.hidden = YES;
    } else {
        self.noGiftBasketsLabel.hidden = YES;
        self.giftBasketTableView.hidden = NO;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    GiftBasketCell *cell = [self.giftBasketTableView dequeueReusableCellWithIdentifier:@"GiftBasketCell" forIndexPath:indexPath];
    GiftBasket *giftBasket = self.filteredArrayOfGiftBaskets[indexPath.row];
    cell.giftBasket = giftBasket;

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredArrayOfGiftBaskets.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.alpha = 0;
    [UIView animateWithDuration:1 delay:0.1 * indexPath.row options:nil animations:^{
        cell.alpha = 1;
    } completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(giftNames CONTAINS[cd] %@)", searchText];
        self.filteredArrayOfGiftBaskets = [self.arrayOfGiftBaskets filteredArrayUsingPredicate:predicate];
    }
    else {
        self.filteredArrayOfGiftBaskets = self.arrayOfGiftBaskets;
    }
    
    NSInteger selectedSegment = self.sortingSegmentedControl.selectedSegmentIndex;
    if (selectedSegment == 0) {
        [self sortAscendingPrice];
    } else {
        [self sortDescendingPrice];
    }
    
    [self.giftBasketTableView reloadData];
 
}

- (IBAction)tapView:(id)sender {
    [self.view endEditing:true];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"carouselDetailsSegue"]) {
        [self.view endEditing:true];
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.giftBasketTableView indexPathForCell:tappedCell];
        GiftBasket *basket = self.filteredArrayOfGiftBaskets[indexPath.row];
        UINavigationController *navController = segue.destinationViewController;
        CarouselDetailsViewController *carouselBasketDetailsViewController = navController.topViewController;
        carouselBasketDetailsViewController.basket = basket;
        carouselBasketDetailsViewController.person = self.person;
    }

}

@end
