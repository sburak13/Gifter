//
//  CarouselDetailsViewController.h
//  Gifter
//
//  Created by samanthaburak on 8/2/21.
//

#import <UIKit/UIKit.h>
#import "GiftBasket.h"
#import "iCarousel.h"
#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface CarouselDetailsViewController : UIViewController

@property (nonatomic, weak) GiftBasket *basket;
@property (nonatomic, weak) Person *person;

@property (weak, nonatomic) IBOutlet iCarousel *iCarouselView;

@end

NS_ASSUME_NONNULL_END
