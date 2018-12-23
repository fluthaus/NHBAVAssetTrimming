//
//  AVAsset+NHBAVAssetTrimming.m
//  NHBAVAssetTrimming
//
//  Copyright © 2018 nhb | fluthaus. All rights reserved.
//

#import "AVAsset+NHBAVAssetTrimming.h"

@implementation AVAsset (NHBAVAssetTrimming)

-(AVMutableComposition* _Nullable)NHBTrimmedComposition:(NSError *__autoreleasing  _Nullable * _Nullable)error
{
	CMTimeRange const indefiniteTimeRange = CMTimeRangeMake( kCMTimeZero, kCMTimeIndefinite);
	CMTimeRange timeRange = indefiniteTimeRange;
	for (AVAssetTrack* track in self.tracks)
		timeRange = CMTimeRangeGetIntersection( timeRange, track.timeRange);

	if (!CMTIMERANGE_IS_INDEFINITE( timeRange) && !CMTIMERANGE_IS_EMPTY( timeRange))
	{
		AVMutableComposition* composition = [AVMutableComposition composition];

		for (AVAssetTrack* srcTrack in self.tracks)
		{
			AVMutableCompositionTrack* dstTrack = [composition addMutableTrackWithMediaType:srcTrack.mediaType preferredTrackID:srcTrack.trackID];
			dstTrack.naturalTimeScale = srcTrack.naturalTimeScale;
			dstTrack.preferredTransform = srcTrack.preferredTransform;
			dstTrack.preferredVolume = srcTrack.preferredVolume;
			dstTrack.languageCode = srcTrack.languageCode;
			dstTrack.extendedLanguageTag = srcTrack.extendedLanguageTag;
			BOOL success = [dstTrack insertTimeRange:timeRange ofTrack:srcTrack atTime:kCMTimeZero error:error];
			if (!success)
				return nil;
		}

		return composition;
	}
	return nil;
}

@end

