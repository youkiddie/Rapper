//
//  TRRecordingViewController.h
//  Rapper
//
//  Created by 雪本大樹 on 2014/05/10.
//  Copyright (c) 2014年 tolve. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "TREditRecordingViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface TRRecordingViewController : BaseViewController
<AVCaptureFileOutputRecordingDelegate>
{
    AVAudioPlayer *audio;
    AVCaptureSession *captureSession;
    AVCaptureMovieFileOutput *audioFileOutput;
    NSURL *recordedFileURL;
    BOOL recEnd;
}

@property IBOutlet UIButton *recBtn;

- (IBAction)recAndStop:(id)sender;

@end
