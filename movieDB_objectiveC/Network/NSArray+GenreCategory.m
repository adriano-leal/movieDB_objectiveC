//
//  NSArray+GenreCategory.m
//  movieDB_objectiveC
//
//  Created by Adriano Ramos on 19/03/20.
//  Copyright © 2020 Adriano Ramos. All rights reserved.
//

#import "NSArray+GenreCategory.h"

@implementation NSArray (GenreCategory)

- (NSString *) getGenreFullString {
    
    NSString *genreString = NSString.new;
    NSString *symbol = NSString.new;
    
    
    for (NSDictionary *genreObject in self) {
        NSString *genre = [genreObject objectForKey: @"name"];
        
        
        if (genreObject != self.lastObject) {
            symbol = @", ";
        } else {
            symbol = @".";
        }
        
        genre = [genre stringByAppendingString: symbol];
        genreString = [genreString stringByAppendingString: genre];
    }
    
    return genreString;
}

@end
