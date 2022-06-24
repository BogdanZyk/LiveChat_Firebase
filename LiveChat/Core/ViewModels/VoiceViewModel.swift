//
//  VoiceViewModel.swift
//  LiveChat
//
//  Created by Богдан Зыков on 19.06.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import AVFoundation
import Combine
private var subscriptions: Set<AnyCancellable> = []
class VoiceViewModel : NSObject , ObservableObject , AVAudioPlayerDelegate {
    
    var audioRecorder : AVAudioRecorder!
    
    @Published var isRecording : Bool = false
    @Published var isLoading: Bool = false
    @Published var uploadURL: URL?
    @Published var countSec = 0
    @Published var toggleColor : Bool = false
    @Published var timerCount : Timer?
    @Published var blinkingCount : Timer?
    @Published var timer : String = "00:00"
    var audioCachURL: URL?
   
    
    override init(){
        super.init()
    }
   
 
    func startRecording(){
        
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.record, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Can not setup the Recording")
        }
        
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        audioCachURL = path.appendingPathComponent("CO-Voice : \(Date()).m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: audioCachURL ?? path.appendingPathComponent("CO-Voice : \(Date()).m4a"), settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            isRecording = true
            timerCount = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (value) in
                self.countSec += 1
                self.timer = self.countSec.secondsToTime()
            })
            blinkColor()
            
        } catch {
            print("Failed to Setup the Recording")
        }
    }
    
    
    func stopRecording(){
        audioRecorder.stop()
        isRecording = false
        self.countSec = 0
        timerCount!.invalidate()
        blinkingCount!.invalidate()
        uploadAudio()
    }
    

     func uploadAudio(){
         isLoading = true
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid, let url = audioCachURL else {return}
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        ref.putFile(from: url) {(metadate, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            ref.downloadURL { url, error in
                if let error = error{
                    print(error.localizedDescription)
                }
                print(url?.absoluteString ?? "nil url")
                self.isLoading = false
                self.uploadURL = url
            }
        }
    }
    
    
    private func blinkColor() {
        
        blinkingCount = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (value) in
            self.toggleColor.toggle()
        })
        
    }
}

class SoundManager : ObservableObject {
    var audioPlayer = AVPlayer()
    @Published var currentRate: Float = 1.0
    @Published var isPlaying: Bool = false
    @Published var currentTime: Double = .zero
    @Published var duration: Double?
    @Published var isEndAudio: Bool = true
    @Published var timeDifferense: Double?
    private var subscriptions = Set<AnyCancellable>()
    
    private var timeObserver: Any?
    
    deinit {
        if let timeObserver = timeObserver {
            audioPlayer.removeTimeObserver(timeObserver)
        }
    }
    
    init(){
        startSubscriptions()
    }

    
   private func setCurrentItem(_ url: URL?) {
        guard let url = url else {return}
        let item = AVPlayerItem(url: url)
        duration = nil
        audioPlayer.replaceCurrentItem(with: item)
        item.publisher(for: \.status)
            .filter({ $0 == .readyToPlay })
            .sink(receiveValue: { [weak self] _ in
                self?.duration = item.asset.duration.seconds
            })
            .store(in: &subscriptions)
    }
    

    
    public func playOrPause(_ url: URL?){
        
        if isEndAudio{
            setCurrentItem(url)
        }
        if isPlaying{
            audioPlayer.pause()
        }else{
            audioPlayer.play()
        }
        audioPlayer.rate = currentRate
    }
    
    private func startSubscriptions(){
        audioPlayer.publisher(for: \.timeControlStatus)
            .sink { [weak self] status in
                switch status {
                case .playing:
                    self?.isPlaying = true
                case .paused:
                    self?.isPlaying = false
                case .waitingToPlayAtSpecifiedRate:
                    break
                @unknown default:
                    break
                }
            }
            .store(in: &subscriptions)
        
        timeObserver = audioPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 600), queue: .main) { [weak self] time in
            guard let self = self else { return }
            //if self.isEditingCurrentTime == false {
                self.currentTime = time.seconds
            self.isEndAudio = self.currentTime == self.duration
            if let duration = self.duration {
               self.timeDifferense = duration - self.currentTime
            }
            //}
        }
    }
}



