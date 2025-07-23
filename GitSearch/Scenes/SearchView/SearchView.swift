import SwiftUI

struct SearchView: View {
	private enum Layout {
		static let cornerRadius: CGFloat = 10
		static let spacing: CGFloat = 16
		static let titlePadding: CGFloat = 32
		static let textFieldOpacity: CGFloat = 0.8
		static let overlayOpacity: CGFloat = 0.2
		static let lineWidth: CGFloat = 0.2
	}
	private enum Constants {
		static let textFieldPlaceholder = "Search for a repository..."
		static let buttonText = "Search"
		static let title = "Github Search"
	}

	@StateObject var viewModel: ViewModel
	var body: some View {
		NavigationStack(path: $viewModel.path) {
			VStack {
				Text(Constants.title)
					.font(.largeTitle)
					.padding(.vertical, Layout.titlePadding)
				VStack(alignment: .leading, spacing: Layout.spacing) {
					TextField(Constants.textFieldPlaceholder, text: $viewModel.searchParam)
						.padding()
						.background(Color(.systemGray6))
						.cornerRadius(Layout.cornerRadius)
						.overlay(
							RoundedRectangle(cornerRadius: Layout.cornerRadius)
								.stroke(Color.gray.opacity(Layout.textFieldOpacity), lineWidth: Layout.lineWidth)
						)
						.padding(.horizontal, Layout.spacing)

					if let errorMessage = viewModel.currentErrorMessage {
						Text(errorMessage)
							.foregroundColor(.red)
							.font(.subheadline)
							.padding(.horizontal, Layout.spacing)
							.transition(.opacity)
					}

					Button {
						viewModel.searchButtonTapped()
					} label: {
						Text(Constants.buttonText)
							.foregroundColor(.white)
							.padding()
							.frame(maxWidth: .infinity)
							.background(Color.blue)
							.cornerRadius(Layout.cornerRadius)
					}
					.padding(.horizontal, Layout.spacing)
					Spacer()
				}
				.padding(.horizontal, Layout.spacing)
			}
			.overlay {
				if viewModel.isLoading {
					Color.black.opacity(Layout.overlayOpacity)
						.edgesIgnoringSafeArea(.all)

					ProgressView()
				}
			}
			.navigationDestination(for: Screen.self) { screen in
				switch screen {
				case .list(let repositories):
					ListView(repositories: repositories) { selectedRepo in
							viewModel.showDetail(for: selectedRepo)
						}
				case .detail(let repository):
					DetailView(repository: repository)
				}
			}
		}
	}
}

#Preview {
	SearchView(viewModel: .init())
}
