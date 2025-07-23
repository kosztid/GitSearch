import SwiftUI

struct DetailView: View {
	private enum Layout {
		static let imageSize: CGFloat = 60
		static let spacing: CGFloat = 16
	}
	private enum Constants {
		static let loadFailureImageName = "person.crop.circle.badge.exclamationmark"
		static let starImageName = "star.fill"
		static let forkImageName = "fork.knife"
		static let openProfile = "Open Profile"
		static let openGithub = "Open on GitHub"
		static let navigationTitle = "Details"
		static func createdAt(_ input: String) -> String {
			return "Created: \(input)"
		}
		static func updatedAt(_ input: String) -> String {
			return "Last updated: \(input)"
		}
	}
	
	let repository: Repository

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: Layout.spacing) {
				HStack(spacing: Layout.spacing) {
					AsyncImage(url: URL(string: repository.owner.avatarUrl)) { phase in
						switch phase {
						case .success(let image):
							image
								.resizable()
								.aspectRatio(contentMode: .fill)
								.frame(width: Layout.imageSize, height: Layout.imageSize)
								.clipShape(Circle())
						case .failure(_):
							Image(systemName: Constants.loadFailureImageName)
								.resizable()
								.frame(width: Layout.imageSize, height: Layout.imageSize)
								.foregroundColor(.gray)
						default:
							ProgressView()
								.frame(width: Layout.imageSize, height: Layout.imageSize)
						}
					}

					VStack(alignment: .leading) {
						Text(repository.owner.login)
							.font(.headline)

						if let url = URL(string: repository.owner.htmlUrl) {
							Link(Constants.openProfile, destination: url)
								.font(.subheadline)
								.foregroundColor(.blue)
						}
					}
				}

				Divider()

				Text(repository.name)
					.font(.title)
					.bold()

				if let description = repository.description {
					Text(description)
						.font(.body)
						.foregroundColor(.secondary)
				}

				if let url = URL(string: repository.htmlUrl) {
					Link(Constants.openGithub, destination: url)
						.font(.body)
						.foregroundColor(.blue)
				}
				HStack {
					Label("\(repository.stargazersCount)", systemImage: Constants.starImageName)
						.foregroundColor(.yellow)
					Label("\(repository.forksCount)", systemImage: Constants.forkImageName)
						.foregroundColor(.gray)
				}

				VStack(alignment: .leading) {
					Text(Constants.createdAt(repository.createdAt.formattedDate))
					Text(Constants.updatedAt(repository.updatedAt.formattedDate))
				}
				.font(.footnote)
				.foregroundColor(.gray)
			}
			.padding()
		}
		.navigationTitle(Constants.navigationTitle)
	}
}

#Preview {
	DetailView(
		repository: Repository(
			id: 1,
			name: "GitSearch",
			description: "Description",
			stargazersCount: 1234,
			forksCount: 321,
			htmlUrl: "https://github.com/kosztid/GitSearch",
			createdAt: "2025-07-23T09:00:00Z",
			updatedAt: "2024-07-23T10:45:30Z",
			owner: Owner(
				login: "kosztid",
				avatarUrl: "https://avatars.githubusercontent.com/u/1234567?v=4",
				htmlUrl: "https://github.com/kosztid"
			)
		)
	)
}
