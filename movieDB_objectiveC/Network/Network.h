//
//  Network.h
//  movieDB_objectiveC
//
//  Created by Adriano Ramos on 19/03/20.
//  Copyright © 2020 Adriano Ramos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"
#import "RequestType.h"

@interface Network : NSObject

- (void) getMovies:(movieCategory)movieCategory completion: (void (^)(NSMutableArray*))callback;

- (void) getMovieBanner:(NSString* )imageUrl completion:(void (^)(NSData *))callback;

- (void) getMovieDetails:(NSNumber* )movieId completion:(void (^)(Movie*))callback;

@end
