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
    self.heightConstraints = @[self.image1Height, self.image2Height, self.image3Height, self.image4Height, self.image5Height];
    self.widthConstraints = @[self.image1Width, self.image2Width, self.image3Width, self.image4Width, self.image5Width];
    self.spaceConstraints = @[self.image21Space, self.image32Space, self.image43Space, self.image54Space];
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
    
    
    self.image21Space.constant = 0;
    self.image32Space.constant = 0;
    self.image43Space.constant = 0;
    self.image54Space.constant = 0;
    
    
    for (int i = 0; i < self.imageViews.count; i++) {
        UIImageView *imageView = (UIImageView*)[self.imageViews objectAtIndex: i];
        UILabel *descriptionLabel = (UILabel*)[self.descriptionLabels objectAtIndex: i];
        NSLayoutConstraint *heightConstraint = (NSLayoutConstraint*)[self.heightConstraints objectAtIndex: i];
        NSLayoutConstraint *widthConstraint = (NSLayoutConstraint*)[self.widthConstraints objectAtIndex: i];
        
        if (i >= numItems) {
            imageView.hidden = YES;
            descriptionLabel.hidden = YES;
            
            widthConstraint.constant = 0;
            heightConstraint.constant = 0;
            
        } else {
            imageView.hidden = NO;
            descriptionLabel.hidden = NO;
            
            widthConstraint.constant = 70;
            heightConstraint.constant = 75;
        }
        
        /*
        if (i < self.imageViews.count - 1) {
            NSLayoutConstraint *spaceConstraint = (NSLayoutConstraint*)[self.spaceConstraints objectAtIndex: i];
            if (i >= numItems - 1) {
                spaceConstraint.constant = 0;
            } else {
                spaceConstraint.constant = 10;
            }
        }
        */
        
        
        /*i = 0
        i < 4
        i >= 0
        */
        
        
        /*
        if (numItems == 2) {
            image32Space (index 1) and image43Space (index 2) and image54Space (index3) = 0
        }
        */
        
       
    }
    
    /*
    for (int i = 0; i < self.imageViews.count; i++) {
        UIImageView *imageView = (UIImageView*)[self.imageViews objectAtIndex: i];
        UILabel *descriptionLabel = (UILabel*)[self.descriptionLabels objectAtIndex: i];
        NSLayoutConstraint *heightConstraint = (NSLayoutConstraint*)[self.heightConstraints objectAtIndex: i];
        NSLayoutConstraint *widthConstraint = (NSLayoutConstraint*)[self.widthConstraints objectAtIndex: i];
        
        imageView.hidden = NO;
        descriptionLabel.hidden = NO;
        
        widthConstraint.constant = 70;
        heightConstraint.constant = 75;
    }
     
    for (int i = numItems; i < self.imageViews.count; i++) {
        UIImageView *imageView = (UIImageView*)[self.imageViews objectAtIndex: i];
        UILabel *descriptionLabel = (UILabel*)[self.descriptionLabels objectAtIndex: i];
        NSLayoutConstraint *heightConstraint = (NSLayoutConstraint*)[self.heightConstraints objectAtIndex: i];
        NSLayoutConstraint *widthConstraint = (NSLayoutConstraint*)[self.widthConstraints objectAtIndex: i];
        
        imageView.hidden = YES;
        descriptionLabel.hidden = YES;
        
        widthConstraint.constant = 0;
        heightConstraint.constant = 0;
    }
     
    [self layoutSubviews];
    */
}



@end
