//
//  Network.m
//  movieDB_objectiveC
//
//  Created by Adriano Ramos on 19/03/20.
//  Copyright © 2020 Adriano Ramos. All rights reserved.
//

#import "Network.h"
#import <Foundation/Foundation.h>
#import "Movie.h"
#import "NSArray+GenreCategory.h"

@implementation Network

static NSString *const APIKey = @"79bb37b9869aa0ed97dc7a23c93d0829";
static NSString *const bannerURL = @"https://image.tmdb.org/t/p/w500";

- (void) getMovies:(movieCategory)movieCategory completion:(void (^)(NSMutableArray *))callback {
    
    NSString *getMoviesUrl = [NSString alloc];
    
    if (movieCategory == NowPlaying) {
        getMoviesUrl = @"https://api.themoviedb.org/3/movie/now_playing";
    } else if (movieCategory == Popular) {
        getMoviesUrl = @"https://api.themoviedb.org/3/movie/popular";
    }
    
    NSString *stringUrl = [NSString stringWithFormat: @"%@?api_key=%@", getMoviesUrl, APIKey];
    NSURL *url = [NSURL URLWithString:stringUrl];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Request error: %@", error);
            return;
        }
        
        NSError *err;
        
        NSDictionary *moviesJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        
        if (error) {
            NSLog(@"JSON Serialization Error: %@", error);
            return;
        }
        @try {
            //Json dictionary object array
            NSArray *movieArray = [moviesJson objectForKey: @"results"];
            //Movie object array
            NSMutableArray *movies = [[NSMutableArray alloc] init];
            
            for (NSDictionary *movie in movieArray) {
                Movie *movieItem = [[Movie alloc] init];
                NSString * bannerPath = [movie objectForKey: @"poster_path"];
                
                movieItem.movieId = [movie objectForKey: @"id"];
                movieItem.movieTitle = [movie objectForKey: @"original_title"];
                movieItem.overview = [movie objectForKey: @"overview"];
                movieItem.rating = [movie objectForKey: @"vote_average"];
                movieItem.imageUrl = [bannerURL stringByAppendingString: bannerPath];
                [movies addObject: movieItem];
                
                movieItem = nil;
            }
            callback(movies);
            
        } @catch (NSException *exception) {
            NSLog(@"Json parse error: %@", exception);
            return;
        }
    }]resume];
}

- (void)getMovieBanner:(NSString *) imageUrl completion:(void (^)(NSData *))callback {
    NSURL *imagePath = [NSURL URLWithString:imageUrl];
    
    [[NSURLSession.sharedSession dataTaskWithURL:(imagePath) completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            callback(data);
        } else {
            NSLog(@"Error while fetching image: %@",error);
        }
    }]resume];
}

- (void) getMovieDetails:(NSNumber* )movieId completion:(void (^)(Movie*))callback {
    
    NSString *movieDetailsUrl = @"https://api.themoviedb.org/3/movie/";
    
    NSString *stringUrl = [NSString stringWithFormat: @"%@%@?api_key=%@", movieDetailsUrl, movieId, APIKey];
    NSURL *url = [NSURL URLWithString:stringUrl];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"request error: %@", error);
            return;
        }
        
        NSError *err;
        
        NSDictionary *movieJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        
        if (error) {
            NSLog(@"Json Serialization error: %@", error);
            return;
        } @try {
            Movie *movieItem = [[Movie alloc] init];
            
            movieItem.movieTitle = [movieJson objectForKey:@"original_title"];
            movieItem.overview = [movieJson objectForKey:@"overview"];
            movieItem.rating = [movieJson objectForKey:@"vote_average"];
            
            NSArray *genresArray = [movieJson objectForKey:@"genres"];
            movieItem.genres = [genresArray getGenreFullString];
            
            NSString *bannerPath = [movieJson objectForKey:@"poster_path"];
            movieItem.imageUrl = [bannerURL stringByAppendingString: bannerPath];
            
            callback(movieItem);
        } @catch (NSException *exception) {
            NSLog(@"Json Parse error: %@", exception);
            return;
        }
    }]resume];
}

@end
