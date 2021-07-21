//
//  GiftBasketCell.m
//  Gifter
//
//  Created by samanthaburak on 7/21/21.
//

#import "GiftBasketCell.h"
#import "GiftBasket.h"
#import "Gift.h"

@implementation GiftBasketCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (void)setGiftBasket:(GiftBasket *)giftBasket {
    _giftBasket = giftBasket;
    
    self.totalPriceLabel.text = [@"$" stringByAppendingString:[[NSNumber numberWithDouble:giftBasket.totalPrice] stringValue]];
    
    Gift *gift1 = [giftBasket.gifts objectAtIndex:0];
    Gift *gift2 = [giftBasket.gifts objectAtIndex:1];
    
    self.description1.text = gift1.descrip;
    self.description2.text = gift2.descrip;
    
    self.image1.image = gift1.image;
    self.image2.image = gift2.image;
    
    /*
    self.descriptionLabel.text = gift.descrip;
    NSString *priceString = [gift.price stringValue];
    self.priceLabel.text = priceString;
    
    self.giftImageView.image = gift.image;
     */
     }

@end
