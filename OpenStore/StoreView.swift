import SwiftUI

enum StoreTab: String, CaseIterable {
    case discover = "Discover", categories = "Categories", search = "Search", trending = "Trending", new = "New"
    var symbol: String {
        switch self {
        case .discover: return "safari"
        case .categories: return "square.grid.2x2"
        case .search: return "magnifyingglass"
        case .trending: return "arrow.up.right"
        case .new: return "plus"
        }
    }
}

struct StoreView: View {
    @AppStorage("lightAppearance") private var lightAppearance = false
    @AppStorage("savedProjects") private var savedProjects = ""
    @State private var tab: StoreTab = .discover
    @State private var query = ""
    @State private var category: Category = .all
    @State private var selectedProject: Project?
    @State private var savedOnly = false
    @FocusState private var searchFocused: Bool

    private var savedIDs: Set<String> { Set(savedProjects.split(separator: ",").map(String.init)) }
    private var results: [Project] {
        let base = savedOnly ? Catalog.projects.filter { savedIDs.contains($0.id) } : Catalog.projects
        let filtered = Catalog.search(query, category: category, in: base)
        return tab == .new ? Array(filtered.reversed()) : filtered
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            ScrollView {
                VStack(alignment: .leading, spacing: 26) {
                    if tab == .discover && query.isEmpty && category == .all && !savedOnly {
                        hero
                    } else {
                        pageTitle
                    }
                    searchField
                    categoryStrip
                    if tab == .discover && query.isEmpty && category == .all && !savedOnly {
                        popularReplacements
                        Divider().padding(.horizontal, -20)
                        featured
                        projectList(title: "Meet the Open family.", projects: Catalog.projects.filter { $0.name.hasPrefix("Open") })
                    } else if tab == .categories && category == .all && query.isEmpty && !savedOnly {
                        categoryGrid
                    } else {
                        if tab == .trending {
                            Text("Editor’s picks from the bundled catalog. Live popularity data is not connected.")
                                .font(.subheadline).foregroundStyle(.secondary)
                        }
                        if tab == .new {
                            Text("Recently listed in this app’s starter catalog.")
                                .font(.subheadline).foregroundStyle(.secondary)
                        }
                        projectList(title: savedOnly ? "Saved projects" : "\(results.count) projects", projects: results)
                    }
                    Text("A little more freedom.")
                        .font(.caption).foregroundStyle(.tertiary)
                        .frame(maxWidth: .infinity).padding(.vertical, 20)
                }
                .padding(.horizontal, 20).padding(.top, 26)
                .frame(maxWidth: 760)
                .frame(maxWidth: .infinity)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .background(Color.storeBackground)
        .safeAreaInset(edge: .bottom, spacing: 0) { bottomBar }
        .sheet(item: $selectedProject) { project in
            ProjectDetail(project: project, isSaved: savedIDs.contains(project.id)) { toggleSave(project) }
        }
    }

    private var header: some View {
        HStack(spacing: 10) {
            Image(systemName: "bag").font(.title2).foregroundStyle(.mint)
                .shadow(color: .mint.opacity(0.4), radius: 3)
            Text("OpenStore").font(.title2.bold()).tracking(-0.7)
            Spacer()
            Button {
                savedOnly.toggle()
                query = ""
                category = .all
                tab = .search
                searchFocused = false
            } label: {
                Image(systemName: savedOnly ? "bookmark.fill" : "bookmark").frame(width: 44, height: 44)
            }.accessibilityLabel(savedOnly ? "Show all projects" : "Show saved projects")
            Button { lightAppearance.toggle() } label: {
                Image(systemName: lightAppearance ? "moon" : "sun.max").frame(width: 44, height: 44)
            }.accessibilityLabel(lightAppearance ? "Use dark appearance" : "Use light appearance")
        }
        .foregroundStyle(.primary)
        .padding(.leading, 20).padding(.trailing, 8).padding(.vertical, 8)
    }

    private var hero: some View {
        VStack(spacing: 16) {
            Text("THE OPEN-SOURCE APP STORE")
                .font(.system(.caption2, design: .monospaced, weight: .medium)).tracking(2.2)
                .foregroundStyle(.secondary)
            Text("Find the best\nopen-source\nalternative.")
                .font(.system(size: 37, weight: .bold)).tracking(-1.6)
                .fixedSize(horizontal: false, vertical: true)
            Text("Curated alternatives to the\nsoftware you already use.")
                .font(.body).foregroundStyle(.secondary)
            Text("\(Catalog.projects.count) projects to explore")
                .font(.caption).foregroundStyle(.tertiary)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity).padding(.vertical, 10)
    }

    private var pageTitle: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(savedOnly ? "Your collection." : tab == .search ? "Find your alternative." : tab == .categories ? "A world of possibilities." : tab == .trending ? "Worth a look." : "Fresh discoveries.")
                .font(.largeTitle.bold()).tracking(-1)
            Text(savedOnly ? "Good software, kept close." : "Handpicked software. A little more freedom.")
                .font(.subheadline).foregroundStyle(.secondary)
        }
    }

    private var searchField: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
            TextField("Search open-source alternatives…", text: $query)
                .font(.body).focused($searchFocused)
                .autocorrectionDisabled().textInputAutocapitalization(.never)
                .submitLabel(.search)
                .accessibilityLabel("Search projects or software to replace")
            if !query.isEmpty {
                Button { query = "" } label: {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary).frame(width: 32, height: 32)
                }.accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, 16).frame(minHeight: 54)
        .background(Color.storeSurface, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(.primary.opacity(0.2)))
    }

    private var categoryStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 22) {
                ForEach(Category.allCases) { item in
                    Button {
                        category = item
                        searchFocused = false
                    } label: {
                        VStack(spacing: 7) {
                            Text(item.rawValue).font(.subheadline.weight(.medium))
                                .foregroundStyle(category == item ? .primary : .secondary)
                            Rectangle().fill(category == item ? Color.primary : Color.clear).frame(height: 2)
                        }.padding(.top, 10)
                    }.buttonStyle(.plain)
                        .accessibilityAddTraits(category == item ? .isSelected : [])
                }
            }
        }
    }

    private var popularReplacements: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                Text("Popular replacements").foregroundStyle(.secondary)
                ForEach(["Photoshop", "Notion", "CapCut", "ChatGPT"], id: \.self) { name in
                    Button { query = name; tab = .search } label: {
                        HStack(spacing: 4) { Text(name); Image(systemName: "arrow.up.right").font(.caption2) }
                            .padding(.vertical, 10)
                    }.buttonStyle(.plain)
                }
            }.font(.caption)
        }
    }

    private var featured: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeading(title: "Made to be yours.", actionTitle: "All apps") {
                tab = .search
            }
            Text("Handpicked software. A little more freedom.").font(.subheadline).foregroundStyle(.secondary)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 14) {
                    ForEach(Array(Catalog.projects.prefix(2))) { project in
                        Button { selectedProject = project } label: {
                            FeatureCard(project: project).frame(width: 310)
                        }.buttonStyle(.plain)
                    }
                }.padding(.vertical, 4)
            }
        }
    }

    private var categoryGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 145))], spacing: 12) {
            ForEach(Category.allCases.filter { $0 != .all }) { item in
                Button { category = item } label: {
                    VStack(alignment: .leading, spacing: 18) {
                        Image(systemName: item.symbol).font(.title2).foregroundStyle(.mint)
                        Text(item.rawValue).font(.headline).foregroundStyle(.primary)
                        Text("\(Catalog.search("", category: item).count) projects")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading).padding(18)
                    .background(Color.storeSurface, in: RoundedRectangle(cornerRadius: 16))
                }.buttonStyle(.plain)
            }
        }
    }

    private func projectList(title: String, projects: [Project]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeading(title: title)
            if projects.isEmpty {
                ContentUnavailableView {
                    Label(savedOnly && query.isEmpty ? "No saved projects" : "No matches", systemImage: savedOnly ? "bookmark" : "magnifyingglass")
                } description: {
                    Text(savedOnly && query.isEmpty ? "Open a project and tap Save to keep it here." : "Try another name or choose a different category.")
                } actions: {
                    if !query.isEmpty || category != .all {
                        Button("Clear filters") { query = ""; category = .all }
                    }
                }
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(projects) { project in
                        Button { selectedProject = project } label: {
                            ProjectRow(project: project, saved: savedIDs.contains(project.id))
                        }.buttonStyle(.plain)
                        Divider()
                    }
                }
            }
        }
    }

    private var bottomBar: some View {
        HStack(spacing: 0) {
            ForEach(StoreTab.allCases, id: \.self) { item in
                Button {
                    tab = item
                    query = ""
                    category = .all
                    savedOnly = false
                    searchFocused = item == .search
                } label: {
                    VStack(spacing: 5) {
                        Image(systemName: item.symbol)
                            .font(.system(size: item == .search ? 24 : 21, weight: .medium))
                            .frame(height: 26)
                        if item != .search {
                            Text(item.rawValue).font(.system(size: 10, weight: .semibold))
                        }
                        if tab == item && item != .search {
                            Capsule().frame(width: 14, height: 3)
                        }
                    }
                    .foregroundStyle(item == .search ? Color.storeBackground : tab == item ? Color.primary : Color.secondary)
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .background(item == .search ? Color.primary : Color.clear, in: RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal, item == .search ? 8 : 0)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(item.rawValue)
                .accessibilityAddTraits(tab == item ? .isSelected : [])
            }
        }
        .padding(8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 23))
        .overlay(RoundedRectangle(cornerRadius: 23).strokeBorder(.primary.opacity(0.13)))
        .padding(.horizontal, 12).padding(.bottom, 6).padding(.top, 8)
    }

    private func toggleSave(_ project: Project) {
        var ids = savedIDs
        if ids.contains(project.id) { ids.remove(project.id) } else { ids.insert(project.id) }
        savedProjects = ids.sorted().joined(separator: ",")
    }
}

#Preview { StoreView().preferredColorScheme(.dark) }
