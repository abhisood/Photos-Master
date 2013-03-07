//
//  ThumbnailTableViewCell.h
//  Photos
//
//  Created by Sood, Abhishek on 3/4/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ThumbnailImageLayer: CALayer{
    CALayer* _imageLayer;
    CALayer* _shadowLayer;
}

@property(nonatomic,readonly,retain) CALayer* imageLayer;
@property(nonatomic,readonly,retain) CALayer* shadowLayer;


@end


@class ThumbnailTableViewCell;

@protocol ThumbnailTableViewCellDelegate <NSObject>

-(void)thumbnailCell:(ThumbnailTableViewCell*)cell didSelectImageAtIndex:(NSUInteger)index;

@end

@interface ThumbnailTableViewCell : UITableViewCell{
    NSMutableArray* _imageLayers;
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

-(void)hideAllImages;
-(void)setImage:(UIImage*)image forLayerAtIndex:(NSUInteger)index;
-(ThumbnailImageLayer*)layerForIndex:(NSUInteger)index;

@end
