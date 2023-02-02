import XCTest
@testable import TinkCore

final class CodeTests: XCTestCase {
    func testInit() {
        let sut0 = Category.Code("some")
        let sut1 = Category.Code(stringLiteral: "some")
        let sut2 = Category.Code(unicodeScalarLiteral: "some")

        XCTAssertEqual(sut0.value, "some")
        XCTAssertEqual(sut1.value, sut0.value)
        XCTAssertEqual(sut2.value, sut1.value)
    }

    func testCharacteristicChecks() {
        XCTAssertTrue(Category.Code("expenses").isExpense)
        XCTAssertTrue(Category.Code("income").isIncome)
        XCTAssertTrue(Category.Code("transfers").isTransfer)
        XCTAssertTrue(Category.Code("expenses:misc.uncategorized").isUncategorized)
        XCTAssertTrue(Category.Code("income:uncategorized").isUncategorized)
        XCTAssertTrue(Category.Code("income:uncategorized.other").isUncategorized)
        XCTAssertTrue(Category.Code("income:uncategorized.other").isOther)
        XCTAssertTrue(Category.Code("income:refund.anything.random").isReimbursement)
        XCTAssertTrue(Category.Code("transfers:savings.other").isSavings)
        XCTAssertTrue(Category.Code("transfers:exclude.other").isExcluded)
        XCTAssertTrue(Category.Code("anthing.random.other").isOther)
        XCTAssertTrue(Category.Code("expenses:misc.other").isMiscOther)
        XCTAssertTrue(Category.Code("expenses:anything.unknown.other").isExpensesOther)
        XCTAssertTrue(Category.Code("root.category").isRootCategory)
        XCTAssertTrue(Category.Code("not:root.category").isSubcategory)
    }

    func testType() {
        let sut0 = Category.Code("income")
        let sut1 = Category.Code("expenses")
        let sut2 = Category.Code("transfer")

        XCTAssertEqual(sut0.type, Category.Kind(code: Category.Code("income")))
        XCTAssertEqual(sut1.type, Category.Kind(code: Category.Code("expenses")))
        XCTAssertEqual(sut2.type, Category.Kind(code: Category.Code("transfer")))
    }
}
