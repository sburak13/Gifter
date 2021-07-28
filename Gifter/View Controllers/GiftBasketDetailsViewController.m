//
//  GiftBasketDetailsViewController.m
//  Gifter
//
//  Created by samanthaburak on 7/28/21.
//

#import "GiftBasketDetailsViewController.h"
#import "GiftBasketIndivGiftCell.h"
#import "GiftBasket.h"
#import "Gift.h"
#import "SceneDelegate.h"
#import "GiftBasketsViewController.h"

@interface GiftBasketDetailsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *giftBasketDetailsTableView;
@property (strong, nonatomic) NSArray *arrayOfIndivGifts;

@end

@implementation GiftBasketDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.giftBasketDetailsTableView.dataSource = self;
    self.giftBasketDetailsTableView.delegate = self;
    
    self.arrayOfIndivGifts = self.basket.gifts;
    [self.giftBasketDetailsTableView reloadData];
    
}

// need to fix
- (IBAction)didTapBackButton:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GiftBasketsViewController *giftBasketsViewController = [storyboard instantiateViewControllerWithIdentifier:@"GiftBasketsViewController"];
    sceneDelegate.window.rootViewController = giftBasketsViewController;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    GiftBasketIndivGiftCell *cell = [self.giftBasketDetailsTableView dequeueReusableCellWithIdentifier:@"GiftBasketIndivGiftCell" forIndexPath:indexPath];
    Gift *gift = self.arrayOfIndivGifts[indexPath.row];
    cell.gift = gift;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfIndivGifts.count;
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
