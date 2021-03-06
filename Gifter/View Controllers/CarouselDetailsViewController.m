//
//  CarouselDetailsViewController.m
//  Gifter
//
//  Created by samanthaburak on 8/2/21.
//

#import "ImageViewController.h"
#import "CarouselDetailsViewController.h"
#import "GiftBasket.h"
#import "Gift.h"
#import "SceneDelegate.h"
#import "GiftBasketsViewController.h"
#import "APIManager.h"

@interface CarouselDetailsViewController () <iCarouselDelegate, iCarouselDataSource>

@property (strong, nonatomic) NSArray *arrayOfIndivGifts;
@property (strong, nonatomic) NSMutableArray *imageArr;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *starredButton;

@end

@implementation CarouselDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat contentWidth = self.scrollView.bounds.size.width;
    CGFloat contentHeight = self.scrollView.bounds.size.height * 3;
    self.scrollView.contentSize = CGSizeMake(contentWidth, contentHeight);

    self.arrayOfIndivGifts = self.basket.gifts;
    for (int i = 1; i <= self.basket.gifts.count; i++) {
        Gift* gift = (Gift*)[self.basket.gifts objectAtIndex:i - 1];
        gift.numInBasket = i;
    }
    
    self.imageArr = [NSMutableArray array];
    for (int i = 0; i < self.arrayOfIndivGifts.count; i++) {
        Gift* gift = (Gift*)self.arrayOfIndivGifts[i];
        [self.imageArr addObject:gift.image];
    }
    
    self.iCarouselView.dataSource = self;
    self.iCarouselView.delegate = self;
    
    self.iCarouselView.type = iCarouselTypeRotary;
    self.iCarouselView.contentMode = UIViewContentModeScaleAspectFit;
    
    if (self.arrayOfIndivGifts.count > 0) {
        self.gift = (Gift*)self.arrayOfIndivGifts[0];
    }
    
    [self setUI];
    
}

- (IBAction)didTapStar:(id)sender {
    self.basket.starred = !self.basket.starred;
    
    if (self.basket.starred) {
        ((UIButton*) sender).tintColor = [UIColor yellowColor];
        [self.person.starredBaskets addObject:self.basket];
        
        /*
        [self.person fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (!error) {
        
                NSMutableArray *newArray = object[@"starredBaskets"];
            
                NSLog(@"before ", newArray);
                
                [newArray addObject: @"test"];
                NSLog(@"after ", newArray);
                
                // object[@"starredBaskets"] = newArray;
                // [object saveInBackground];
                
                [object setObject:newArray forKey:@"starredBaskets"];
                
                
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if(error){
                        NSLog(@"Error: %@", error.localizedDescription);
                    } else {
                        NSLog(@"Suceeded");
                    }
                }];
            } else {
                NSLog(@"Failed to get person");
            }
        }];
        */
    } else {
        [self.person.starredBaskets removeObject:self.basket];
        ((UIButton*) sender).tintColor = [UIColor whiteColor];
        
    }
    /*
    PFQuery *query = [PFQuery queryWithClassName:@"Person"];

    // Retrieve the object by id
    [query getObjectInBackgroundWithId:@"<PARSE_OBJECT_ID>"
                                 block:^(PFObject *parseObject, NSError *error) {
        parseObject[@"myCustomKey1Name"] = @"My custom value";
        parseObject[@"myCustomKey2Name"] = @999;
        [parseObject saveInBackground];
    }];
    */

}


- (void)setUI {
    self.itemNumLabel.text = [[@"Item " stringByAppendingString:[NSString stringWithFormat:@"%d", self.gift.numInBasket]] stringByAppendingString:[@" of " stringByAppendingString:[[NSString stringWithFormat:@"%d", self.arrayOfIndivGifts.count] stringByAppendingString:@":"]]];
    
    self.descriptionLabel.text = self.gift.descrip;
    NSRange range = [self.descriptionLabel.text rangeOfString:self.descriptionLabel.text];
    self.descriptionLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.descriptionLabel.delegate = self;
    [self.descriptionLabel addLinkToURL:[NSURL URLWithString:self.gift.link] withRange:range];
    
    NSString *priceString = [@"Price: $" stringByAppendingString:[NSString stringWithFormat:@"%.2f", self.gift.price]];
    NSMutableAttributedString *priceAttributedString = [[NSMutableAttributedString alloc] initWithString:priceString];
    NSString *boldString = @"Price:";
    NSRange boldRange = [priceString rangeOfString:boldString];
    [priceAttributedString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:boldRange];
    [self.priceLabel setAttributedText: priceAttributedString];
    
    NSString *ratingString;
    if (apiNum == 1) {
        ratingString = [@"Rating: " stringByAppendingString:[self.gift.rating stringValue]];
    } else {
        ratingString = [@"Rating: " stringByAppendingString:self.gift.rating];
    }
    NSMutableAttributedString *ratingAttributedString = [[NSMutableAttributedString alloc] initWithString:ratingString];
    boldString = @"Rating:";
    boldRange = [ratingString rangeOfString:boldString];
    [ratingAttributedString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:boldRange];
    [self.ratingLabel setAttributedText: ratingAttributedString];
    
    self.suggestedBecauseLabel.text = [@"Suggested because of interest in " stringByAppendingString:self.gift.ofInterest];
    
    self.headerLabel.text = [@"Present for " stringByAppendingString:self.person.name];
    self.headerLabel.numberOfLines = 1;
    self.headerLabel.minimumFontSize = 8;
    self.headerLabel.adjustsFontSizeToFitWidth = YES;

    NSString *totalPriceString = [@"Total Price: $" stringByAppendingString:[NSString stringWithFormat:@"%.2f", self.basket.totalPrice]];
    NSMutableAttributedString *totalPriceAttributedString = [[NSMutableAttributedString alloc] initWithString:totalPriceString];
    boldString = @"Total Price:";
    boldRange = [totalPriceString rangeOfString:boldString];
    [totalPriceAttributedString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:boldRange];
    [self.totalPriceLabel setAttributedText: totalPriceAttributedString];
    
    if (self.basket.starred) {
        self.starredButton.tintColor =  [UIColor yellowColor];
    } else {
        self.starredButton.tintColor =  [UIColor whiteColor];
    }
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}

- (nonnull UIView *)carousel:(nonnull iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view {
    UIImage* giftImage = self.imageArr[index];
    view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, giftImage.size.width * 0.75, giftImage.size.height * 0.75)]; 
    ((UIImageView *)view).image = giftImage;
    return view;
}

- (NSInteger)numberOfItemsInCarousel:(nonnull iCarousel *)carousel {
    return self.imageArr.count;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    if (option == iCarouselOptionSpacing) {
        return value * 1.3;
    }
    return value;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    self.gift = self.arrayOfIndivGifts[self.iCarouselView.currentItemIndex];
    [self setUI];
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    [self performSegueWithIdentifier:@"imageSegue" sender:self];
}

- (IBAction)didTapDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"imageSegue"]) {
        ImageViewController *imageViewController = segue.destinationViewController;
        Gift* gift = (Gift*)self.arrayOfIndivGifts[self.iCarouselView.currentItemIndex];
        // UINavigationController *navController = segue.destinationViewController;
       //  ImageViewController *imageViewController = navController.topViewController;
        imageViewController.img = gift.image;
    }
}

@end
