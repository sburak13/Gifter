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

@interface GiftBasketsViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *arrayOfGifts;
@property (strong, nonatomic) NSMutableArray *arrayOfGiftBaskets;
@property (nonatomic) int numItemsInBasket;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) NSArray *pickerData;
@property (weak, nonatomic) IBOutlet UITableView *giftBasketTableView;

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
    
    self.arrayOfGifts = self.person.giftSuggestions;
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
    int lowBound = 2;
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
