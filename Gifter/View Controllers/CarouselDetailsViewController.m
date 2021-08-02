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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
