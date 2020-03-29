//
//  MeaningViewController.swift
//  Translate
//
//  Created by Stanislav Ivanov on 29.03.2020.
//  Copyright © 2020 Stanislav Ivanov. All rights reserved.
//

import UIKit
import AVFoundation

final class MeaningViewController: BaseViewController {
    
    // MARK: Init
    
    init(word: Word, meaning: Meaning) {
        self.meaning = meaning
        self.word = word
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Properties
    
    private let meaning: Meaning
    private let word: Word
    
    private var player: AVPlayer?
    private let imagesDataStore = ImagesDataStore()
    
    private weak var imageView:        UIImageView?
    private weak var playButton:       UIButton?
    private weak var wordLabel:        UILabel?
    private weak var translationLabel: UILabel?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wordLabel?.text = self.word.text
        self.translationLabel?.text = self.meaning.translation.text
        
        if let previewUrl = self.meaning.previewUrl {
            self.imagesDataStore.downloadImage(link: previewUrl) { [weak self] (pathToLocalImage) in
                guard let self = self else { return }
                guard let pathToLocalImage = pathToLocalImage else { return }
                guard let image = UIImage(contentsOfFile: pathToLocalImage) else { return }
                self.imageView?.image = image
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let frame = self.realFrame()
        let offset: CGFloat = 20
        
        let imageViewSide: CGFloat = 100
        self.imageView?.frame = CGRect(x: frame.origin.x + offset,
                                       y: frame.origin.y + offset,
                                       width: imageViewSide,
                                       height: imageViewSide)
        self.playButton?.frame = self.imageView?.frame ?? CGRect.zero
        
        let wordLabelX: CGFloat = offset + frame.origin.x + imageViewSide
        let wordLabelWidth = frame.width - wordLabelX - offset
        self.wordLabel?.frame = CGRect(x: wordLabelX,
                                       y: frame.origin.y + offset,
                                       width: wordLabelWidth,
                                       height: imageViewSide)
        
        let translationLabelY = offset + frame.origin.y + imageViewSide + offset
        let translationLabelHeight = self.view.frame.size.height - translationLabelY - offset
        self.translationLabel?.frame = CGRect(x: frame.origin.x + offset,
                                              y: translationLabelY,
                                              width: frame.size.width - offset * 2,
                                              height: translationLabelHeight)
    }
}

// MARK: - Override
extension MeaningViewController {
    
    override func addSubviews() {
        super.addSubviews()
        
        if nil == self.imageView {
            let view = UIImageView()
            self.view.addSubview(view)
            self.imageView = view
            
            view.contentMode = .scaleAspectFill
            view.clipsToBounds = true
        }
        
        if nil == self.playButton {
            let view = UIButton(type: .custom)
            self.view.addSubview(view)
            self.playButton = view
            
            view.setImage(UIImage(named: "btn_play"), for: .normal)
            view.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        }
        
        if nil == self.wordLabel {
            let view = UILabel()
            self.view.addSubview(view)
            self.wordLabel = view
            
            view.textAlignment = .center
            view.numberOfLines = 0
            view.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        }
        
        if nil == self.translationLabel {
            let view = UILabel()
            self.view.addSubview(view)
            self.translationLabel = view
            
            view.textAlignment = .center
            view.numberOfLines = 0
            view.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        }
    }
}

// MARK: - Action
extension MeaningViewController {
    
    @objc private func playButtonAction() {
        guard let url = self.url(string: self.meaning.soundUrl) else {
            return
        }
        
        self.playSound(url: url)
    }
    
    private func playSound(url: URL) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            let asset = AVURLAsset(url: url)
            let item = AVPlayerItem(asset: asset)
            let player = AVPlayer(playerItem: item)
            player.play()
            self.player = player
        } catch {
            #if DEBUG
            fatalError("Exception \(#file) \(#function) \(#line) \(error)")
            #else
            debugPrint("Exception \(#file) \(#function) \(#line) \(error)")
            #endif
        }
    }
    
    private func url(string: String?) -> URL? {
        guard let string = string else { return nil }
        if string.isEmpty { return nil }
        
        var fullLink = string
        if false == fullLink.contains("https") {
            fullLink = "https:" + string
        }
        
        guard let encodedLink = fullLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else  { return nil }
        
        return URL(string: encodedLink)
    }
}

