import XCTest
import BetterCodable

class LosslessValueTests: XCTestCase {
    struct Fixture: Equatable, Codable {
        @LosslessValue var bool: Bool
        @DefaultEmptyString var string: String
        @LosslessValue var int: Int
        @LosslessValue var double: Double
    }

    func testDecodingMisalignedTypesFromJSONTraversesCorrectType() throws {
        let jsonData = #"{ "bool": "true", "string": 42, "int": "1", "double": "7.1" }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.bool, true)
        XCTAssertEqual(fixture.string, "42")
        XCTAssertEqual(fixture.int, 1)
        XCTAssertEqual(fixture.double, 7.1)
    }

    func testDecodingEncodedMisalignedTypesFromJSONDecodesCorrectTypes() throws {
        let jsonData = #"{ "bool": "true", "string": 42, "int": "7", "double": "7.1" }"#.data(using: .utf8)!
        var _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)

        _fixture.bool = false
        _fixture.double = 3.14

        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
        XCTAssertEqual(fixture.bool, false)
        XCTAssertEqual(fixture.string, "42")
        XCTAssertEqual(fixture.int, 7)
        XCTAssertEqual(fixture.double, 3.14)
    }

    func testEncodingAndDecodedExpectedTypes() throws {
        let jsonData = #"{ "bool": true, "string": "42", "int": 7, "double": 7.1 }"#.data(using: .utf8)!
        let _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
        XCTAssertEqual(fixture.bool, true)
        XCTAssertEqual(fixture.string, "42")
        XCTAssertEqual(fixture.int, 7)
        XCTAssertEqual(fixture.double, 7.1)
    }

    func testDecodingBoolIntValueFromJSONDecodesCorrectly() throws {
        struct FixtureWithBooleanAsInteger: Equatable, Codable {
            @LosslessBoolValue var bool: Bool
            @LosslessValue var string: String
            @LosslessValue var int: Int
            @LosslessValue var double: Double
        }

        let jsonData = #"{ "bool": 1, "string": "42", "int": 7, "double": 7.1 }"#.data(using: .utf8)!
        let _fixture = try JSONDecoder().decode(FixtureWithBooleanAsInteger.self, from: jsonData)
        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(FixtureWithBooleanAsInteger.self, from: fixtureData)
        XCTAssertEqual(fixture.bool, true)
        XCTAssertEqual(fixture.string, "42")
        XCTAssertEqual(fixture.int, 7)
        XCTAssertEqual(fixture.double, 7.1)
    }

    func testBoolAsIntegerShouldNotConflictWithDefaultStrategy() throws {
        struct Response: Codable {
            @LosslessValue var id: String
            @LosslessBoolValue var bool: Bool
        }

        let json = #"{ "id": 1, "bool": 1 }"#.data(using: .utf8)!
        let result = try JSONDecoder().decode(Response.self, from: json)

        XCTAssertEqual(result.id, "1")
        XCTAssertEqual(result.bool, true)
    }
}
