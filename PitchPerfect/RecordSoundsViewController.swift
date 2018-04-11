//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Richard Menning on 09.04.18.
//  Copyright © 2018 Richard Menning. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
   
    //MARK: Variables
    var audioRecorder: AVAudioRecorder!
    var audioSession: AVAudioSession!
    
    //MARK: Outlets
    @IBOutlet weak var RecordButton: UIButton!
    @IBOutlet weak var StopRecordButton: UIButton!
    @IBOutlet weak var InstructionLabel: UILabel!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        isRecording(state: false)
    }
    
    //MARK: Actions
    @IBAction func RecordButtonPressed(_ sender: Any) {
        isRecording(state: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    @IBAction func StopButtonPressed(_ sender: Any) {
        isRecording(state: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    //MARK: audioRecorderDidFinishRecording
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            InstructionLabel.text = "Sorry, there went something wrong..:-("
        }
    }
    
    //MARK: prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    //MARK: isRecording
    func isRecording(state: Bool){
        if state {
            InstructionLabel.text = "You are recording right now!"
            StopRecordButton.isEnabled = true
            RecordButton.isEnabled = false
        } else {
            InstructionLabel.text = "Tap to record"
            StopRecordButton.isEnabled = false
            RecordButton.isEnabled = true
        }
        
    }
    
}

