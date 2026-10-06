import Foundation

enum Category: String, CaseIterable, Identifiable {
    case all = "All apps", ai = "AI", developer = "Developer Tools", design = "Design"
    case productivity = "Productivity", video = "Video", privacy = "Privacy"
    var id: String { rawValue }
    var symbol: String {
        switch self {
        case .all: return "square.grid.2x2"
        case .ai: return "sparkles"
        case .developer: return "chevron.left.forwardslash.chevron.right"
        case .design: return "paintpalette"
        case .productivity: return "checkmark.seal"
        case .video: return "film"
        case .privacy: return "lock.shield"
        }
    }
}

struct Project: Identifiable, Hashable {
    let id: String
    let name: String
    let alternative: String
    let category: Category
    let symbol: String
    let color: String
    let summary: String
    let website: String
    let repository: String

    var websiteURL: URL { URL(string: website)! }
    var repositoryURL: URL { URL(string: repository)! }
}

enum Catalog {
    // A bundled starter catalog, not a live feed from openstore.site.
    static let projects: [Project] = [
        Project(id: "opencode", name: "OpenCode", alternative: "Claude Code", category: .developer, symbol: "terminal", color: "mint", summary: "An open-source AI coding agent for your terminal. Work with your preferred model and keep your development workflow your own.", website: "https://opencode.ai", repository: "https://github.com/anomalyco/opencode"),
        Project(id: "opencut", name: "OpenCut", alternative: "CapCut", category: .video, symbol: "video", color: "blue", summary: "A free, open-source video editor for creating and editing your next story.", website: "https://opencut.app", repository: "https://github.com/OpenCut-app/OpenCut"),
        Project(id: "open-notebook", name: "Open Notebook", alternative: "NotebookLM", category: .ai, symbol: "circle.hexagongrid.fill", color: "purple", summary: "Your research, connected. An open-source notebook for organizing sources and exploring knowledge with AI.", website: "https://www.open-notebook.ai", repository: "https://github.com/lfnovo/open-notebook"),
        Project(id: "open-webui", name: "Open WebUI", alternative: "ChatGPT", category: .ai, symbol: "bubble.left.and.bubble.right", color: "mint", summary: "A self-hosted interface for chatting with language models. Connect supported local or remote models in your own workspace.", website: "https://openwebui.com", repository: "https://github.com/open-webui/open-webui"),
        Project(id: "gimp", name: "GIMP", alternative: "Photoshop", category: .design, symbol: "paintbrush.pointed", color: "orange", summary: "A powerful image editor for photo retouching, original artwork, and creative compositions.", website: "https://www.gimp.org", repository: "https://gitlab.gnome.org/GNOME/gimp"),
        Project(id: "penpot", name: "Penpot", alternative: "Figma", category: .design, symbol: "pentagon", color: "purple", summary: "An open-source design platform that connects designers and developers through collaborative interfaces and prototypes.", website: "https://penpot.app", repository: "https://github.com/penpot/penpot"),
        Project(id: "appflowy", name: "AppFlowy", alternative: "Notion", category: .productivity, symbol: "square.stack.3d.up", color: "blue", summary: "Bring notes, tasks, and projects together in a customizable workspace built around control of your data.", website: "https://appflowy.io", repository: "https://github.com/AppFlowy-IO/AppFlowy"),
        Project(id: "affine", name: "AFFiNE", alternative: "Notion", category: .productivity, symbol: "a.square", color: "orange", summary: "A workspace that combines documents, whiteboards, and databases for planning and creating.", website: "https://affine.pro", repository: "https://github.com/toeverything/AFFiNE"),
        Project(id: "kdenlive", name: "Kdenlive", alternative: "Premiere Pro", category: .video, symbol: "film.stack", color: "blue", summary: "A flexible desktop video editor with multitrack editing, effects, and tools for complex productions.", website: "https://kdenlive.org", repository: "https://invent.kde.org/multimedia/kdenlive"),
        Project(id: "inkscape", name: "Inkscape", alternative: "Illustrator", category: .design, symbol: "scribble.variable", color: "mint", summary: "Create scalable vector illustrations, diagrams, logos, and typography with a full-featured SVG editor.", website: "https://inkscape.org", repository: "https://gitlab.com/inkscape/inkscape"),
        Project(id: "bitwarden", name: "Bitwarden", alternative: "1Password", category: .privacy, symbol: "shield.lefthalf.filled", color: "blue", summary: "An open-source password manager for storing and sharing credentials across your devices.", website: "https://bitwarden.com", repository: "https://github.com/bitwarden/clients"),
        Project(id: "signal", name: "Signal", alternative: "WhatsApp", category: .privacy, symbol: "message", color: "purple", summary: "Private messaging with end-to-end encryption for conversations, calls, and groups.", website: "https://signal.org", repository: "https://github.com/signalapp/Signal-iOS"),
        Project(id: "vscodium", name: "VSCodium", alternative: "Visual Studio Code", category: .developer, symbol: "curlybraces", color: "blue", summary: "Community-built binaries of the VS Code editor with a focus on open-source distribution.", website: "https://vscodium.com", repository: "https://github.com/VSCodium/vscodium"),
        Project(id: "ollama", name: "Ollama", alternative: "ChatGPT", category: .ai, symbol: "sparkle", color: "orange", summary: "Run supported language models locally and use them in your own applications and workflows.", website: "https://ollama.com", repository: "https://github.com/ollama/ollama"),
        Project(id: "joplin", name: "Joplin", alternative: "Evernote", category: .productivity, symbol: "note.text", color: "blue", summary: "An open-source note-taking app with notebooks, to-dos, and synchronization options.", website: "https://joplinapp.org", repository: "https://github.com/laurent22/joplin")
    ]

    static func search(_ query: String, category: Category = .all, in projects: [Project] = Catalog.projects) -> [Project] {
        let terms = query.split(whereSeparator: { $0.isWhitespace }).map(String.init)
        return projects.filter { project in
            (category == .all || project.category == category) && terms.allSatisfy { term in
                "\(project.name) \(project.alternative) \(project.category.rawValue) \(project.summary)"
                    .localizedStandardContains(term)
            }
        }
    }
}
