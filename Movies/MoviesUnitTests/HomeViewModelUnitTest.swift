//
//  MoviesTestsTest.swift
//  MoviesTestsTest
//
//  Created by Olga Sabadina on 09.02.2024.
//

import Quick
import Nimble
@testable import Movies

class HomeViewModelSpec: QuickSpec {
    
    override class func spec() {
        
        describe("HomeViewModel") {
            var homeViewModel: HomeViewModel!
            
            
            beforeEach {
                
                homeViewModel = HomeViewModel(NetworkManager())
            }
            
            context("when initializing") {
                it("should initialize properly") {
                    expect(homeViewModel.error).to(beNil())
                    expect(homeViewModel.shouldReloadCollection) == false
                }
            }
            
            context("when fatch popular movies") {
                it("should return the popular movies array successfully") {
                    
                    expect(homeViewModel.popularMoviesArray.count).toEventually(beGreaterThan(0))
                    expect(homeViewModel.error).toEventually(beNil())
                    expect(homeViewModel.shouldReloadCollection) == true
                }
            }
            
            context("when fatch free to watch movies") {
                it("should return the free to watch (upcoming) movies array successfully") {
                    
                    expect(homeViewModel.upcomingMoviesArray.count).toEventually(beGreaterThan(0))
                    expect(homeViewModel.error).toEventually(beNil())
                    expect(homeViewModel.shouldReloadCollection) == true
                }
            }
            
            context("when fetch latest movies") {
                it("should return the latest (now playing) movies array successfully") {
                    expect(homeViewModel.latestMoviesArray.count).toEventually(beGreaterThan(0))
                    expect(homeViewModel.error).toEventually(beNil())
                    expect(homeViewModel.shouldReloadCollection) == true
                }
            }
            
            context("when fetch trending movies") {
                it("should return the trending movies array successfully") {
                    expect(homeViewModel.trendingMoviesArray.count).toEventually(beGreaterThan(0))
                    expect(homeViewModel.error).toEventually(beNil())
                    expect(homeViewModel.shouldReloadCollection) == true
                }
            }
            
        }
    }
}
