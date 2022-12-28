//
//  SoundPlayer.swift
//  Devote
//
//  Created by Anastasia Karunos on 11/2/22.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        print("I am trying")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
            print("played sound\(sound).\(type)")
        }
        catch {
            print("Couldn't find and play sound file.")
        }
    }
}
