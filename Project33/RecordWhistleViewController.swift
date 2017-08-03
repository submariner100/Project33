//
//  RecordWhistleViewController.swift
//  Project33
//
//  Created by Macbook on 02/08/2017.
//  Copyright © 2017 Chappy-App. All rights reserved.
//

import UIKit
import AVFoundation

class RecordWhistleViewController: UIViewController, AVAudioRecorderDelegate {
	
	var recordButton: UIButton!
	var recordingSession: AVAudioSession!
	var whistleRecorder: AVAudioRecorder!
	var stackView: UIStackView!
	var playButton: UIButton!
	var whistlePlayer: AVAudioPlayer!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Record your Whistle"
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "Record", style: .plain, target: nil, action: nil)
		
		recordingSession = AVAudioSession.sharedInstance()
		
		do {
			try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
			try recordingSession.setActive(true)
			recordingSession.requestRecordPermission() { [unowned self] allowed in
				DispatchQueue.main.async {
					if allowed {
						self.loadRecordingUI()
						
					} else {
						
						self.loadFailUI()
						
					}
				}
			}
			
		} catch {
			
			self.loadFailUI()
		}
	}
	
	func loadRecordingUI() {
		
		recordButton = UIButton()
		recordButton.translatesAutoresizingMaskIntoConstraints = false
		recordButton.setTitle("Tap to Record", for: .normal)
		recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
		recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
		stackView.addArrangedSubview(recordButton)
		
		playButton = UIButton()
		playButton.translatesAutoresizingMaskIntoConstraints = false
		playButton.setTitle("Tap to Play", for: .normal)
		playButton.isHidden = true
		playButton.alpha = 0
		playButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
		playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
		stackView.addArrangedSubview(playButton)
		
		
	}
	
	func playTapped() {
		
		let audioURL = RecordWhistleViewController.getWhistleURL()
		
		do {
			whistlePlayer = try AVAudioPlayer(contentsOf: audioURL)
			whistlePlayer.play()
			
		} catch {
			
			let ac = UIAlertController(title: "Playback failed", message: "There was a problem playing your whistle; please try re-recording", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			present(ac, animated: true)
		}
	
	}
	
	func loadFailUI() {
		
		let failLabel = UILabel()
		failLabel.font = UIFont.preferredFont(forTextStyle: .headline)
		failLabel.text = "Recording failed: please ensure the app has access to your microphone."
		failLabel.numberOfLines = 0
		stackView.addArrangedSubview(failLabel)
		
	}
	
	override func loadView() {
		super.loadView()
		
		view.backgroundColor = UIColor.blue
		
		stackView = UIStackView()
		stackView.spacing = 30
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = UIStackViewDistribution.fillEqually
		stackView.alignment = .center
		stackView.axis = .vertical
		view.addSubview(stackView)
		
		stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  
	}
	
	class func getDocumentsDirectory() -> URL {
		
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let documentsDirectory = paths[0]
		return documentsDirectory
		
	}
	
	class func getWhistleURL() -> URL {
		
		return getDocumentsDirectory().appendingPathComponent("whistle.m4a")
		
	}
	
	func startRecording() {
		
		view.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)
		
		recordButton.setTitle("Tap to stop", for: .normal)
		
		let audioURL = RecordWhistleViewController.getWhistleURL()
		print(audioURL.absoluteString)
		
		let settings = [
			AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
			AVSampleRateKey: 12000,
			AVNumberOfChannelsKey: 1,
			AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
		
		]
		
		do {
			whistleRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
			whistleRecorder.delegate = self
			whistleRecorder.record()
			
		} catch {
			
			finishRecording(success: false)
		}
	
	}
	
	func finishRecording(success: Bool) {
		
		view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
		
		whistleRecorder.stop()
		whistleRecorder = nil
		
		if success {
			
			recordButton.setTitle("Tap to Re-record", for: .normal)
			
			if playButton.isHidden {
				UIView.animate(withDuration: 0.35) { [unowned self] in
					self.playButton.isHidden = false
					self.playButton.alpha = 1
				}
			}
			
			
			navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: nil, action: #selector(nextTapped))
		
		} else {
			
			recordButton.setTitle("Tap to Record", for: .normal)
			
			let ac = UIAlertController(title: "Record failed", message: "There was a problem recording your whistle; please try again", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			present(ac, animated:  true)
			
		}
	}
	
	func nextTapped() {
		
	}
	
	func recordTapped() {
		
		if whistleRecorder == nil {
			startRecording()
			
			if !playButton.isHidden {
				UIView.animate(withDuration: 0.35) { [unowned self] in
					self.playButton.isHidden = true
					self.playButton.alpha = 0
				}
			}
			
		} else {
			
			finishRecording(success: true)
		}
	}
	
	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
		
		if !flag {
			finishRecording(success: false)
		}
	}
	
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
