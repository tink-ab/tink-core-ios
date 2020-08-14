import Foundation
@testable import TinkCore
import XCTest

class StatisticTests: XCTestCase {
    func testStatisticPeriodYearStringMapping() {
        let yearPeriod = StatisticPeriod.year(2002)
        XCTAssertEqual(yearPeriod.stringRepresentation, "2002")
    }

    func testStatisticPeriodWeekStringMapping() {
        let weekPeriod = StatisticPeriod.week(year: 2020, week: 10)
        let weekPeriod2 = StatisticPeriod.week(year: 2020, week: 2)

        XCTAssertEqual(weekPeriod.stringRepresentation, "2020:10")
        XCTAssertEqual(weekPeriod2.stringRepresentation, "2020:02")
    }

    func testStatisticPeriodMonthStringMapping() {
        let monthPeriod = StatisticPeriod.month(year: 2020, month: 5)
        let monthPeriod2 = StatisticPeriod.month(year: 2020, month: 15)

        XCTAssertEqual(monthPeriod.stringRepresentation, "2020-05")
        XCTAssertEqual(monthPeriod2.stringRepresentation, "2020-15")
    }

    func testStatisticPeriodDayStringMapping() {
        let dayPeriod = StatisticPeriod.day(year: 2020, month: 1, day: 5)
        let dayPeriod2 = StatisticPeriod.day(year: 2020, month: 10, day: 15)

        XCTAssertEqual(dayPeriod.stringRepresentation, "2020-01-05")
        XCTAssertEqual(dayPeriod2.stringRepresentation, "2020-10-15")
    }

    func testStatisticTypeStringInitializer() {
        XCTAssertEqual(StatisticPeriod(string: "abc"), nil)
        XCTAssertEqual(StatisticPeriod(string: "2000"), StatisticPeriod.year(2000))
        XCTAssertEqual(StatisticPeriod(string: "2000:01"), StatisticPeriod.week(year: 2000, week: 1))
        XCTAssertEqual(StatisticPeriod(string: "2000-01"), StatisticPeriod.month(year: 2000, month: 1))
        XCTAssertEqual(StatisticPeriod(string: "2000-10-02"), StatisticPeriod.day(year: 2000, month: 10, day: 2))
    }
}
