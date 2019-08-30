import XCTest
import digits

final class NumberTests: XCTestCase {
    
    func testBuildInteger() {
        let min = -20
        var b = Number(integerLiteral: min)
        for ix in min...100 {
            XCTAssertEqual(b, Number(integerLiteral: ix), "bad build for: \(ix)")
            b = b.incremented()
        }
    }
    
    func testAddition() {
        for ix in -20...20 {
            for iy in -20...20 {
                let sum = Number.build(ix) + Number.build(iy)
                XCTAssertEqual(sum, Number.build(ix + iy), "\(ix) + \(iy) != \(sum)")
            }
        }
    }
    
    func testMultiplication() {
        for ix in -20...20 {
            for iy in -20...20 {
                let product = Number.build(ix) * Number.build(iy)
                XCTAssertEqual(product, Number.build(ix * iy), "\(ix) * \(iy) != \(product)")
            }
        }
    }
    
    func testInequality() {
        let max = 30
        for ix in -20...max {
            for iy in (ix+1)...(max + 1) {
                let x = Number.build(ix)
                let y = Number.build(iy)
                XCTAssertTrue(x < y)
                XCTAssertFalse(y < x)
            }
        }
    }
    
    func testSubtraction() {
        let max = 50
        for ix in 0...max {
            for iy in 0...(max + 1) {
                XCTAssertEqual(Number.build(iy) - Number.build(ix), Number.build(iy - ix), "\(iy) - \(ix) != \(iy-ix)")
                XCTAssertEqual(Number.build(ix) - Number.build(iy), Number.build(ix - iy), "\(ix) - \(iy) != \(ix-iy)")
            }
        }
    }
    
    func testDividing() throws {
        let max = 50
        for ix in 1...max {
            for iy in 1...(max) {
                let q1 = try! Number.build(iy) / Number.build(ix)
                XCTAssertEqual(q1, Number.build(iy / ix), "failure for \(iy)/\(ix)=\(iy/ix)")
                let q2 = try! Number.build(-iy) / Number.build(ix)
                XCTAssertEqual(q2, Number.build(-iy / ix), "failure for \(-iy)/\(ix)=\(-iy/ix)")
                let q3 = try! Number.build(iy) / Number.build(-ix)
                XCTAssertEqual(q3, Number.build(iy / -ix), "failure for \(iy)/\(-ix)=\(-iy/ix)")
            }
        }
    }
    
    func testRemainder() throws {
        let max = 50
        for ix in 1...max {
            for iy in 1...(max) {
                let q1 = try! Number.build(iy) % Number.build(ix)
                XCTAssertEqual(q1, Number.build(iy % ix), "failure for \(iy)%\(ix)=\(iy%ix)")
                let q2 = try! Number.build(-iy) % Number.build(ix)
                XCTAssertEqual(q2, Number.build(-iy % ix), "failure for \(-iy)%\(ix)=\(-iy%ix)")
                let q3 = try! Number.build(iy) % Number.build(-ix)
                XCTAssertEqual(q3, Number.build(iy % -ix), "failure for \(iy)%\(-ix)=\(iy % -ix)")
            }
        }
    }
    
    static var allTests: [(String, () -> ())] = []
}
