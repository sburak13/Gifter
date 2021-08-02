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
#import "Gift.h"
#import "TTTAttributedLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CarouselDetailsViewController : UIViewController

@property (nonatomic, weak) GiftBasket *basket;
@property (nonatomic, weak) Person *person;
@property (nonatomic, weak) Gift *gift;

@property (weak, nonatomic) IBOutlet iCarousel *iCarouselView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *suggestedBecauseLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@end

NS_ASSUME_NONNULL_END
