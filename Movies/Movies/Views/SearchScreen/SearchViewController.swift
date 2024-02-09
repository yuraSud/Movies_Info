//
//  SearchViewController.swift
//  Movies
//
//  Created by Olga Sabadina on 05.01.2024.
//

import AsyncDisplayKit
import Combine

class SearchViewController: ASDKViewController<ASDisplayNode> {

    var isSearch: Bool = false {
        didSet {
            reload(isSearch: isSearch)
        }
    }
    
    private var tableSearch: SearchTable
    private let viewModel: SearchViewModel
    private var cancellable = Set<AnyCancellable>()
    
    private let rootNode: ASDisplayNode = {
        let root = ASDisplayNode()
        root.automaticallyManagesSubnodes = true
        return root
    }()
    
    override init() {
        tableSearch = SearchTable()
        viewModel = SearchViewModel()
        super.init(node: rootNode)
        node.layoutSpecBlock = {_,_ in
            return ASInsetLayoutSpec(insets: .init(), child: self.tableSearch)
        }
    }
    
    required init?(coder: NSCoder) {
        tableSearch = SearchTable()
        viewModel = SearchViewModel()
        super.init(node: rootNode)
    }
    
    override func loadView() {
        super.loadView()
        setSearchController()
        sinkToIsShouldReloadTable()
        sinkToError()
        navigationItem.backButtonTitle = ""
        tableSearch.openDetailDelegate = self
    }
    
    func reload(isSearch: Bool) {
        tableSearch.typeCell = isSearch ? .short : .full
        tableSearch.sourceDataForTable = isSearch ? viewModel.models: viewModel.trendingArray
    }
    
    private func setSearchController() {
        let searchController = UISearchController()
        navigationItem.searchController = searchController
        searchController.searchBar.searchTextField.backgroundColor = .secondarySystemBackground
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = true
        title = "Search VC"
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .systemBackground
    }
    
    private func sinkToIsShouldReloadTable() {
        viewModel.$isShouldReloadTable
            .receive(on: DispatchQueue.main)
            .sink { isReload in
                if isReload {
                    self.reload(isSearch: self.isSearch)
                }
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

extension SearchViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if searchText.count >= 1 {
            isSearch = true
            viewModel.findMovies(keyWord: searchText)
        } else{
            isSearch = false
        }
    }
}

extension SearchViewController: DetailMovieDelegateProtocol {
    func openDetailScreen(_ model: MovieCellModel) {
        let vc = DetailsViewController(model: model)
        navigationController?.pushViewController(vc, animated: true)
    }
}
