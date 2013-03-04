//
//  ImageViewController.h
//  Photos
//
//  Created by Sood, Abhishek on 3/4/13.
//
//

#import <UIKit/UIKit.h>

@class FlikrPhoto;

@interface ImageViewController : UIViewController

@property(nonatomic,retain)IBOutlet UILabel* titleLabel;
@property(nonatomic,retain)IBOutlet UIImageView* imageView;
@property(nonatomic,retain)FlikrPhoto* photo;

@end
