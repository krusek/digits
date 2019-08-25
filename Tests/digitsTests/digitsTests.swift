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

    static var allTests: [(String, () -> ())] = []
}
