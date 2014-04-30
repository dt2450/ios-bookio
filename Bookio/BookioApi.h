//
//  BookioApi.h
//  Bookio
//
//  Created by Pooja Jain on 4/24/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

// This request is made aynchronously using NSURLConnection
@interface BookioApi : NSObject<NSURLConnectionDelegate>
{
    // will store the response retured by the api call
    NSMutableData *responseData;
    NSURLConnection *conn;
    UIAlertView *loading;
}

// this method returns the json response given my the , his radius of interest, search query and the api key
// The result is stored in the completion block

-(void)urlOfQuery:url queryCompletion:(void (^)(NSMutableDictionary *results))completionHandler;

-(NSMutableDictionary *)asyncurlOfQuery:url;

@end
