//
//  MTRDataManagerTests.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import Nimble
import Quick
import AERecord
import CoreData

@testable import Metar

class MTRFakeDataManager: MTRDataManager {

    override init() {
        let model = AERecord.modelFromBundle(forClass: MTRDataManagerTests.self)
        do {
            try AERecord.loadCoreDataStack(managedObjectModel: model, storeType: NSInMemoryStoreType)
        } catch _ {
            print("💣 Initializing memory data store failed.")
        }
        super.init()
    }

    func buildMetar(withName name: String) -> Metar {
        let metar = Metar(raw: "")
        metar.station.name = name
        return metar
    }

}

class MTRDataManagerTests: QuickSpec {

    override func spec() {
        var dataManager: MTRFakeDataManager!
        
        beforeEach {
            dataManager = MTRFakeDataManager()
            MTRAirport.deleteAll()
        }

        context("Creation") {
            it("should be empty.") {
                expect(dataManager.airports()).to(beEmpty())
            }

            it("should not create the airport.") {
                dataManager.create(withMetar: Metar(raw: ""))

                expect(dataManager.airports()).to(beEmpty())
            }

            it("should have one airports.") {
                dataManager.create(withMetar: dataManager.buildMetar(withName: "test"))
                dataManager.create(withMetar: dataManager.buildMetar(withName: "test"))

                expect(dataManager.airports().count).to(equal(1))
            }

            it("should have two airports.") {
                dataManager.create(withMetar: dataManager.buildMetar(withName: "test 1"))
                dataManager.create(withMetar: dataManager.buildMetar(withName: "test 2"))

                expect(dataManager.airports().count).to(equal(2))
            }
        }

        context("Removal") {
            it("should remove the airport.") {
                let airport = dataManager.create(withMetar: dataManager.buildMetar(withName: "test 1"))!
                expect(dataManager.airports().count).to(equal(1))

                dataManager.remove(airport: airport)
                expect(dataManager.airports().count).to(equal(0))
            }

            it("should notr remove the airport related to the metar.") {
                dataManager.create(withMetar: dataManager.buildMetar(withName: "test 1"))
                expect(dataManager.airports().count).to(equal(1))

                let metar = dataManager.buildMetar(withName: "test 2")
                dataManager.remove(metar: metar)
                expect(dataManager.airports().count).to(equal(1))
            }

            it("should remove the airport related to the metar.") {
                let metar = dataManager.buildMetar(withName: "test")
                dataManager.create(withMetar: metar)
                expect(dataManager.airports().count).to(equal(1))

                dataManager.remove(metar: metar)
                expect(dataManager.airports().count).to(equal(0))
            }
        }

        context("Finders") {
            it("should not find an airport.") {
                let metar = Metar(raw: "")
                expect(dataManager.airport(forMetar: metar)).to(beNil())
            }

            it("should find an airport.") {
                let metar = Metar(raw: "")
                metar.station.name = "test"
                dataManager.create(withMetar: metar)

                expect(dataManager.airport(forMetar: metar)).toNot(beNil())
            }

            it("should an airport not exist.") {
                let metar = Metar(raw: "")
                expect(dataManager.exists(metar: metar)).to(beFalse())
            }

            it("should an airport exist.") {
                let metar = Metar(raw: "")
                metar.station.name = "test"
                dataManager.create(withMetar: metar)

                expect(dataManager.exists(metar: metar)).to(beTrue())
            }

            it("should find two airports.") {
                let airportOne = dataManager.create(withMetar: dataManager.buildMetar(withName: "test 1"))
                let airportTwo = dataManager.create(withMetar: dataManager.buildMetar(withName: "test 2"))

                expect(dataManager.airports().first).to(equal(airportOne))
                expect(dataManager.airports().last).to(equal(airportTwo))
            }
        }
    }

}