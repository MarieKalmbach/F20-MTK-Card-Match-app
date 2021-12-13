//
//  SoundManager.swift
//  MTK - MATCHING - 3
//
//  Created by BPSTIL - Swift - Mrs. K on 11/20/20.
//  Copyright © 2020 Kalmbach. All rights reserved.
//

import Foundation

import AVFoundation

class SoundManager
{
    var audioPlayer: AVAudioPlayer?
    
    enum SoundEffect
    {
        case flip
        case match
        case noMatch
        case shuffle
    }
    
    func playSound(effect:SoundEffect)
    {
        // initialize name of sound file
        //
        var soundFileName = ""
        
        // create the correct sound file name
        //
        switch effect
        {
            case .flip:
                soundFileName = "cardflip"
                
            case .match:
                soundFileName = "dingcorrect"
                
            case .noMatch:
                soundFileName = "dingwrong"
                
            case .shuffle:
                soundFileName = "shuffle"
        }
        
        // find path name of where sound file exists within app bundle
        //
        let bundlePath = Bundle.main.path(forResource: soundFileName,
                                               ofType: ".wav")
        
        // make sure bundle path is NOT nil before proceeding
        //
        guard
            bundlePath != nil
        else
        {
            return  // exit early bundlePath was NOT found
        }
        
        // create URL object containing bundlePath
        //
        let url = URL(fileURLWithPath: bundlePath!)
        
        // Create an audio player object with this url,
        // making sure to handle any errors that might be thrown.
        //
        do
        {
            // try to create the audio player
            //
            audioPlayer = try AVAudioPlayer(contentsOf:url)
            
            // since no error occured, go ahead and play sound effect
            //
            audioPlayer?.play()
            
        }
        catch  // any errors thrown when creating audio player
        {
            print("NOT able to create an audio player")
            
            return  // exit immediately
        }
         
        
    }//end of playSound() method
    
}//end of SoundManager class
