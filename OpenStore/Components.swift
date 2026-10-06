import SwiftUI
import UIKit

extension Color {
    static let storeBackground = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.055, green: 0.059, blue: 0.063, alpha: 1)
            : UIColor.systemBackground
    })
    static let storeSurface = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.075, green: 0.078, blue: 0.086, alpha: 1)
            : UIColor.secondarySystemBackground
    })
    static func projectAccent(_ name: String) -> Color {
        switch name {
        case "blue": return .cyan
        case "purple": return .purple
        case "orange": return .orange
        default: return .mint
        }
    }
}

struct ProjectIcon: View {
    let project: Project
    var size: CGFloat = 48
    var body: some View {
        Image(systemName: project.symbol)
            .font(.system(size: size * 0.45, weight: .semibold))
            .foregroundStyle(Color.projectAccent(project.color))
            .frame(width: size, height: size)
            .background(Color.projectAccent(project.color).opacity(0.13), in: RoundedRectangle(cornerRadius: size * 0.25))
            .overlay(RoundedRectangle(cornerRadius: size * 0.25).strokeBorder(.primary.opacity(0.07)))
            .accessibilityHidden(true)
    }
}

struct ProjectRow: View {
    let project: Project
    let saved: Bool
    var body: some View {
        HStack(spacing: 14) {
            ProjectIcon(project: project)
            VStack(alignment: .leading, spacing: 5) {
                Text(project.name).font(.headline)
                Text("Alternative to \(project.alternative)").font(.subheadline).foregroundStyle(.secondary)
                Text(project.category.rawValue).font(.caption).foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
            Image(systemName: saved ? "bookmark.fill" : "arrow.up.right")
                .foregroundStyle(saved ? Color.mint : Color.secondary)
        }
        .padding(.vertical, 16)
        .contentShape(Rectangle())
    }
}

struct FeatureCard: View {
    let project: Project
    var coding: Bool { project.id == "opencode" }
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 14) {
                Text(coding ? "THE DEVELOPER’S PICK" : "CREATIVITY, UNCUT")
                    .font(.system(.caption2, design: .monospaced, weight: .bold))
                    .tracking(2).foregroundStyle(.white.opacity(0.65))
                HStack(alignment: .top, spacing: 2) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(coding ? "Your next\ncoding\ncompanion." : "Your story.\nYour editor.")
                            .font(.system(.title, design: .rounded, weight: .bold))
                            .tracking(-1)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(coding ? "Meet OpenCode.\nMake something great." : "Create without\nthe subscription.")
                            .font(.subheadline).foregroundStyle(.white.opacity(0.65))
                    }
                    Spacer(minLength: 0)
                    FeatureArtwork(coding: coding).frame(width: 98, height: 125).padding(.top, 14)
                }
            }
            .foregroundStyle(.white)
            .padding(22)
            .frame(maxWidth: .infinity, minHeight: 245, alignment: .topLeading)
            .background(coding ? Color(red: 0.13, green: 0.25, blue: 0.20) : Color(red: 0.15, green: 0.21, blue: 0.28))
            HStack(spacing: 12) {
                ProjectIcon(project: project, size: 42)
                VStack(alignment: .leading, spacing: 5) {
                    Text(project.name).font(.headline)
                    Text("Alternative to \(project.alternative)").font(.caption).foregroundStyle(.secondary)
                }
                Spacer(minLength: 0)
                Image(systemName: "arrow.right").foregroundStyle(.secondary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.storeSurface)
        }
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(.primary.opacity(0.12)))
        .contentShape(RoundedRectangle(cornerRadius: 18))
    }
}

struct FeatureArtwork: View {
    let coding: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 3) {
                ForEach(0..<3) { index in
                    Circle().fill([Color.orange, .yellow, .mint][index]).frame(width: 4, height: 4)
                }
            }
            Rectangle().fill(.white.opacity(0.12)).frame(height: 1)
            if coding {
                Text("❯ opencode").font(.system(size: 9, design: .monospaced)).foregroundStyle(.mint)
                Text("const idea =\n  'something great';\n\nawait build(idea);")
                    .font(.system(size: 7, design: .monospaced)).foregroundStyle(.white.opacity(0.7))
                ForEach(0..<3) { index in
                    Capsule().fill(.mint.opacity(0.35)).frame(width: CGFloat(65 - index * 12), height: 2)
                }
            } else {
                Image(systemName: "mountain.2.fill")
                    .font(.system(size: 36)).foregroundStyle(Color(red: 0.25, green: 0.46, blue: 0.46))
                    .frame(maxWidth: .infinity, minHeight: 55)
                    .background(Color(red: 0.86, green: 0.65, blue: 0.46))
                ForEach(0..<3) { index in
                    RoundedRectangle(cornerRadius: 2).fill(index == 1 ? .purple.opacity(0.6) : .mint.opacity(0.5)).frame(height: 5)
                }
            }
        }
        .padding(9)
        .background(Color.black.opacity(0.4), in: RoundedRectangle(cornerRadius: 7))
        .overlay(RoundedRectangle(cornerRadius: 7).strokeBorder(.white.opacity(0.3)))
        .rotationEffect(.degrees(-5))
        .accessibilityHidden(true)
    }
}

struct SectionHeading: View {
    let title: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .firstTextBaseline) {
                Text(title).font(.title2.bold()).tracking(-0.6)
                Spacer()
                actionButton
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(title).font(.title2.bold()).tracking(-0.6)
                actionButton
            }
        }
    }
    @ViewBuilder private var actionButton: some View {
        if let actionTitle, let action {
            Button(action: action) {
                HStack(spacing: 5) {
                    Text(actionTitle)
                    Image(systemName: "chevron.right").font(.caption)
                }.font(.caption.weight(.medium)).foregroundStyle(.secondary)
                    .padding(.vertical, 10)
            }.buttonStyle(.plain)
        }
    }
}
