import XCTest
import digits

final class BinaryTests: XCTestCase {
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

    func testAddition() {
        let limit = 20
        for ix in -limit...limit {
            for iy in -limit...limit {
                let sum = BinaryInteger.build(ix) + BinaryInteger.build(iy)
                XCTAssertEqual(sum, BinaryInteger.build(ix + iy), "\(ix) + \(iy) != \(sum)")
            }
        }
    }

    func testMultiplication() {
        let max = 20
        for ix in -max...max {
            for iy in -max...max {
                let product = BinaryInteger.build(ix) * BinaryInteger.build(iy)
                XCTAssertEqual(product, BinaryInteger.build(ix * iy), "\(ix) * \(iy) != \(product)")
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

    func testBase10() {
        for ix in -1000...1000 {
            XCTAssertEqual(BinaryInteger.build(ix).description, "\(ix)", "\(ix) != \(ix)")
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
