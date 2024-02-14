//
//  SearchViewModelTest.swift
//  MoviesTestsTest
//
//  Created by Olga Sabadina on 11.02.2024.
//

import Quick
import Nimble
@testable import Movies

class SearchViewModelSpec: QuickSpec {
    
    override class func spec() {
        
        describe("SearchViewModel") {
            var searchViewModel: SearchViewModel?
            
            beforeEach {
                searchViewModel = SearchViewModel()
            }
            
            context("when initializing") {
                it("should initialize testing parametrs") {
                    expect(searchViewModel?.isShouldReloadTable) == false
                    expect(searchViewModel?.error).to(beNil())
                    expect(searchViewModel?.trendingArray).to(beEmpty())
                    expect(searchViewModel?.models).to(beEmpty())
                    expect(searchViewModel).toNot(beNil())
                }
            }
            
            context("after initializing") {
                it("test that array of trendingArray not be empty") {
                    expect(searchViewModel?.isShouldReloadTable).toEventually(beTrue(), timeout: .seconds(5))
                    
                    expect(searchViewModel?.trendingArray.count).toEventually(beGreaterThanOrEqualTo(1))
                    expect(searchViewModel?.trendingArray.count).toEventually(beLessThan(20))
                }
            }
            
            context("after initializing finding") {
                it("test that array of models not be empty") {
                    searchViewModel?.findMovies(keyWord: "aqua")
                    
                    expect(searchViewModel?.isShouldReloadTable).toEventually(beTrue(), timeout: .seconds(5))
                    
                    expect(searchViewModel?.models.count).toEventually(beGreaterThanOrEqualTo(1))
                    expect(searchViewModel?.models.count).toEventually(beLessThan(20))
                }
            }
            
            
        }
    }
}

