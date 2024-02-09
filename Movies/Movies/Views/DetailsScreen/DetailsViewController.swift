//
//  DetailsViewController.swift
//  Movies
//
//  Created by Olga Sabadina on 23.02.2024.
//

import AsyncDisplayKit
import AVKit
import AVFoundation
import Combine

class DetailsViewController: ASDKViewController<ASScrollNode> {
    
    private let rootNode: ASScrollNode = {
       let rootNode = ASScrollNode()
        rootNode.automaticallyManagesSubnodes = true
        rootNode.backgroundColor = .white
        rootNode.scrollableDirections = [.down, .up]
        rootNode.automaticallyManagesContentSize = true
        rootNode.automaticallyRelayoutOnSafeAreaChanges = true
        rootNode.insetsLayoutMarginsFromSafeArea = true
        return rootNode
    }()
    
    private let viewModel: DetailViewModel
    private var mainMovieSection: MainMovieSection
    private var seriesCastSection: SeriesCastSection
    private let currentSeasonSection: CurrentSeasonTableSection
    private let socialsSection: SocialTable
    private var mediaSection: MediaSectionNode
    private var recomendationSection: RecomendationSection
    private var cancellable = Set<AnyCancellable>()
    
    init(model: MovieCellModel = .init(imageUrl: "", title: "Empty")) {
        self.viewModel = DetailViewModel(model: model)
        mainMovieSection = MainMovieSection()
        seriesCastSection = SeriesCastSection()
        currentSeasonSection = CurrentSeasonTableSection(movies: mocDataForCurrentSeasonSection , sectionTitle: "Current Season")
        socialsSection = SocialTable(socials: mocForSocialSection)
        mediaSection = MediaSectionNode()
        recomendationSection = RecomendationSection()
        super.init(node: rootNode)

        title = viewModel.model.title
        
        rootNode.layoutSpecBlock = { _,_ -> ASLayoutSpec in
    
            return ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .stretch, children: [
                self.mainMovieSection,
                self.seriesCastSection,
                self.currentSeasonSection,
                self.socialsSection,
                self.mediaSection,
                self.recomendationSection
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        seriesCastSection.collectionActor.openActorInfoDelegate = self
        sinkToProperties()
        sinkToError()
    }
    
    private func playVideo() {
        mediaSection.completionAction = { id in
            let vc = VideoViewController(movieID: id)
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.present(vc, animated: true)
        }
    }
    
    private func sinkToProperties() {
        viewModel.$isLoadData
            .receive(on: DispatchQueue.main)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { isLoad in
                self.mainMovieSection = MainMovieSection(headerData: self.viewModel.headerData)
                self.seriesCastSection = SeriesCastSection(typeBtn: .simple, sectionData: self.viewModel.castArray, delegate: self)
                self.recomendationSection = RecomendationSection(movies: self.viewModel.recommendations, delegate: self)
                self.mediaSection = MediaSectionNode(media: self.viewModel.mediaSection)
                self.playVideo()
                self.rootNode.setNeedsLayout()
            }
            .store(in: &cancellable)
    }
    
    private func sinkToError() {
        viewModel.$error
            .filter{$0 != nil}
            .sink { error in
                self.alertError(error)
            }
            .store(in: &cancellable)
    }
}

extension DetailsViewController: ActorInfoProtocol {
    func didOpenActorInfo(_ actor: MovieCellModel) {
        navigationItem.backButtonTitle = ""
        let actorVC = ActorsViewController(actorModel: actor)
        navigationController?.pushViewController(actorVC, animated: true)
    }
}

extension DetailsViewController: PlayVideoProtocol {
    func didTapPlayButton() {
        viewModel.fetchVideoUrl { youtubeId in
        
            if let youtubeURL = URL(string: "youtube://\(youtubeId)"),
               UIApplication.shared.canOpenURL(youtubeURL) {
                UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
            } else if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(youtubeId)") {
                UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
            }
        }
    }
}

extension DetailsViewController: DetailMovieDelegateProtocol {
    func openDetailScreen(_ model: MovieCellModel) {
        let vc = DetailsViewController(model: model)
        navigationController?.pushViewController(vc, animated: true)
    }
}

