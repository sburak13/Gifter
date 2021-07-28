//
//  GiftBasketIndivGiftCell.m
//  Gifter
//
//  Created by samanthaburak on 7/28/21.
//

#import "GiftBasketIndivGiftCell.h"
#import "Gift.h"

@implementation GiftBasketIndivGiftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGift:(Gift *)gift {
    _gift = gift;
    
    self.descriptionLabel.text = gift.descrip;
    NSString *priceString = [@"$" stringByAppendingString:[gift.price stringValue]];
    self.priceLabel.text = priceString;
    
    self.giftImageView.image = gift.image;
}

@end
