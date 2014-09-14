//
//  TRMixierManager.m
//  Rapper
//
//  Created by 雪本大樹 on 2014/08/12.
//  Copyright (c) 2014年 tolve. All rights reserved.
//

#import "TRMixierManager.h"

@interface TRMixierManager ()
{
    AUGraph graph;
    OSStatus ret;
    Boolean isRunnning;
}

@end

TRMixierManager *_TRMixierManager;

@implementation TRMixierManager

+(TRMixierManager *)defaultManager
{
    @synchronized([TRMixierManager class]) {
        
		if (!_TRMixierManager)
			_TRMixierManager = [[self alloc] init];
        
		return _TRMixierManager;
	}
	
	return nil;
}

- (void)startInitData
{
    ret = NewAUGraph(&graph);
    ret = AUGraphOpen(graph);
    
    AudioComponentDescription cd;
    
    // RemoteIO
    cd.componentType = kAudioUnitType_Output;
    cd.componentSubType = kAudioUnitSubType_RemoteIO;
    cd.componentManufacturer = kAudioUnitManufacturer_Apple;
    cd.componentFlags = 0;
    cd.componentFlagsMask = 0;
    
    // RemoteIOノードを作成し、AUGraphに追加
    AUNode remoteIONode;
    ret = AUGraphAddNode(graph, &cd, &remoteIONode);

    // Reverb2
    cd.componentType = kAudioUnitType_Effect;
    cd.componentSubType = kAudioUnitSubType_Reverb2;
    cd.componentManufacturer = kAudioUnitManufacturer_Apple;
    cd.componentFlags = 0;
    cd.componentFlagsMask = 0;
    
    // Reverb2ノードを作成し、AUGraphに追加
    AUNode reverbNode;
    ret = AUGraphAddNode(graph, &cd, &reverbNode);
//    ret = AUGraphNodeInfo(graph, reverbNode, NULL, &reverbUnit);
    
    // Converter Unit
    cd.componentType = kAudioUnitType_FormatConverter;
    cd.componentSubType = kAudioUnitSubType_AUConverter;
    cd.componentManufacturer = kAudioUnitManufacturer_Apple;
    cd.componentFlags = 0;
    cd.componentFlagsMask = 0;
    
    // Converterノードを作成し、AUGraphに追加
    AUNode converterNode;
    ret = AUGraphAddNode(graph, &cd, &converterNode);
    
    // MultiChannel Mixer
    cd.componentType = kAudioUnitType_Mixer;
    cd.componentSubType = kAudioUnitSubType_MultiChannelMixer;
    cd.componentManufacturer = kAudioUnitManufacturer_Apple;
    cd.componentFlags = 0;
    cd.componentFlagsMask = 0;
    
    // MultiChannel Mixerノードを作成し、AUGraphに追加
    AUNode multiChannelMixerNode;
    ret = AUGraphAddNode(graph, &cd, &multiChannelMixerNode);
    
    // Audio Unitの取得
    AudioUnit reverbUnit_;
    AudioUnit converterUnit_;
    
    ret = AUGraphNodeInfo(graph, remoteIONode, NULL, &reverbUnit_);
    ret = AUGraphNodeInfo(graph, reverbNode, NULL, &converterUnit_);
    
    // Reverb2の入力ASBDを取得
    AudioStreamBasicDescription reverb_desc = {0};
    UInt32 size = sizeof(reverb_desc);
    ret = AudioUnitGetProperty(reverbUnit_,
                               kAudioUnitProperty_StreamFormat,
                               kAudioUnitScope_Input,
                               0,
                               &reverb_desc,
                               &size);
    
    // AUConverterの出力ASBDにReverb2の入力ASBDを設定
    ret = AudioUnitSetProperty(converterUnit_,
                               kAudioUnitProperty_StreamFormat,
                               kAudioUnitScope_Output,
                               0,
                               &reverb_desc,
                               size);
    
    // RemoteIOからConverterへ接続
    ret = AUGraphConnectNodeInput(graph, remoteIONode, 1, converterNode, 0);
    
    // AUConverterからReverb2へ接続
    ret = AUGraphConnectNodeInput(graph, converterNode, 0, reverbNode, 0);
    
    // Reverb2からMultiChannelMixerへ接続
    ret = AUGraphConnectNodeInput(graph, reverbNode, 0, multiChannelMixerNode, 0);
    
    // MultiChannelMixerからRemovteIOへ接続
    ret = AUGraphConnectNodeInput(graph, multiChannelMixerNode, 0, remoteIONode, 0);
    
    CAShow(graph);
    
    // RemoteIOのAudioUnitをAUGraphから取得。後でプロパティを操作するために使う
    AudioUnit remoteIOUnit_;
    ret = AUGraphNodeInfo(graph, remoteIONode, NULL, &remoteIOUnit_);
    
    // RemoteIOUnitの入力(マイク)を有効化
    const UInt32 enableAudioInput = 1; // 0で無効
    ret = AudioUnitSetProperty(remoteIOUnit_, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, 1, &enableAudioInput, sizeof(enableAudioInput));
    
    // Reverbの設定
    AudioUnitSetParameter(reverbUnit_,              // 設定対象のAudioUnit
                          kReverb2Param_DryWetMix,  // パラメータ
                          kAudioUnitScope_Global,   // スコープ
                          0,                        // パス番号
                          50,                       // 値
                          0);                       // いつ適用するか
    
    // AUGraphの初期化
    ret = AUGraphInitialize(graph);
    
    // AUGraphの開始
    ret = AUGraphStart(graph);
    
}

- (BOOL)setupAudioSession
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    // 録音と再生が同時に行えるカテゴリを指定
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // サンプリングレートの指定
    [session setPreferredSampleRate:self.samplingRate error:nil];
    // デバイスに反映された値が設定時とは異なる場合があるため、取得した値で保持
    self.samplingRate = [session sampleRate];
    
    // オーディオセッションをActiveにすることでサウンドが鳴る
    [session setActive:YES error:nil];
    
    return YES;
}

- (void)stopAUgraph
{
    OSStatus ret = AUGraphIsRunning(graph, &isRunnning);
    if (isRunnning) {
        AUGraphStop(graph);
    }
    
    AUGraphUninitialize(graph);
    
    AUGraphClose(graph);
    
    DisposeAUGraph(graph);
}

@end
