import SwiftUI
import Combine

struct SidebarHeaderView: View {
    let viewModel: ContainerViewModel

    var body: some View {
        HStack {
            Text("Manage")
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
            Button(action: {
                viewModel.showCreateSheet()
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.accentColor)
            }
            .buttonStyle(PlainButtonStyle())
            .glassEffect()
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            .accessibilityLabel("Add new container")
            .accessibilityHint("Opens a wizard to create and configure a new container.")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.thickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct SidebarRowView: View {
    let category: NavigationCategory
    @Binding var selectedCategory: NavigationCategory?
    let namespace: Namespace.ID

    var body: some View {
        NavigationLink(value: category) {
            Label(category.rawValue, systemImage: category.systemImage)
        }
        .accessibilityHint("Navigate to the \(category.rawValue) section")
        .listRowBackground(
            ZStack {
                if selectedCategory == category {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.accentColor.opacity(0.6))
                        .glassEffect()
                        .matchedGeometryEffect(id: "sidebar.selection", in: namespace)
                }
            }
        )
    }
}

struct SidebarView: View {
    @EnvironmentObject var viewModel: ContainerViewModel
    @Namespace private var namespace

    var body: some View {
        List(selection: $viewModel.selectedCategory) {
            Section(header: SidebarHeaderView(viewModel: viewModel)) {
                ForEach(NavigationCategory.allCases) { category in
                    SidebarRowView(category: category, selectedCategory: $viewModel.selectedCategory, namespace: namespace)
                }
            }
        }
        .listStyle(.sidebar)
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
            .environmentObject(ContainerViewModel(containerService: MockContainerService()))
    }
}
