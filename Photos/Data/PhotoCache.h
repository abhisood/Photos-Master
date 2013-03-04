//
//  PhotoCache.h
//  Photos
//
//  Created by Sood, Abhishek on 3/3/13.
//
//

#import <Foundation/Foundation.h>

@class FlikrPhoto;
@class PhotoCache;

typedef void (^NextPageLoadSuccess)();
typedef void (^NextPageLoadError)(NSError* error);


@interface PhotoCache : NSObject{

    @protected
    int _totalPages;
    int _totalImages;
    int _numberOfImagesPerPage;
    int _currentPageNumber;
    
    // a mapping of photo id to index in array
    NSMutableDictionary* _photoIndices;
    // an array of photos
    NSMutableArray* _photos;
}

// returns true if more pages can be loaded from server
-(BOOL)hasMorePagesToLoad;

// non blocking, success and error blocks are called back on main thread
-(void)loadNextPageWithSuccessBlock:(NextPageLoadSuccess)successBlock andErrorBlock:(NextPageLoadError)errorBlock;

-(FlikrPhoto*) photoForImageId:(NSString*)photoId;
-(FlikrPhoto*) photoForIndex:(NSUInteger)idx;
-(NSUInteger)photoCount;

@end
