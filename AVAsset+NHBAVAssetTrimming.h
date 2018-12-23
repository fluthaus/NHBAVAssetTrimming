//
//  AVAsset+NHBAVAssetTrimming.h
//  NHBAVAssetTrimming
//
//  Copyright © 2018 nhb | fluthaus. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAsset (NHBAVAssetTrimming)

-(AVMutableComposition* _Nullable)NHBTrimmedComposition:(NSError *__autoreleasing  _Nullable * _Nullable)error;

@end

