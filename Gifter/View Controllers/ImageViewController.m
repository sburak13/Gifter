//
//  ImageViewController.m
//  Gifter
//
//  Created by samanthaburak on 8/2/21.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIGestureRecognizerDelegate>

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.giftImageView.image = self.img;
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didPinch:)];
    [self.giftImageView addGestureRecognizer:pinchGestureRecognizer];
    self.giftImageView.userInteractionEnabled = YES;
    pinchGestureRecognizer.delegate = self;
}

- (void)didPinch:(UIPinchGestureRecognizer*)recognizer   {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        UIView *pinchView = recognizer.view;
        CGRect bounds = pinchView.bounds;
        CGPoint pinchCenter = [recognizer locationInView:pinchView];
        pinchCenter.x -= CGRectGetMidX(bounds);
        pinchCenter.y -= CGRectGetMidY(bounds);
        CGAffineTransform transform = pinchView.transform;
        transform = CGAffineTransformTranslate(transform, pinchCenter.x, pinchCenter.y);
        CGFloat scale = recognizer.scale;
        transform = CGAffineTransformScale(transform, scale, scale);
        transform = CGAffineTransformTranslate(transform, -pinchCenter.x, -pinchCenter.y);
        pinchView.transform = transform;
        recognizer.scale = 1.0;
        self.pinchToZoomLabel.hidden = YES;
    
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGAffineTransform transform = CGAffineTransformMakeScale([recognizer scale],  [recognizer scale]);
        recognizer.view.transform = transform;
        self.pinchToZoomLabel.hidden = NO;
    }
}

- (IBAction)didTapBack:(id)sender {
    /*
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    PeopleViewController *peopleViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeTabBarViewController"];
    sceneDelegate.window.rootViewController = peopleViewController;
    */
    
    [self dismissViewControllerAnimated:YES completion:^{
              //Stuff after dismissing
            }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
