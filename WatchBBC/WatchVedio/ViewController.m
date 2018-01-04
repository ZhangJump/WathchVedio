//
//  AC_AVPlayerViewController.m
//  AC_AVPlayer
//
//  Created by FM-13 on 16/6/12.
//  Copyright © 2016年 cong. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#define urlAddress @"http://wow01.105.net/live/virgin1/playlist.m3u8"
@interface ViewController ()
@property(nonatomic,strong) AVPlayer *player;
@property(nonatomic,strong) AVPlayerItem *playerItem;


@end

@implementation ViewController
- (void)viewDidLoad{
    NSURL * videoUrl = [NSURL URLWithString:urlAddress];
    self.playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    AVPlayerLayer * playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.contentsScale = [UIScreen mainScreen].scale;
    playerLayer.frame = CGRectMake(0, 100, self.view.bounds.size.width, 200);
    [self.view.layer addSublayer:playerLayer];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if([keyPath isEqualToString:@"loadedTimeRanges"]){
        //NSLog(@"%ld",[self availableDuration]);
    }
    else if([keyPath isEqualToString:@"status"]){
        
        if(playerItem.status == AVPlayerItemStatusReadyToPlay){
            [self.player play];
        }
        else{
            NSLog(@"load bread");
        }
    }
}



- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [self.playerItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    NSTimeInterval startSeconds = CMTimeGetSeconds(timeRange.start);
    NSTimeInterval durationSecond = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSecond;
    return result;
}

@end

