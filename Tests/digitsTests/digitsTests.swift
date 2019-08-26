import XCTest
import digits

final class digitsTests: XCTestCase {
    func testIncrement() {
        var b = List<Digit>.zero
        b = b.incremented()
        XCTAssertEqual(b, List<Digit>.build(.one))
        b = b.incremented()
        XCTAssertEqual(b, List<Digit>.build(.zero, .one))
        b = b.incremented()
        XCTAssertEqual(b, List<Digit>.build(.one, .one))
        b = b.incremented()
        XCTAssertEqual(b, List<Digit>.build(.zero, .zero, .one))
        b = b.incremented()
        XCTAssertEqual(b, List<Digit>.build(.one, .zero, .one))
        b = b.incremented()
        XCTAssertEqual(b, List<Digit>.build(.zero, .one, .one))
        b = b.incremented()
        XCTAssertEqual(b, List<Digit>.build(.one, .one, .one))
        b = b.incremented()
        XCTAssertEqual(b, List<Digit>.build(.zero, .zero, .zero, .one))
    }
    
    func testReversedExact() {
        let b = Number.build(.one, .zero, .zero, .one, .zero, .one)
        let reversed = Number.build(.one, .zero, .one, .zero, .zero, .one)
        XCTAssertEqual(b.reversed(), reversed)
    }
    
    func testReversedExtraZeros() {
        let b = Number.build(.one, .zero, .zero, .one, .zero, .one)
        let bPadded = Number.build(.zero, .zero, .zero, .one, .zero, .zero, .one, .zero, .one)
        
        let reversed = Number.build(.one, .zero, .one, .zero, .zero, .one)
        let reversedPadded = Number.build(.one, .zero, .one, .zero, .zero, .one, .zero, .zero, .zero)
        
        XCTAssertEqual(bPadded.reversed(), reversed)
        XCTAssertEqual(b.reversed(), reversedPadded)
        XCTAssertEqual(bPadded.reversed(), reversedPadded)
    }
    
    func testBuildInteger() {
        var b = Number.empty
        for ix in 0...100 {
            XCTAssertEqual(b, Number.build(ix), "bad build for: \(ix)")
            XCTAssertEqual(b.description, Number.build(ix).description, "bad description for: \(ix)")
            b = b.incremented()
        }
    }
    
    func testAddition() {
        for ix in 0...20 {
            for iy in 0...20 {
                let sum = Number.build(ix) + Number.build(iy)
                XCTAssertEqual(sum, Number.build(ix + iy), "\(ix) + \(iy) != \(sum)")
            }
        }
    }
    
    func testMultiplication() {
        for ix in 0...20 {
            for iy in 0...20 {
                let product = Number.build(ix) * Number.build(iy)
                XCTAssertEqual(product, Number.build(ix * iy), "\(ix) * \(iy) != \(product)")
            }
        }
    }
    
    func testInequality() {
        let max = 30
        for ix in 0...max {
            for iy in (ix+1)...(max + 1) {
                let x = Number.build(ix)
                let y = Number.build(iy)
                XCTAssertTrue(x < y)
                XCTAssertFalse(y < x)
            }
        }
    }

    static var allTests: [(String, () -> ())] = []
}
