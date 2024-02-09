//
//  ActorsViewController.swift
//  Movies
//
//  Created by Olga Sabadina on 31.01.2024.
//

import AsyncDisplayKit
import AVKit
import AVFoundation
import Combine

class ActorsViewController: ASDKViewController<ASScrollNode> {
    
    private let viewModel: ActorViewModel
    private var cancellable = Set<AnyCancellable>()
    
    private let rootNode: ASScrollNode = {
       let rootNode = ASScrollNode()
        rootNode.automaticallyManagesSubnodes = true
        rootNode.backgroundColor = .white
        rootNode.scrollableDirections = [.down, .up]
        rootNode.automaticallyManagesContentSize = true
        rootNode.automaticallyRelayoutOnSafeAreaChanges = true
        rootNode.insetsLayoutMarginsFromSafeArea = false
        return rootNode
    }()
    
    var actorInfoSection: ActorInfoSection
    var knownForSection: RecomendationSection
    var actingSection: ActingSection
    
    init(actorModel: MovieCellModel) {
        self.viewModel = ActorViewModel(model: actorModel)
        actorInfoSection = ActorInfoSection(model: actorModel)
        knownForSection = RecomendationSection(isRecomendation: false)
        actingSection = ActingSection()
        
        super.init(node: rootNode)
        
        title = actorModel.title
        
        rootNode.layoutSpecBlock = { _,_ -> ASLayoutSpec in

            let headerInset = ASInsetLayoutSpec(insets: .init(top: 0, left: 0, bottom: 8, right: 0), child: self.actorInfoSection)
            
            let result = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .stretch, children: [
                headerInset,
                self.knownForSection,
                self.actingSection
            ])
            
            return result
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        sinkToProperties()
    }
    
    private func sinkToProperties() {
        viewModel.$shouldReload
            .receive(on: DispatchQueue.main)
            .sink { isLoad in
                self.actorInfoSection = ActorInfoSection(model: self.viewModel.model)
                self.knownForSection = RecomendationSection(movies: self.viewModel.recommendationsArray, isRecomendation: false, delegate: self)
                self.actingSection = ActingSection(movies: self.viewModel.actingArray)
                self.actingSection.actingTable.openDetailDelegate = self
                self.rootNode.setNeedsLayout()
            }
            .store(in: &cancellable)
    }
}

extension ActorsViewController: DetailMovieDelegateProtocol {
    func openDetailScreen(_ model: MovieCellModel) {
        let vc = DetailsViewController(model: model)
        navigationController?.pushViewController(vc, animated: true)
    }
}

