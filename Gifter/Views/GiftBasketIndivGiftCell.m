//
//  GiftBasketIndivGiftCell.m
//  Gifter
//
//  Created by samanthaburak on 7/28/21.
//

#import "GiftBasketIndivGiftCell.h"
#import "Gift.h"
#import "APIManager.h"

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
    NSRange range = [self.descriptionLabel.text rangeOfString:self.descriptionLabel.text];
    self.descriptionLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.descriptionLabel.delegate = self;
    [self.descriptionLabel addLinkToURL:[NSURL URLWithString:gift.link] withRange:range]; // Embedding a custom link in a substring
    
    self.giftImageView.image = gift.image;
    self.giftImageView.layer.zPosition = 1;
    
    NSString *priceString = [@"Price: $" stringByAppendingString:[gift.price stringValue]];
    NSMutableAttributedString *priceAttributedString = [[NSMutableAttributedString alloc] initWithString:priceString];
    NSString *boldString = @"Price:";
    NSRange boldRange = [priceString rangeOfString:boldString];
    [priceAttributedString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:boldRange];
    [self.priceLabel setAttributedText: priceAttributedString];
    
    NSString *ratingString;
    if (apiNum == 1) {
        ratingString = [@"Rating: " stringByAppendingString:[gift.rating stringValue]];
    } else {
        ratingString = [@"Rating: " stringByAppendingString:gift.rating];
    }
    NSMutableAttributedString *ratingAttributedString = [[NSMutableAttributedString alloc] initWithString:ratingString];
    boldString = @"Rating:";
    boldRange = [ratingString rangeOfString:boldString];
    [ratingAttributedString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:boldRange];
    [self.ratingLabel setAttributedText: ratingAttributedString];
    
    self.suggestedBecauseLabel.text = [@"Suggested because of interest in " stringByAppendingString:gift.ofInterest];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}




@end
