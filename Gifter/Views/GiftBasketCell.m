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
    
    /*
    for (int i = 0; i < self.imageViews.count; i++) {
        UIImageView *imageView = (UIImageView*)[self.imageViews objectAtIndex: i];
        UILabel *descriptionLabel = (UILabel*)[self.descriptionLabels objectAtIndex: i];
        
        imageView.hidden = NO;
        descriptionLabel.hidden = NO;
        
        imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 70, 70);
        descriptionLabel.frame = CGRectMake(descriptionLabel.frame.origin.x, descriptionLabel.frame.origin.y, 210, 70);
    }
     */
    
    
    if (numItems != 5) {
        self.image5Width.constant = 0;
        self.image5Height.constant = 0;
    } else {
        self.image5Width.constant = 70;
        self.image5Height.constant = 70;
    }
    
    /*
    for (int i = numItems; i < self.imageViews.count; i++) {
        UIImageView *imageView = (UIImageView*)[self.imageViews objectAtIndex: i];
        UILabel *descriptionLabel = (UILabel*)[self.descriptionLabels objectAtIndex: i];
        
        imageView.hidden = YES;
        descriptionLabel.hidden = YES;
        
        descriptionLabel.text = @"";
        
        imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 0, 0);
        imageView.backgroundColor = [UIColor greenColor];
        descriptionLabel.frame = CGRectMake(descriptionLabel.frame.origin.x, descriptionLabel.frame.origin.y, 0, 0);
        descriptionLabel.backgroundColor = [UIColor greenColor];
        
        
    }
     */
    
    
    [self layoutSubviews];
    // self.image1.frame = CGRectMake(self.image1.frame.origin.x, self.image1.frame.origin.y, 20, 20);
    // self.description1.frame = CGRectMake(self.description1.frame.origin.x, self.description1.frame.origin.y, 20, 20);
}



@end
