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

@interface GiftBasketDetailsViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

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
    for (int i = 1; i <= self.basket.gifts.count; i++) {
        Gift* gift = (Gift*)[self.basket.gifts objectAtIndex:i - 1];
        gift.numInBasket = i;
    }
    
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
    
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didPinch:)];
    [cell.giftImageView addGestureRecognizer:pinchGestureRecognizer];
    cell.giftImageView.userInteractionEnabled = YES;
    pinchGestureRecognizer.delegate = self;
    
    
    /* cell.buyButtonTapHandler = ^{
            NSLog(@"Buy Button Tapped");
            
            WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
            WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
            wkWebView.navigationDelegate = self;
            [self.view addSubview:wkWebView];
        };
     */

    
    return cell;
}

- (void)didPinch:(UIPinchGestureRecognizer*)recognizer   {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        // recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
        // recognizer.scale = 1;
        
        UIView *pinchView = recognizer.view;
        CGRect bounds = pinchView.bounds;
        CGPoint pinchCenter = [recognizer locationInView:pinchView];
        pinchCenter.x -= CGRectGetMidX(bounds);
        pinchCenter.y -= CGRectGetMidY(bounds);
        CGAffineTransform transform = pinchView.transform;
        transform = CGAffineTransformTranslate(transform, pinchCenter.x, pinchCenter.y);
        CGFloat scale = recognizer.scale;
        transform = CGAffineTransformScale(transform, scale, scale);
        transform = CGAffineTransformTranslate(transform, -pinchCenter.x, -pinchCenter.y);
        pinchView.transform = transform;
        recognizer.scale = 1.0;
    
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGAffineTransform transform = CGAffineTransformMakeScale([recognizer scale],  [recognizer scale]);
        recognizer.view.transform = transform;
    }
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
