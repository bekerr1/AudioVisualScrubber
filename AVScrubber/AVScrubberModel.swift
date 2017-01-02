//
//  AVScrubberModel.swift
//  AVScrubber
//
//  Created by brendan kerr on 12/26/16.
//  Copyright © 2016 Vetch. All rights reserved.
//


/*
 What i want to do is
 
*/

import UIKit
import Foundation
import AVFoundation
import Accelerate


struct AVSampleProcessingModel {
    
    var bufferCap: AVAudioFrameCount = 7056
    var noiseFloor: Float = -40
    let realSeconds: Int!
    let screenPts: CGFloat!
    let screenPtPerRealSecond: Double!
    var samplesPerScreenPt: Double!
    var processedData: [Float]!
    
    ///Screen Pts and Real Seconds will be translated into ScreenPts / RealSecond.  Represents how many screen pts will be utilized for each second of audio.
    init?(screenPts pts: CGFloat, realSeconds sec: Int, audioSource src: URL?) {
        screenPts = pts
        realSeconds = sec
        screenPtPerRealSecond = Double(screenPts) / Double(realSeconds)
        
        if let url = src {
            do {
                let audioFile = try AVAudioFile(forReading: url)
                samplesPerScreenPt = (audioFile.processingFormat.sampleRate * Double(audioFile.processingFormat.channelCount)) / screenPtPerRealSecond
                bufferCap = AVAudioFrameCount(samplesPerScreenPt) * AVAudioFrameCount(2.0)
                processedData = iterateBufferData(audioFile)
                print("Audio processed - data set in model.")
            } catch {
                print("Invlaid URL for audio file.")
                return nil
            }
        }
    }
    
    ///Screen Pts and Real Seconds will be translated into ScreenPts / RealSecond.  Represents how many screen pts will be utilized for each second of audio.
    init(screenPts pts: CGFloat, realSeconds sec: Int) {
        screenPts = pts
        realSeconds = sec
        screenPtPerRealSecond = Double(screenPts) / Double(realSeconds)
    }

    
    func drawSamples(using frame: CGRect) -> AVSamplesView {
        return AVSamplesView(withSamples: processedData, referenceFrame: frame)
    }
    
    mutating func processAudioData(_ url: URL) -> Bool {
        
        do {
            let audioFile = try AVAudioFile(forReading: url)
            samplesPerScreenPt = (audioFile.processingFormat.sampleRate * Double(audioFile.processingFormat.channelCount)) / screenPtPerRealSecond
            bufferCap = AVAudioFrameCount(samplesPerScreenPt) * AVAudioFrameCount(2.0)
            processedData = iterateBufferData(audioFile)
            print("Audio processed - data set in model.")
            return true
        } catch {
            print("Invlaid URL for audio file.")
        }
        return false
    }
    
    mutating func iterateBufferData(_ audioFile: AVAudioFile) -> [Float] {
        
        var nextDataOffset = 0
        let pFormat = audioFile.processingFormat
        let pcmBuffer: AVAudioPCMBuffer = AVAudioPCMBuffer(pcmFormat: pFormat, frameCapacity: bufferCap)
        var frameCount = audioFile.length
        let totalSamplesKept = calculateSamplesToKeep(audioFile)
        var samplesArray: [Float] = [Float](repeating: noiseFloor, count: totalSamplesKept)
        while frameCount > 0 {
            let readAmount = (frameCount >= Int64(bufferCap)) ? bufferCap : UInt32(frameCount)
            do {
                
                try audioFile.read(into: pcmBuffer, frameCount: readAmount)
                let sampledLength = parseBufferData(pcmBuffer, &samplesArray, nextDataOffset)
                nextDataOffset += sampledLength
            } catch {
                print("audioFile read error.")
            }
            frameCount -= Int64(bufferCap)
        }
        
        return samplesArray
    }

    mutating func parseBufferData(_ pcmBuffer: AVAudioPCMBuffer, _ output: inout [Float], _ nextDataOffset: Int) -> Int {
        
        let filter = Array<Float>(repeating: Float(1 / samplesPerScreenPt), count: Int(samplesPerScreenPt))
        let samplesThisBuffer = pcmBuffer.frameLength
        var processingBuffer = Array<Float>(repeating: 0.0, count: Int(samplesThisBuffer))
        let sampleCount = vDSP_Length(samplesThisBuffer)
        
        
        if let samples = pcmBuffer.floatChannelData?.pointee {
            //take abs value of each sample
            vDSP_vabs(samples, 1, &processingBuffer, 1, sampleCount)
            
            //This stuff seems sort of optional.  I have samples as float values, after i draw i will decided if i relly need to convert for more acuraccy or if the samples i have now are ok.
            
//            //convert sample to decibels
//            //var zero: Float = 32767.0
//            var zero: Float = 1.0
//            vDSP_vdbcon(processingBuffer, 1, &zero, &processingBuffer, 1, sampleCount, 1)
//            
//            //Clip decibel value to range from noice floor to 0
//            var ceil: Float = 0.0
//            vDSP_vclip(processingBuffer, 1, &noiseFloor, &ceil, &processingBuffer, 1, sampleCount)
            
            
            //Downsample
            //Number of samples to keep after downsampleing - (made samplesThisBuffer a multiple of samplesperscreenpt)
            let downSampleLength = Int(samplesThisBuffer) / Int(samplesPerScreenPt)
            var downSampledData = [Float](repeating: 0.0, count: Int(downSampleLength))
            vDSP_desamp(processingBuffer, vDSP_Stride(samplesPerScreenPt), filter, &downSampledData, vDSP_Length(downSampleLength), vDSP_Length(samplesPerScreenPt))
            
            output[nextDataOffset..<(nextDataOffset + downSampleLength)] = downSampledData[0..<downSampleLength]
            return downSampleLength
            
        }
        print("Couldnt obtain sample data.")
        return 0
    }
    
    
    func calculateSamplesToKeep(_ audioFile: AVAudioFile) -> Int {
        //testAudioProperties(audioFile)
        print("\(audioFile.length), \(Int((1 / samplesPerScreenPt) * Double(audioFile.length)))")
        return Int((1 / samplesPerScreenPt) * Double(audioFile.length))
    }
    
    
    func secondsOfAudio(_ audioFile: AVAudioFile) -> Double {
        return ((Double(audioFile.length) / audioFile.fileFormat.sampleRate))
    }
    
    
    func testAudioProperties(_ audioFile: AVAudioFile) {
        let seconds = secondsOfAudio(audioFile)
        assert(seconds == 45.0)
    }
    
}












