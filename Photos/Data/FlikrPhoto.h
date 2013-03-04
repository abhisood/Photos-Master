//
//  FlikrPhoto.h
//  Photos
//
//  Created by Sood, Abhishek on 3/3/13.
//
//  A class to wrap all photo data

#import <Foundation/Foundation.h>

@interface FlikrPhoto : NSObject{
    bool _imageRequested, _thumbnailRequested;
}

@property(nonatomic, readonly, retain) UIImage *thumbnail;
@property(nonatomic, readonly, retain) UIImage *image;
@property(nonatomic, readonly, retain) NSString *thumbnailURLString;
@property(nonatomic, readonly, retain) NSString *imageURLString;
@property(nonatomic, readonly, retain) NSString *title;
@property(nonatomic, readonly, retain) NSString *imageId;

-(id)initWithID:(NSString*)imgID
          title:(NSString*)title
   thumbnailURL:(NSString*)tURL
    andImageURL:(NSString*)iURL;

// load image from server, blocking
-(void)loadImage;
// load thumbnail from server, blocking
-(void)loadThumbnail;


@end
