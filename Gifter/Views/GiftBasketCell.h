//
//  GiftBasketCell.h
//  Gifter
//
//  Created by samanthaburak on 7/21/21.
//

#import <UIKit/UIKit.h>
#import "GiftBasket.h"

NS_ASSUME_NONNULL_BEGIN

@interface GiftBasketCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIImageView *image5;
@property (weak, nonatomic) IBOutlet UILabel *description1;
@property (weak, nonatomic) IBOutlet UILabel *description2;
@property (weak, nonatomic) IBOutlet UILabel *description3;
@property (weak, nonatomic) IBOutlet UILabel *description4;
@property (weak, nonatomic) IBOutlet UILabel *description5;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (strong, nonatomic) GiftBasket *giftBasket;
@property (strong, nonatomic) NSArray *imageViews;
@property (strong, nonatomic) NSArray *descriptionLabels;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image5Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image5Width;

@end

NS_ASSUME_NONNULL_END
