public struct Repository: Identifiable, Decodable, Equatable, Hashable {
	public static func == (lhs: Repository, rhs: Repository) -> Bool {
		lhs.id == rhs.id
	}
	
	public let id: Int
	public let name: String
	public let description: String?
	public let stargazersCount: Int
	public let forksCount: Int
	public let htmlUrl: String
	public let createdAt: String
	public let updatedAt: String
	public let owner: Owner
}

public struct Owner: Decodable, Hashable {
	public let login: String
	public let avatarUrl: String
	public let htmlUrl: String
}

public struct GitHubResponse: Decodable {
	public let items: [Repository]
}
