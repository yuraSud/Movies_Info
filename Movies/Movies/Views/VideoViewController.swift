//
//  VideoViewController.swift
//  Movies
//
//  Created by Olga Sabadina on 04.02.2024.
//

import YouTubePlayer
import UIKit
import Combine

class VideoViewController: UIViewController {
    
    let youTubePlayer = YouTubePlayerView()
    let movieID: Int
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchKeyVideoAndPlayVideo()
    }
    
    init(movieID: Int) {
        self.movieID = movieID
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setPlayer() {
        view.addSubview(youTubePlayer)
        youTubePlayer.delegate = self
        youTubePlayer.frame = view.bounds
        
        let closeAction = UIAction { _ in
            self.dismiss(animated: true)
        }
        
        let closeBtn = UIButton(frame: .init(x: 20, y: 60, width: 35, height: 35), primaryAction: closeAction)
        view.addSubview(closeBtn)
        closeBtn.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        closeBtn.tintColor = .white
    }
    
    func fetchKeyVideoAndPlayVideo() {
        fetchVideoKey { key in
            self.youTubePlayer.loadVideoID(key)
        }
    }
    
    private func fetchVideoKey(completion: @escaping (String)-> Void) {

        NetworkManager().fetchMovies(urlString: URLBuilder.videoKey(for: movieID), type: VideoModel.self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.alertError(error)
                }
            } receiveValue: { model in
                guard let key = model.results.first?.key else { return }
                completion(key)
            }
            .store(in: &cancellable)
    }
}

extension VideoViewController: YouTubePlayerDelegate {
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        videoPlayer.play()
    }
}
