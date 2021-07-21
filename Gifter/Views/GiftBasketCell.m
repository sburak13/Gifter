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
    
    int numItems = giftBasket.numItems;
    
    if (numItems >= 3) {
        Gift *gift3 = [giftBasket.gifts objectAtIndex:2];
        self.description3.text = gift3.descrip;
        self.description3.hidden = NO;
        self.image3.image = gift3.image;
        self.image3.hidden = NO;
    }
    
    if (numItems >= 4) {
        Gift *gift4 = [giftBasket.gifts objectAtIndex:3];
        self.description4.text = gift4.descrip;
        self.description4.hidden = NO;
        self.image4.image = gift4.image;
        self.image4.hidden = NO;
    }
    
    if (numItems >= 5) {
        Gift *gift5 = [giftBasket.gifts objectAtIndex:4];
        self.description5.text = gift5.descrip;
        self.description5.hidden = NO;
        self.image5.image = gift5.image;
        self.image5.hidden = NO;
    }
    
    /*
    self.descriptionLabel.text = gift.descrip;
    NSString *priceString = [gift.price stringValue];
    self.priceLabel.text = priceString;
    
    self.giftImageView.image = gift.image;
     */
}

@end
