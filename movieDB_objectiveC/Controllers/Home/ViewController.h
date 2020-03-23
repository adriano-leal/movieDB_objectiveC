//
//  ViewController.h
//  movieDB_objectiveC
//
//  Created by Adriano Ramos on 17/03/20.
//  Copyright © 2020 Adriano Ramos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "Network.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;
@property NSArray<Movie *> *popular;
@property NSArray<Movie *> *nowPlaying;
@property Network *networking;

- (void) setupCustomNavBar;
- (void) getBanner: (NSString *)imageUrl completion:(void (^)(UIImage*))callback;

@end
