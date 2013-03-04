//
//  ViewController.h
//  Photos
//
//  Created by Farhad Noorzay on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoCache;
@class ImageScrollViewController;

@interface ViewController : UIViewController
{
    @private
    NSOperationQueue* _queue;
    PhotoCache* _photoCache;
    ImageScrollViewController* _imageScrollVC;
}

@property (nonatomic, retain) IBOutlet UIView *referenceView;

- (IBAction)refresh:(id)sender;

@end
