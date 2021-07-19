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
    NSString *priceString = [gift[@"price"] stringValue];
    self.priceLabel.text = priceString;
    //[NSString gift.price stringValue];
    
    // self.giftImageView.image = gift.image;
    
    /*
    self.postImageView.file = post.image;
    [self.postImageView loadInBackground];
    
    self.usernameLabel.text = post.author.username;
    self.captionLabel.text = post.caption;
    
    NSDate *createdAt = post.createdAt;
    self.timeLabel.text = createdAt.timeAgoSinceNow;
     */
}

@end
