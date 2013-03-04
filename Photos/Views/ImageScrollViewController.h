//
//  ImageScrollViewController.h
//  Photos
//
//  Created by Sood, Abhishek on 3/3/13.
//
//

#import <UIKit/UIKit.h>

@class PhotoCache;

@interface ImageScrollViewController : UITableViewController{
    NSOperationQueue* _queue;

}

@property(nonatomic,retain)PhotoCache* photoCache;

@end
