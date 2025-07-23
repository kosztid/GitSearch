import Combine
import XCTest
import SwiftUI
@testable import GitSearch

final class SearchViewModelTests: XCTestCase {

	private var sut: SearchView.ViewModel!
	private var mockService: MockGitService!

	override func setUp() {
		super.setUp()
		mockService = MockGitService()
		sut = SearchView.ViewModel(service: mockService)
	}

	override func tearDown() {
		sut = nil
		mockService = nil
		super.tearDown()
	}

	func test_searchButtonTapped_whenSearchParamIsEmpty_shouldSetEmptyParameterError() {
		sut.searchParam = ""

		sut.searchButtonTapped()

		let expectation = XCTestExpectation(description: "Empty param error")

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			XCTAssertEqual(self.sut.currentError, .emptyParameter)
			XCTAssertFalse(self.sut.isLoading)
			XCTAssertTrue(self.sut.repositories.isEmpty)
			XCTAssertTrue(self.sut.path.isEmpty)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 1.0)
	}

	func test_searchButtonTapped_whenServiceReturnsEmptyResults_shouldSetEmptyResultsError() {
		sut.searchParam = "nonexistent"
		mockService.mockRepositories = []

		sut.searchButtonTapped()

		let expectation = XCTestExpectation(description: "Empty results error")

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			XCTAssertEqual(self.sut.currentError, .emptyResults)
			XCTAssertFalse(self.sut.isLoading)
			XCTAssertTrue(self.sut.repositories.isEmpty)
			XCTAssertTrue(self.sut.path.isEmpty)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 1.0)
	}

	func test_searchButtonTapped_whenServiceReturnsError_shouldSetEmptyResultsError() {
		sut.searchParam = "test"
		mockService.shouldThrowError = true

		sut.searchButtonTapped()

		let expectation = XCTestExpectation(description: "Network error")

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			XCTAssertEqual(self.sut.currentError, .networkError)
			XCTAssertFalse(self.sut.isLoading)
			XCTAssertTrue(self.sut.repositories.isEmpty)
			XCTAssertTrue(self.sut.path.isEmpty)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 1.0)
	}

	func test_searchButtonTapped_whenServiceReturnsRepositories_shouldNavigateToListScreen() {
		let mockRepos = createMockRepositories()
		sut.searchParam = "test"
		mockService.mockRepositories = mockRepos

		sut.searchButtonTapped()

		let expectation = XCTestExpectation(description: "ShouldNavigate")

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			XCTAssertNil(self.sut.currentError)
			XCTAssertFalse(self.sut.isLoading)
			XCTAssertFalse(self.sut.repositories.isEmpty)
			XCTAssertFalse(self.sut.path.isEmpty)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 1.0)
	}

	func test_showDetail_whenCalled_shouldAppendDetailScreenToPath() {
		let repository = createMockRepository()

		sut.showDetail(for: repository)

		XCTAssertEqual(sut.path.count, 1)

		if case .detail(let repo) = sut.path.first {
			XCTAssertEqual(repo, repository)
		} else {
			XCTFail("Expected detail screen in path")
		}
	}

	func test_currentErrorMessage_whenEmptyParameter_shouldReturnCorrectMessage() {
		sut.currentError = .emptyParameter

		let message = sut.currentErrorMessage

		XCTAssertEqual(message, "Please enter a repository name to search.")
	}

	func test_currentErrorMessage_whenEmptyResults_shouldReturnCorrectMessageWithSearchParam() {
		sut.searchParam = "testquery"
		sut.currentError = .emptyResults

		let message = sut.currentErrorMessage

		XCTAssertEqual(message, "No repositories found for 'testquery'. Try a different search term.")
	}

	func test_currentErrorMessage_whenNetworkError_shouldReturnCorrectMessage() {
		sut.currentError = .networkError

		let message = sut.currentErrorMessage

		XCTAssertEqual(message, "Network error occurred during search. Please check your connection and try again.")
	}

	func test_currentErrorMessage_whenNoError_shouldReturnNil() {
		sut.currentError = nil

		let message = sut.currentErrorMessage

		XCTAssertNil(message)
	}

	private func createMockRepository(name: String = "TestRepo") -> Repository {
		return Repository(
			id: 1,
			name: name,
			description: "",
			stargazersCount: 1,
			forksCount: 1,
			htmlUrl: "",
			createdAt: "",
			updatedAt: "",
			owner: .init(
				login: "",
				avatarUrl: "",
				htmlUrl: ""
			)
		)
	}

	private func createMockRepositories() -> [Repository] {
		return [
			createMockRepository(name: "Repo1"),
			createMockRepository(name: "Repo2"),
			createMockRepository(name: "Repo3")
		]
	}
}

class MockGitService: GitServiceProtocol {
	var mockRepositories: [Repository] = []
	var shouldThrowError = false

	func fetchData(searchText: String) async throws -> [Repository] {
		if shouldThrowError {
			throw URLError(.networkConnectionLost)
		}
		return mockRepositories
	}
}
