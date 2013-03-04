//
//  ThumbnailTableViewCell.h
//  Photos
//
//  Created by Sood, Abhishek on 3/4/13.
//
//

#import <UIKit/UIKit.h>

@class ThumbnailTableViewCell;

@protocol ThumbnailTableViewCellDelegate <NSObject>

-(void)thumbnailCell:(ThumbnailTableViewCell*)cell didSelectImageAtIndex:(NSUInteger)index;

@end

@interface ThumbnailTableViewCell : UITableViewCell{
    NSMutableArray* _imageViews;
    int _numberOfImages;
    UIEdgeInsets _insets;
    CGFloat _rowHeight;
}

@property(nonatomic,assign)CGFloat rowHeight;
@property(nonatomic,assign)int numberOfImages;
@property(nonatomic,assign)UIEdgeInsets insets;
@property(nonatomic,retain)NSMutableArray* loadImageOperations;
@property(nonatomic,retain)NSIndexPath* indexPath;
@property(nonatomic,assign)id<ThumbnailTableViewCellDelegate> delegate;

-(void)setImages:(NSArray*)images;
-(UIImageView*)imageViewForIndex:(NSUInteger)index;

@end
