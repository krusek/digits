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

    func testOldBuildInteger() {
        var b = Binary.zero
        for ix in 0...100 {
            XCTAssertEqual(b, Binary.build(ix), "bad build for: \(ix)")
            XCTAssertEqual(b.description, Binary.build(ix).description, "bad description for: \(ix)")
            b = b.incremented()
        }
    }

    func testBuildInteger() {
        var p: BinaryInteger = .zero
        var n: BinaryInteger = .zero
        for ix in 0...100 {
            XCTAssertEqual(p, BinaryInteger.build(ix), "bad build for: \(ix)")
            XCTAssertEqual(p.description, BinaryInteger.build(ix).description, "bad description for: \(ix)")
            XCTAssertEqual(n, BinaryInteger.build(-ix), "bad build for: \(-ix)")
            XCTAssertEqual(n.description, BinaryInteger.build(-ix).description, "bad description for: \(-ix)")
            p = p.incremented()
            n = n.decremented()
        }
    }

    func testOldAddition() {
        for ix in 0...20 {
            for iy in 0...20 {
                let sum = Binary.build(ix) + Binary.build(iy)
                XCTAssertEqual(sum, Binary.build(ix + iy), "\(ix) + \(iy) != \(sum)")
            }
        }
    }

    func testAddition() {
        let limit = 20
        for ix in -limit...limit {
            for iy in -limit...limit {
                let sum = BinaryInteger.build(ix) + BinaryInteger.build(iy)
                XCTAssertEqual(sum, BinaryInteger.build(ix + iy), "\(ix) + \(iy) != \(sum)")
            }
        }
    }

    func testOldMultiplication() {
        for ix in 0...20 {
            for iy in 0...20 {
                let product = Binary.build(ix) * Binary.build(iy)
                XCTAssertEqual(product, Binary.build(ix * iy), "\(ix) * \(iy) != \(product)")
            }
        }
    }

    func testMultiplication() {
        let max = 5
        for ix in -max...max {
            for iy in -max...max {
                let product = BinaryInteger.build(ix) * BinaryInteger.build(iy)
                XCTAssertEqual(product, BinaryInteger.build(ix * iy), "\(ix) * \(iy) != \(product)")
            }
        }
    }

    func testOldInequality() {
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

    func testInequality() {
        let max = 20
        for ix in -max...max {
            for iy in (ix+1)...(max + 1) {
                let x = BinaryInteger.build(ix)
                let y = BinaryInteger.build(iy)
                XCTAssertTrue(x < y, "\(ix) >= \(iy)")
                XCTAssertFalse(y < x, "\(iy) < \(ix)")
            }
        }
    }
    
    func testMod5() {
        for ix in 0...1000 {
            XCTAssertEqual(Binary.build(ix).mod5(), Binary.build(ix % 5), "\(ix) % 5 != \(ix % 5)")
        }
    }

    func testOldBase10() {
        for ix in 0...1000 {
            XCTAssertEqual(Binary.build(ix).description, "\(ix)", "\(ix) != \(ix)")
        }

    }

    func testBase10() {
        for ix in -1000...1000 {
            XCTAssertEqual(BinaryInteger.build(ix).description, "\(ix)", "\(ix) != \(ix)")
        }

    }

    func testOldSubtraction() {
        let max = 50
        for ix in 0...max {
            for iy in (ix + 1)...(max + 1) {
                XCTAssertEqual(Binary.build(iy) - Binary.build(ix), Binary.build(iy - ix), "\(iy) - \(ix) != \(iy-ix)")
            }
        }
    }

    func testSubtraction() {
        let max = 50
        for ix in 0...max {
            for iy in (ix + 1)...(max + 1) {
                XCTAssertEqual(BinaryInteger.build(iy) - BinaryInteger.build(ix), BinaryInteger.build(iy - ix), "\(iy) - \(ix) != \(iy-ix)")
            }
        }
    }

    func testOldPower() {
        let max = 20
        for ix in 1...6 {
            for iy in 0...max {
                let power: Int = Int(pow(Double(ix), Double(iy)))
                XCTAssertEqual(Binary.build(power), Binary.build(ix).pow(Binary.build(iy)), "\(ix)^\(iy) != \(power)")
            }
        }

        let power = Binary.build(2).pow(Binary.build(135))
        XCTAssertEqual(power.description, "43556142965880123323311949751266331066368")
    }

    func testPower() {
        let max = 20
        for ix in -6...6 {
            for iy in 0...max {
                let power: Int = Int(pow(Double(ix), Double(iy)))
                XCTAssertEqual(BinaryInteger.build(power), BinaryInteger.build(ix).pow(BinaryInteger.build(iy)), "\(ix)^\(iy) != \(power)")
            }
        }

        let power = BinaryInteger.build(2).pow(BinaryInteger.build(135))
        XCTAssertEqual(power.description, "43556142965880123323311949751266331066368")
    }

    func testOldDividing() throws {
        let max = 50
        for ix in 1...max {
            for iy in (ix + 1)...(max+1) {
                let (q, r) = try! Binary.integerDivide(divisor: .build(ix), dividend: .build(iy))
                XCTAssertEqual(q, Binary.build(iy / ix))
                XCTAssertEqual(r, Binary.build(iy % ix))
            }
        }
    }

    func testIntegerDividing() throws {
        let max = 50
        for ix in 1...max {
            for iy in (ix + 1)...(max+1) {
                let (q, r) = try! BinaryInteger.positiveIntegerDivide(divisor: .build(ix), dividend: .build(iy))
                XCTAssertEqual(q, BinaryInteger.build(iy / ix))
                XCTAssertEqual(r, BinaryInteger.build(iy % ix))
            }
        }
    }

    func testDividing() throws {
        let max = 50
        for ix in 1...max {
            for iy in 1...(max) {
                let q1 = try! BinaryInteger.build(iy) / BinaryInteger.build(ix)
                XCTAssertEqual(q1, BinaryInteger.build(iy / ix), "failure for \(iy)/\(ix)=\(iy/ix)")
                let q2 = try! BinaryInteger.build(-iy) / BinaryInteger.build(ix)
                XCTAssertEqual(q2, BinaryInteger.build(-iy / ix), "failure for \(-iy)/\(ix)=\(-iy/ix)")
                let q3 = try! BinaryInteger.build(iy) / BinaryInteger.build(-ix)
                XCTAssertEqual(q3, BinaryInteger.build(iy / -ix), "failure for \(iy)/\(-ix)=\(-iy/ix)")
            }
        }
    }

    func testRemainder() throws {
        let max = 50
        for ix in 1...max {
            for iy in 1...(max) {
                let q1 = try! BinaryInteger.build(iy) % BinaryInteger.build(ix)
                XCTAssertEqual(q1, BinaryInteger.build(iy % ix), "failure for \(iy)%\(ix)=\(iy%ix)")
                let q2 = try! BinaryInteger.build(-iy) % BinaryInteger.build(ix)
                XCTAssertEqual(q2, BinaryInteger.build(-iy % ix), "failure for \(-iy)%\(ix)=\(-iy%ix)")
                let q3 = try! BinaryInteger.build(iy) % BinaryInteger.build(-ix)
                XCTAssertEqual(q3, BinaryInteger.build(iy % -ix), "failure for \(iy)%\(-ix)=\(iy % -ix)")
            }
        }
    }

    static var allTests: [(String, () -> ())] = []
}
