//
//  CarouselDetailsViewController.m
//  Gifter
//
//  Created by samanthaburak on 8/2/21.
//

#import "CarouselDetailsViewController.h"
#import "GiftBasketIndivGiftCell.h"
#import "GiftBasket.h"
#import "Gift.h"
#import "SceneDelegate.h"
#import "GiftBasketsViewController.h"
#import "APIManager.h"

@interface CarouselDetailsViewController () <iCarouselDelegate, iCarouselDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSArray *arrayOfIndivGifts;
@property (strong, nonatomic) NSMutableArray *imageArr;

@end

@implementation CarouselDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didPinch:)];
    [self.iCarouselView addGestureRecognizer:pinchGestureRecognizer];
    self.iCarouselView.userInteractionEnabled = YES;
    pinchGestureRecognizer.delegate = self;
    
    self.iCarouselView.dataSource = self;
    self.iCarouselView.delegate = self;
    
    self.iCarouselView.type = iCarouselTypeRotary;
    self.iCarouselView.contentMode = UIViewContentModeScaleAspectFit;
    
    if (self.arrayOfIndivGifts.count > 0) {
        self.gift = (Gift*)self.arrayOfIndivGifts[0];
    }
    [self setUI];
}

- (void)didPinch:(UIPinchGestureRecognizer*)recognizer   {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
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

- (void)setUI {
    self.itemNumLabel.text = [[@"Item #" stringByAppendingString:[NSString stringWithFormat:@"%d", self.gift.numInBasket]] stringByAppendingString:[@" of " stringByAppendingString:[[NSString stringWithFormat:@"%d", self.arrayOfIndivGifts.count] stringByAppendingString:@":"]]];
    
    self.descriptionLabel.text = self.gift.descrip;
    NSRange range = [self.descriptionLabel.text rangeOfString:self.descriptionLabel.text];
    self.descriptionLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.descriptionLabel.delegate = self;
    [self.descriptionLabel addLinkToURL:[NSURL URLWithString:self.gift.link] withRange:range]; // Embedding a custom link in a substring
    
    NSString *priceString = [@"Price: $" stringByAppendingString:[self.gift.price stringValue]];
    NSMutableAttributedString *priceAttributedString = [[NSMutableAttributedString alloc] initWithString:priceString];
    NSString *boldString = @"Price:";
    NSRange boldRange = [priceString rangeOfString:boldString];
    [priceAttributedString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:boldRange];
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
    [ratingAttributedString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:boldRange];
    [self.ratingLabel setAttributedText: ratingAttributedString];
    
    self.suggestedBecauseLabel.text = [@"Suggested because of interest in " stringByAppendingString:self.gift.ofInterest];
    
    self.headerLabel.text = [[@"Present for " stringByAppendingString:self.person.name] stringByAppendingString:[@" - $" stringByAppendingString:[@(self.basket.totalPrice) stringValue]]];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}

- (nonnull UIView *)carousel:(nonnull iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view {
    view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
    ((UIImageView *)view).image = self.imageArr[index];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
