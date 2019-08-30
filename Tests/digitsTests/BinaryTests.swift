import XCTest
import digits

final class BinaryTests: XCTestCase {
    
    func testIncrement() {
        var b = Binary.zero
        b = b.incremented()
        XCTAssertEqual(b, Binary.build(.one))
        b = b.incremented()
        XCTAssertEqual(b, Binary.build(.zero, .one))
        b = b.incremented()
        XCTAssertEqual(b, Binary.build(.one, .one))
        b = b.incremented()
        XCTAssertEqual(b, Binary.build(.zero, .zero, .one))
        b = b.incremented()
        XCTAssertEqual(b, Binary.build(.one, .zero, .one))
        b = b.incremented()
        XCTAssertEqual(b, Binary.build(.zero, .one, .one))
        b = b.incremented()
        XCTAssertEqual(b, Binary.build(.one, .one, .one))
        b = b.incremented()
        XCTAssertEqual(b, Binary.build(.zero, .zero, .zero, .one))
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
            XCTAssertEqual(b, Binary.build(ix), "bad build for: \(ix)")
            XCTAssertEqual(b.description, Binary.build(ix).description, "bad description for: \(ix)")
            b = b.incremented()
        }
    }
    
    func testAddition() {
        for ix in 0...20 {
            for iy in 0...20 {
                let sum = Binary.build(ix) + Binary.build(iy)
                XCTAssertEqual(sum, Binary.build(ix + iy), "\(ix) + \(iy) != \(sum)")
            }
        }
    }
    
    func testMultiplication() {
        for ix in 0...20 {
            for iy in 0...20 {
                let product = Binary.build(ix) * Binary.build(iy)
                XCTAssertEqual(product, Binary.build(ix * iy), "\(ix) * \(iy) != \(product)")
            }
        }
    }
    
    func testInequality() {
        let max = 30
        for ix in 0...max {
            for iy in (ix+1)...(max + 1) {
                let x = Binary.build(ix)
                let y = Binary.build(iy)
                XCTAssertTrue(x < y)
                XCTAssertFalse(y < x)
            }
        }
    }
    
    func testMod5() {
        for ix in 0...1000 {
            XCTAssertEqual(Binary.build(ix).mod5(), Binary.build(ix % 5), "\(ix) % 5 != \(ix % 5)")
        }
    }
    
    func testSubtraction() {
        let max = 50
        for ix in 0...max {
            for iy in (ix + 1)...(max + 1) {
                XCTAssertEqual(Binary.subtract(lhs: .build(iy), rhs: .build(ix)) , Binary.build(iy - ix), "\(iy) - \(ix) != \(iy-ix)")
            }
        }
    }
    
    func testDividing() throws {
        let max = 50
        for ix in 1...max {
            for iy in (ix + 1)...(max+1) {
                let (q, r) = try! Binary.integerDivide(divisor: .build(ix), dividend: .build(iy))
                XCTAssertEqual(q, Binary.build(iy / ix))
                XCTAssertEqual(r, Binary.build(iy % ix))
            }
        }
    }

    static var allTests: [(String, () -> ())] = []
}
