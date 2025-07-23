import SwiftUI

struct ListView: View {
	private enum Layout {
		static let cornerRadius: CGFloat = 60
		static let listSpacing: CGFloat = 4
		static let itemSpacing: CGFloat = 8
		static let textFieldOpacity: CGFloat = 0.8
		static let overlayOpacity: CGFloat = 0.2
		static let lineWidth: CGFloat = 0.2
		static let descriptionLineLimit: Int = 2
	}
	private enum Constants {
		static let starImageName = "star.fill"
		static let navigationTitle = "Results"
	}

	var repositories: [Repository]
	let onSelect: (Repository) -> Void

	var body: some View {
		List {
			ForEach(repositories, id: \.self) { repo in
				VStack(alignment: .leading, spacing: Layout.listSpacing) {
					Text("\(repo.name)")
						.font(.headline)
					if let desc = repo.description {
						Text(desc)
							.font(.subheadline)
							.foregroundColor(.secondary)
							.lineLimit(Layout.descriptionLineLimit)
					}
					HStack {
						Image(systemName: Constants.starImageName)
							.foregroundColor(.yellow)
						Text("\(repo.stargazersCount)")
						Spacer()
						Text(repo.updatedAt.formattedDate)
							.font(.caption)
							.foregroundColor(.gray)
					}
				}
				.contentShape(Rectangle())
				.onTapGesture {
					onSelect(repo)
				}
			}
			.padding(.vertical, Layout.listSpacing)
		}
		.navigationTitle(Constants.navigationTitle)
	}
}

#Preview {
	ListView(repositories: [], onSelect: { _ in })
}
