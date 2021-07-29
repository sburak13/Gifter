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
    
    self.itemNumLabel.text = [@"Item #" stringByAppendingString:[NSString stringWithFormat:@"%d", gift.numInBasket]];
    
    self.descriptionLabel.text = gift.descrip;
    
    self.giftImageView.image = gift.image;
    
    NSString *priceString = [@"Price: $" stringByAppendingString:[gift.price stringValue]];
    NSMutableAttributedString *priceAttributedString = [[NSMutableAttributedString alloc] initWithString:priceString];
    NSString *boldString = @"Price:";
    NSRange boldRange = [priceString rangeOfString:boldString];
    [priceAttributedString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:boldRange];
    [self.priceLabel setAttributedText: priceAttributedString];
    
    NSString *ratingString = [@"Rating: " stringByAppendingString:[gift.rating stringValue]];
    NSMutableAttributedString *ratingAttributedString = [[NSMutableAttributedString alloc] initWithString:ratingString];
    boldString = @"Rating:";
    boldRange = [ratingString rangeOfString:boldString];
    [ratingAttributedString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:boldRange];
    [self.ratingLabel setAttributedText: ratingAttributedString];
}



/*
 - (IBAction)buyButtonTapped:(UIButton *)sender {
    self.buyButtonTapHandler();
}
 */



@end
