import SwiftUI

struct ProjectDetail: View {
    let project: Project
    let isSaved: Bool
    let toggleSave: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ProjectIcon(project: project, size: 76)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(project.name).font(.largeTitle.bold()).tracking(-1)
                        Text("Alternative to \(project.alternative)").font(.title3).foregroundStyle(.secondary)
                        Label(project.category.rawValue, systemImage: project.category.symbol)
                            .font(.caption.weight(.medium)).padding(.horizontal, 12).padding(.vertical, 8)
                            .background(Color.storeSurface, in: Capsule())
                    }
                    Text(project.summary).font(.body).lineSpacing(5)
                    Link(destination: project.websiteURL) {
                        Label("Visit website", systemImage: "arrow.up.right")
                            .font(.headline).frame(maxWidth: .infinity).padding(16)
                            .foregroundStyle(.black).background(.mint, in: RoundedRectangle(cornerRadius: 14))
                    }
                    HStack(spacing: 12) {
                        Link(destination: project.repositoryURL) {
                            Label("Source code", systemImage: "chevron.left.forwardslash.chevron.right")
                                .frame(maxWidth: .infinity, minHeight: 48)
                        }
                        Button(action: toggleSave) {
                            Label(isSaved ? "Saved" : "Save", systemImage: isSaved ? "bookmark.fill" : "bookmark")
                                .frame(maxWidth: .infinity, minHeight: 48)
                        }
                    }
                    .font(.subheadline.weight(.medium))
                    .buttonStyle(.bordered)
                    Divider()
                    Text("Explore the project’s website for supported platforms, installation instructions, and license details. This catalog does not install apps.")
                        .font(.footnote).foregroundStyle(.secondary)
                }.padding(24)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .topBarLeading) {
                    ShareLink(item: project.websiteURL)
                }
            }
        }
        .presentationDragIndicator(.visible)
    }
}
