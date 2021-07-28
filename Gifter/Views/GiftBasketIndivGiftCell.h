//
//  GiftBasketIndivGiftCell.h
//  Gifter
//
//  Created by samanthaburak on 7/28/21.
//

#import <UIKit/UIKit.h>
#import "Gift.h"

NS_ASSUME_NONNULL_BEGIN

@interface GiftBasketIndivGiftCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@property (strong, nonatomic) Gift *gift;

@end

NS_ASSUME_NONNULL_END
