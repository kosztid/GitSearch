import SwiftUI

extension SearchView {
	enum Screen: Hashable {
		case list(repositories: [Repository])
		case detail(repository: Repository)
	}
	enum SearchError {
		case emptyParameter
		case emptyResults
		case networkError
	}

	final class ViewModel: ObservableObject {
		private let service: GitServiceProtocol

		@Published var searchParam = ""
		@Published var isLoading = false
		@Published var repositories: [Repository] = []
		@Published var path: [Screen] = []

		@Published var currentError: SearchError?

		public init(service: GitServiceProtocol = GitService()) {
			self.service = service
		}

		var currentErrorMessage: String? {
			switch currentError {
			case .emptyParameter:
				return "Please enter a repository name to search."
			case .emptyResults:
				return "No repositories found for '\(searchParam)'. Try a different search term."
			case .networkError:
				return "Network error occurred during search. Please check your connection and try again."
			default:
				return nil
			}
		}

		func searchButtonTapped() {
			Task { @MainActor in
				guard !searchParam.isEmpty else {
					currentError = .emptyParameter
					return
				}

				isLoading = true
				currentError = nil
				defer {
					isLoading = false
				}

				do {
					repositories = try await service.fetchData(searchText: searchParam)
					guard !repositories.isEmpty else {
						currentError = .emptyResults
						return
					}

					path.append(.list(repositories: repositories))
				} catch {
					currentError = .networkError
				}
			}
		}

		func showDetail(for repository: Repository) {
			path.append(.detail(repository: repository))
		}
	}
}
