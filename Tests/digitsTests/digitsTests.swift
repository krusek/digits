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
        let b = Binary.build(.one, .zero, .zero, .one, .zero, .one)
        let reversed = Binary.build(.one, .zero, .one, .zero, .zero, .one)
        XCTAssertEqual(b.reversed(), reversed)
    }
    
    func testReversedExtraZeros() {
        let b = Binary.build(.one, .zero, .zero, .one, .zero, .one)
        let bPadded = Binary.build(.zero, .zero, .zero, .one, .zero, .zero, .one, .zero, .one)
        
        let reversed = Binary.build(.one, .zero, .one, .zero, .zero, .one)
        let reversedPadded = Binary.build(.one, .zero, .one, .zero, .zero, .one, .zero, .zero, .zero)
        
        XCTAssertEqual(bPadded.reversed(), reversed)
        XCTAssertEqual(b.reversed(), reversedPadded)
        XCTAssertEqual(bPadded.reversed(), reversedPadded)
    }
    
    func testBuildInteger() {
        var b = Binary.empty
        for ix in 0...100 {
            XCTAssertEqual(b, Binary.build(ix))
            b = b.incremented()
        }
    }

    static var allTests: [(String, () -> ())] = []
}
