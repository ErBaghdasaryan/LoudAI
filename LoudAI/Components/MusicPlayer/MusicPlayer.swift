//
//  MusicPlayer.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 13.04.25.
//

import AVFoundation

public class MusicPlayer {
    private var player: AVPlayer?
    private var isPaused: Bool = false

    func playMusic(from urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }

        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        isPaused = false
    }

    func pauseMusic() {
        guard let player = player, player.timeControlStatus == .playing else {
            return
        }
        player.pause()
        isPaused = true
    }

    func resumeMusic() {
        guard let player = player, isPaused else {
            return
        }
        player.play()
        isPaused = false
    }

    func stopMusic() {
        guard let player = player else { return }
        player.pause()
        self.player = nil
        isPaused = false
    }

    func currentTime() -> TimeInterval {
        guard let current = player?.currentTime() else { return 0 }
        return CMTimeGetSeconds(current)
    }

    func seek(to time: TimeInterval) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 1)
        player?.seek(to: cmTime)
    }
}
