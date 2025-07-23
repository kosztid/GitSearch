import Foundation

public protocol GitServiceProtocol {
	func fetchData(searchText: String) async throws -> [Repository]
}

final class GitService {
	private func buildSearchURL(query: String) -> URL? {
		let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
		let urlString = "https://api.github.com/search/repositories?q=\(encoded)"
		return URL(string: urlString)
	}
}

extension GitService: GitServiceProtocol {
	func fetchData(searchText: String) async throws -> [Repository] {
		guard let url = buildSearchURL(query: searchText) else {
			throw URLError(.badURL)
		}

		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")

		let (data, response) = try await URLSession.shared.data(for: request)

		guard let httpResponse = response as? HTTPURLResponse,
			  200..<300 ~= httpResponse.statusCode else {
			throw URLError(.badServerResponse)
		}

		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		decoder.dateDecodingStrategy = .iso8601

		let result = try decoder.decode(GitHubResponse.self, from: data)
		return result.items
	}
}
