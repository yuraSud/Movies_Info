//
//  DetailViewModelTest.swift
//  MoviesTestsTest
//
//  Created by Olga Sabadina on 11.02.2024.
//

import Quick
import Nimble
@testable import Movies

class DetailViewModelSpec: QuickSpec {
    
    override class func spec() {

        describe("DetailViewModel") {
            var detailViewModel: DetailViewModel?
            
            beforeEach {
                let movieCellModelForTest = MovieCellModel(imageUrl: "https://image.tmdb.org/t/p/original/zVMyvNowgbsBAL6O6esWfRpAcOb.jpg?api_key=4eefc1a2e5e226c9176fb1fc2cd2a9d1", title: "Badland Hunters", percent: 68, idMovie: 933131, releaseData: "2024-01-26")
                detailViewModel = DetailViewModel(model: movieCellModelForTest)
            }
            
            context("when initializing") {
                it("should initialize testing parametrs") {
                    expect(detailViewModel?.isLoadData) == false
                    expect(detailViewModel?.error).to(beNil())
                    expect(detailViewModel?.castArray).to(beEmpty())
                    expect(detailViewModel?.mediaSection).to(beEmpty())
                    expect(detailViewModel).toNot(beNil())
                }
            }
            
            context("after initializing") {
                it("test that array of CastActers not be empty") {
                    expect(detailViewModel?.isLoadData).toEventually(beTrue(), timeout: .seconds(5))
                    expect(detailViewModel?.castArray.count).toEventually(beGreaterThan(1))
                    expect(detailViewModel?.castArray.count).toEventually(beLessThan(25))                
                }
            }
            
            context("test fetchRecommendationMovies") {
                it("array of recommendations movies not be empty") {
                    detailViewModel?.fetchRecommendationMovies()
                    
                    expect(detailViewModel?.isLoadData).toEventually(beTrue(), timeout: .seconds(5))
                   
                    expect(detailViewModel?.recommendations.count).toEventually(beGreaterThan(1))
                    expect(detailViewModel?.recommendations.count).toEventually(beLessThan(35))
                }
            }
        }
    }
}
