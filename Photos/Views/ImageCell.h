//
//  ImageCell.h
//  Photos
//
//  Created by Sood, Abhishek on 3/3/13.
//
//

#import <UIKit/UIKit.h>

@interface ImageCell : UITableViewCell

@property(nonatomic,retain)IBOutlet UIImageView* photoImageView;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView* activityIndicator;

@end
