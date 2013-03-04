//
//  ImageThumbnailViewController.h
//  Photos
//
//  Created by Sood, Abhishek on 3/4/13.
//
//

#import <UIKit/UIKit.h>
#import "PhotoCache.h"
#import "ThumbnailTableViewCell.h"

@interface ImageThumbnailViewController : UITableViewController<ThumbnailTableViewCellDelegate>{
    int _numberOfImagesPerRow;
    int _rowHeight;
    NSOperationQueue *_queue;
    bool requestSent;
}

@property(nonatomic,retain)PhotoCache* photoCache;

@end
