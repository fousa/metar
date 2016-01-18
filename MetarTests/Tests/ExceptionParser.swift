import Quick
import Nimble

class ExceptionParser: QuickSpec {

    override func spec() {
        describe("Cloud data") {

            var metar: Metar!
            beforeEach {
                metar = Metar(raw: "LBBG 041600Z 120103MPS 290V310 1400 R04R/P1600 R22/P1500U -SN VV020 BKN022 OVC050 M04/M07 Q1020 NOSIG 9949//91")
                metar.station.name = "LBBG"
                MetarParser(metar: metar).parse()
            }
            
            it("should correctly parse the VV type correcty.") {
                expect(metar.clouds.first!.coverage) == .VerticalVisibility
                expect(metar.clouds.last!.coverage) == .Overcast
            }
            
        }
    }
    
}
