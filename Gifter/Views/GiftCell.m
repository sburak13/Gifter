//
//  GiftCell.m
//  Gifter
//
//  Created by samanthaburak on 7/15/21.
//

#import "GiftCell.h"

@implementation GiftCell

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
    /*
    if ([priceString isEqualToString:@"$0"]) {
        priceString = @"See price in cart";
    }
    */
    self.priceLabel.text = priceString;
    
    self.giftImageView.image = gift.image;
}

@end
