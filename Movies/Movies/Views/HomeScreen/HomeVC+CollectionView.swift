//
//  HomeVC+CollectionView.swift
//  Movies
//
//  Created by Olga Sabadina on 09.01.2024.
//

import UIKit

extension HomeViewController {
    
    func setCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        guard let collectionView = collectionView else { return }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CategoriesCell.self, forCellWithReuseIdentifier: CategoriesCell.identCell)
        collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCell.identCell )
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: HomeCell.identCell)
        collectionView.register(LatestTrailersCell.self, forCellWithReuseIdentifier: LatestTrailersCell.identCell)
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
            let sectionType: HomeSectionType = HomeSectionType(rawValue: sectionIndex) ?? .categories
            let isAll = self.homeViewModel.seeAllSectionDictionary[sectionType.segmentKeyForIndex] ?? false
            
            switch sectionType {
            case .categories:
                return self.createCategoriesSection()
            case .popular:
                return self.createImageSection(isAll)
            case .freeWatch:
                return self.createImageSection(isAll)
            case .latestTrailers:
                return self.createlatestTrailersSection(isAll)
            case .trending:
                return self.createImageSection(isAll)
            }
        }
        return layout
    }
    
    private func createCategoriesSection() -> NSCollectionLayoutSection {
        
        let item = CompositionalLayout.createItem(width: .fractionalWidth(0.25), height: .absolute(30), spacing: 10)
        
        let group = CompositionalLayout.createGroupeCount(aligment: .horizontal, width: .fractionalWidth(1), height: .absolute(30), item: item, count: 4)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 16, bottom: 20, trailing: 16)
        return section
    }
    
    private func createImageSection(_ seeAll: Bool = false) -> NSCollectionLayoutSection {
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let itemsGroup: NSCollectionLayoutGroup
        
        if seeAll {
            
            let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(0.5), spacing: 0)
            item.contentInsets.bottom = 10
            let group = CompositionalLayout.createGroupeItems(aligment: .vertical, width: .fractionalWidth(0.38), height: .fractionalHeight((0.68)), items: [item, item])
            
            itemsGroup = group
            
        } else {
            
            let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 0)
            item.contentInsets.bottom = 10
            let group = CompositionalLayout.createGroupeItems(aligment: .vertical, width: .fractionalWidth(0.38), height: .fractionalHeight((0.34)), items: [item])
            
            itemsGroup = group
        }
        
        let section = NSCollectionLayoutSection(group: itemsGroup)
        section.interGroupSpacing = 15
        section.contentInsets = .init(top: 10, leading: 16, bottom: 20, trailing: 16)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func createlatestTrailersSection(_ seeAll: Bool = false) -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(90))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let itemsGroup: NSCollectionLayoutGroup
        
        if seeAll {
            
            let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(0.5), spacing: 0)
            item.contentInsets.bottom = 10
            let group = CompositionalLayout.createGroupeItems(aligment: .vertical, width: .fractionalWidth(0.65), height: .fractionalHeight((0.5)), items: [item, item])
            
            itemsGroup = group
            
        } else {
            
            let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 0)
            item.contentInsets.bottom = 10
            let group = CompositionalLayout.createGroupeItems(aligment: .vertical, width: .fractionalWidth(0.65), height: .fractionalHeight((0.25)), items: [item])
            
            itemsGroup = group
        }
        
        let section = NSCollectionLayoutSection(group: itemsGroup)
        section.interGroupSpacing = 15
        section.contentInsets = .init(top: 10, leading: 16, bottom: 20, trailing: 16)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
}

//  MARK: - CollectionViewDelegate,DataSours:

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        homeViewModel.nuberOfSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        homeViewModel.numberItemsInSections(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let sectionType = HomeSectionType(rawValue: indexPath.section)
        
        switch sectionType {
            
        case .categories:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCell.identCell, for: indexPath) as? CategoriesCell else { return UICollectionViewCell()}
            cell.categoriesButton.text = HomeSectionType.categoriesTitle[indexPath.item]
            return cell
            
        case .popular:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.identCell, for: indexPath) as? HomeCell else { return UICollectionViewCell()}
            cell.model = homeViewModel.popularMoviesArray[indexPath.item]
            return cell
            
        case .freeWatch:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.identCell, for: indexPath) as? HomeCell else { return UICollectionViewCell()}
            cell.model = homeViewModel.upcomingMoviesArray[indexPath.item]
            return cell
            
        case .latestTrailers:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LatestTrailersCell.identCell, for: indexPath) as? LatestTrailersCell else { return UICollectionViewCell()}
            cell.model = homeViewModel.latestMoviesArray[indexPath.item]
            return cell
            
        case .trending:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.identCell, for: indexPath) as? HomeCell else { return UICollectionViewCell()}
            cell.model = homeViewModel.trendingMoviesArray[indexPath.item]
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionType: HomeSectionType = HomeSectionType(rawValue: indexPath.section) ?? .categories
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCell.identCell, for: indexPath) as? HeaderCell else {return UICollectionReusableView()}
        let index = homeViewModel.segmentSectionsIndex[sectionType.segmentKeyForIndex] ?? 0
        header.selectedSegmentIndex = index
        header.sectionType = sectionType
        
        header.actionSeeAll = {
            let isAll = self.homeViewModel.seeAllSectionDictionary[sectionType.segmentKeyForIndex] ?? false
            let newState = isAll ? false : true
            self.homeViewModel.seeAllSectionDictionary[sectionType.segmentKeyForIndex] = newState
            self.homeViewModel.seeAllSectionType = sectionType
            header.isStateSeeAll = newState
            
            self.collectionView?.reloadSections(IndexSet(integer:header.sectionType.rawValue))
        }
        
        header.segmentAction = { index in
            self.homeViewModel.segmentSectionsIndex[sectionType.segmentKeyForIndex] = index
            
            switch header.sectionType {
            case .categories:
                break
            case .popular:
                self.homeViewModel.popularMoviesArray.shuffle()
            case .freeWatch:
                self.homeViewModel.upcomingMoviesArray.shuffle()
            case .latestTrailers:
                self.homeViewModel.latestMoviesArray.shuffle()
            case .trending:
                self.homeViewModel.fetchTrendingMovies(index)
            }
            
            self.collectionView?.reloadSections(IndexSet(integer:header.sectionType.rawValue))
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let sectionType = HomeSectionType(rawValue: indexPath.section) ?? .categories
        
        switch sectionType {
        case .categories:
            break
        case .popular, .freeWatch, .trending:
            guard let cell = collectionView.cellForItem(at: indexPath) as? BaseHomeCell,
                  let model = cell.model
            else { return }
            
            let detailVC = DetailsViewController(model: model)
            navigationController?.pushViewController(detailVC, animated: true)
            
        case .latestTrailers:
            guard let cell = collectionView.cellForItem(at: indexPath) as? BaseHomeCell,
                  let movieID = cell.model?.idMovie
            else { return }
            
            self.playVideo(id: movieID)
        }
    }
    
    private func playVideo(id: Int) {
        let vc = VideoViewController(movieID: id)
        vc.modalPresentationStyle = .fullScreen
        navigationController?.present(vc, animated: true)
    }
}
