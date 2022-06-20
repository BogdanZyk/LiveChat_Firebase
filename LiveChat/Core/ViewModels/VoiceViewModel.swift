//
//  VoiceViewModel.swift
//  LiveChat
//
//  Created by Богдан Зыков on 19.06.2022.
//

import Foundation

import AVFoundation

class VoiceViewModel : NSObject , ObservableObject , AVAudioPlayerDelegate {
    
    var audioRecorder : AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    
    @Published var isRecording : Bool = false
    
   // @Published var recordingsList = [Recording]()
    
    
    override init(){
        super.init()
    }
   
 
    func startRecording(){
        
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Can not setup the Recording")
        }
        
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let fileName = path.appendingPathComponent("CO-Voice : \(Date()).m4a")
        
        
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            isRecording = true
        } catch {
            print("Failed to Setup the Recording")
        }
    }
    
    
    func stopRecording(){
        audioRecorder.stop()
        isRecording = false
    }
    
}
