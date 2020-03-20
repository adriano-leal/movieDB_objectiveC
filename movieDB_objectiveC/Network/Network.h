//
//  Network.h
//  movieDB_objectiveC
//
//  Created by Adriano Ramos on 19/03/20.
//  Copyright © 2020 Adriano Ramos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"

@interface Network : NSObject

typedef enum categories {
    POPULAR,
    NOW_PLAYING
}movieCategory;

- (void) getMovies:(movieCategory)movieCategory completion: (void (^)(NSMutableArray*))callback;

- (void) getMovieBanner:(NSString* )imageUrl completion:(void (^)(NSData *))callback;

- (void) getMovieDetails:(int)movieId completion:(void (^)(Movie*))callback;

@end
