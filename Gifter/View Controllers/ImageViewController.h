//
//  ImageViewController.h
//  Gifter
//
//  Created by samanthaburak on 8/2/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (nonatomic, weak) UIImage *img;
@property (weak, nonatomic) IBOutlet UILabel *pinchToZoomLabel;

@end

NS_ASSUME_NONNULL_END
