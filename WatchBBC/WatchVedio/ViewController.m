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
#define urlAddress1 @"http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4"
#define urlAddress2 @"https://d.pcs.baidu.com/file/c77f30e13d1166f0c92d422938fd200a?fid=1404421172-250528-301301835429935&time=1515042285&rt=pr&sign=FDTAERVC-DCb740ccc5511e5e8fedcff06b081203-W9f6sPH7grncsqlvTsdTnRgPle8%3D&expires=8h&chkv=1&chkbd=1&chkpc=&dp-logid=82217890290903058&dp-callid=0&r=162653760"

#define urlAddress3 @"https://d.pcs.baidu.com/file/613cf3d0ecaaaac2b74daf0f3dea414b?fid=1404421172-250528-507465836173296&time=1515043365&rt=pr&sign=FDTAERVC-DCb740ccc5511e5e8fedcff06b081203-Oy0hw%2B0444tYHKvpW45YyxiOm30%3D&expires=8h&chkv=1&chkbd=1&chkpc=&dp-logid=82507873883126982&dp-callid=0&r=962522292"

@interface ViewController ()
@property(nonatomic,strong) AVPlayer *player;
@property(nonatomic,strong) AVPlayerItem *playerItem;
@property(nonatomic,strong) UILabel * timeLabel;

@end

@implementation ViewController
- (void)viewDidLoad{
    NSURL * videoUrl = [NSURL URLWithString:urlAddress3];
    self.playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    AVPlayerLayer * playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.contentsScale = [UIScreen mainScreen].scale;
    playerLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:playerLayer];

    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 200, 30)];
    self.timeLabel.text = @"00:00:00/00:00:00";
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.timeLabel];
    
        __weak __typeof(self) weakSelf = self;
        [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            //当前播放的时间
            NSTimeInterval current = CMTimeGetSeconds(time);
            //视频的总时间
            NSTimeInterval total = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
            weakSelf.timeLabel.text = [NSString stringWithFormat:@"%.f/%.f",current,total];
        }];
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSTimeInterval loadedtime =  [self availableDurationWithplayerItem:playerItem];
        NSTimeInterval totalTime = CMTimeGetSeconds(playerItem.duration);
        
        NSLog(@"loadedTime-->%f",loadedtime);
        NSLog(@"totalTime-->%f",totalTime);
        
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



- (NSTimeInterval)availableDurationWithplayerItem:(AVPlayerItem *)playerItem{
    NSArray *loadedTimeRanges = [playerItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    NSTimeInterval startSeconds = CMTimeGetSeconds(timeRange.start);
    NSTimeInterval durationSecond = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSecond;

    return result;
}

@end

