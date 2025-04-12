//
//  SongCollectionViewCell.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 13.04.25.
//

import UIKit
import SnapKit
import Combine
import LoudAIModel

class SongCollectionViewCell: UICollectionViewCell, IReusableView {

    private let playButton = UIButton(type: .system)

    private let titleLabel = UILabel(text: "Tempo",
                                     textColor: .white,
                                     font: UIFont(name: "SFProText-Semibold", size: 16))

    private let slider = UISlider()

    private let deleteButton = UIButton(type: .system)
    private let download = UIButton(type: .system)

    public let deleteTapped = PassthroughSubject<Void, Never>()
    public let downloadTapped = PassthroughSubject<Void, Never>()
    public let valueChanged = PassthroughSubject<Int, Never>()

    var cancellables = Set<AnyCancellable>()

    private let musicPlayer = MusicPlayer()
    private var musicURL = ""

    private var progressTimer: Timer?

    private var songState: SongState = .stopped {
        willSet {
            if newValue == .playing {
                playButton.setImage(UIImage(named: "stopSong"), for: .normal)
                musicPlayer.playMusic(from: musicURL)
                startProgressTimer()
            } else if newValue == .stopped {
                playButton.setImage(UIImage(named: "playSong"), for: .normal)
                musicPlayer.stopMusic()
                stopProgressTimer()
            } else if newValue == .paused {
                playButton.setImage(UIImage(named: "playSong"), for: .normal)
                musicPlayer.pauseMusic()
                stopProgressTimer()
            } else if newValue == .resumed {
                playButton.setImage(UIImage(named: "stopSong"), for: .normal)
                musicPlayer.resumeMusic()
                startProgressTimer()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
        self.musicPlayer.stopMusic()
    }

    private func setupUI() {
        slider.minimumValue = 0
        slider.maximumValue = 200
        slider.value = 0
        let smallThumb = UIImage(named: "circleImage")?.resizeImage(to: CGSize(width: 12, height: 12))
        slider.setThumbImage(smallThumb, for: .normal)
        slider.minimumTrackTintColor = UIColor(hex: "#4C19DE")
        slider.maximumTrackTintColor = UIColor(hex: "#3B3B3B")

        titleLabel.textAlignment = .left

        deleteButton.setImage(UIImage(named: "songDelete"), for: .normal)
        download.setImage(UIImage(named: "songDownload"), for: .normal)

        playButton.setImage(UIImage(named: "playSong"), for: .normal)

        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        download.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)

        contentView.addSubview(playButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(slider)
        contentView.addSubview(deleteButton)
        contentView.addSubview(download)
        setupConstraints()
    }

    private func setupConstraints() {
        playButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview()
            make.height.width.equalTo(44)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3)
            make.leading.equalTo(playButton.snp.trailing).offset(7)
            make.trailing.equalToSuperview().offset(16)
            make.height.equalTo(18)
        }

        download.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.height.equalTo(20)
        }

        deleteButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalTo(download.snp.leading).offset(-8)
            make.width.height.equalTo(20)
        }

        slider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(playButton.snp.trailing).offset(7)
            make.trailing.equalTo(deleteButton.snp.leading).offset(-16)
            make.height.equalTo(4)
        }
    }

    @objc private func sliderValueChanged() {
        let value = Int(slider.value)
        musicPlayer.seek(to: TimeInterval(value))
        valueChanged.send(Int(slider.value))
    }

    @objc private func deleteButtonTapped() {
        deleteTapped.send()
    }

    @objc private func downloadButtonTapped() {
        downloadTapped.send()
    }

    public func configure(with value: Float) {
        slider.setValue(value, animated: false)
        sliderValueChanged()
    }

    private func startProgressTimer() {
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let currentTime = self.musicPlayer.currentTime()
            self.slider.value = Float(currentTime)
        }
    }

    private func stopProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
    }

    func configure(with model: LoadedMusicModel) {
        self.titleLabel.text = model.title
        self.musicURL = model.musicURL
    }

    @objc private func playButtonTapped() {
        switch songState {
        case .stopped:
            self.songState = .playing
        case .playing:
            self.songState = .paused
        case .paused:
            self.songState = .resumed
        case .resumed:
            self.songState = .paused
        }
    }
}

enum SongState {
    case stopped
    case playing
    case paused
    case resumed
}
