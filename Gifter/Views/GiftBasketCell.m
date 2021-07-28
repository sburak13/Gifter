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
    
    self.imageViews = @[self.image1, self.image2, self.image3, self.image4, self.image5];
    self.descriptionLabels = @[self.description1, self.description2, self.description3, self.description4, self.description5];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (void)setGiftBasket:(GiftBasket *)giftBasket {
    _giftBasket = giftBasket;
    
    NSString *priceString = [@"$" stringByAppendingString:[[NSNumber numberWithDouble:giftBasket.totalPrice] stringValue]];
    self.totalPriceLabel.text = priceString;
    
    Gift *gift1 = [giftBasket.gifts objectAtIndex:0];
    self.description1.text = gift1.descrip;
    self.image1.image = gift1.image;
    
    int numItems = giftBasket.numItems;
    
    if (numItems >= 2) {
        Gift *gift2 = [giftBasket.gifts objectAtIndex:1];
        self.description2.text = gift2.descrip;
        self.image2.image = gift2.image;
    }
    
    if (numItems >= 3) {
        Gift *gift3 = [giftBasket.gifts objectAtIndex:2];
        self.description3.text = gift3.descrip;
        self.image3.image = gift3.image;
    }
    
    if (numItems >= 4) {
        Gift *gift4 = [giftBasket.gifts objectAtIndex:3];
        self.description4.text = gift4.descrip;
        self.image4.image = gift4.image;
    }
    
    if (numItems >= 5) {
        Gift *gift5 = [giftBasket.gifts objectAtIndex:4];
        self.description5.text = gift5.descrip;
        self.image5.image = gift5.image;
    }
    
    [self hideUnhideUI:numItems];
}

- (void)hideUnhideUI:(int)numItems {
    self.description2.hidden = YES;
    self.description3.hidden = YES;
    self.description4.hidden = YES;
    self.description5.hidden = YES;
    self.image2.hidden = YES;
    self.image3.hidden = YES;
    self.image4.hidden = YES;
    self.image5.hidden = YES;
    
    for (int i = 0; i < numItems; i++) {
        ((UIImageView*)[self.imageViews objectAtIndex: i]).hidden = NO;
        ((UILabel*)[self.descriptionLabels objectAtIndex: i]).hidden = NO;
    }
}

@end
