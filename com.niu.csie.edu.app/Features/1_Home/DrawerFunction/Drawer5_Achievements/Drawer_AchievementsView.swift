import SwiftUI



struct Drawer_AchievementsView: View {
    
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad
    @StateObject private var vm = Drawer_AchievementsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: isPad ? 13 : 7) {
                    ForEach(Array(vm.features.enumerated()), id: \.offset) { index, feature in
                        let content = Drawer_Achievements_ListView(feature: feature, index: index)
                        if index == vm.features.count - 1 {
                            Button {
                                print("夜市星人被點擊")
                            } label: {
                                content
                            }
                            .buttonStyle(.plain)
                        } else {
                            content
                        }
                    }

                }
                .padding(.top, 10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("Linear").ignoresSafeArea())
    }
}
