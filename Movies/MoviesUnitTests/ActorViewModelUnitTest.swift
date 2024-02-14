//
//  ActorViewModelTest.swift
//  MoviesTestsTest
//
//  Created by Olga Sabadina on 11.02.2024.
//

import Quick
import Nimble
@testable import Movies

class ActorViewModelSpec: QuickSpec {
    
    override class func spec() {
        
        describe("ActorViewModel") {
            var actorViewModel: ActorViewModel?
            
            beforeEach {
                let actorCellModelForTest = MovieCellModel(imageUrl: "https://image.tmdb.org/t/p/original/zt1vx7FesNA4x6mTZtyzu2uco8E.jpg?api_key=4eefc1a2e5e226c9176fb1fc2cd2a9d1", title: "Ma Dong-seok", asHeroInFilm: "Nam-san", genderPersone: "Actor", idPersone: 1024395)
                actorViewModel = ActorViewModel(model: actorCellModelForTest)
                
            }
            
            context("when initializing") {
                it("should initialize testing parametrs") {
                    expect(actorViewModel?.shouldReload) == false
                    expect(actorViewModel?.recommendationsArray).to(beEmpty())
                    expect(actorViewModel?.actingArray).to(beEmpty())
                    expect(actorViewModel).toNot(beNil())
                }
            }
            
            context("after initializing") {
                it("test that array of recommendationsArray not be empty") {
                    expect(actorViewModel?.shouldReload).toEventually(beTrue(), timeout: .seconds(5))
                    
                    expect(actorViewModel?.recommendationsArray.count).toEventually(beGreaterThan(1))
                    expect(actorViewModel?.recommendationsArray.count).toEventually(beLessThan(100))
                }
            }
            
            context("after initializing") {
                it("test that array of actingArray not be empty") {
                    expect(actorViewModel?.shouldReload).toEventually(beTrue(), timeout: .seconds(5))
                    expect(actorViewModel?.actingArray.count).toEventually(beGreaterThan(1))
                    expect(actorViewModel?.actingArray.count).toEventually(beLessThan(100))
                }
            }
        }
    }
}
