import SwiftUI
import Combine



@MainActor
final class Drawer_AchievementsViewModel: ObservableObject {
    
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad
    
    let features: [AchievementsFeature] = [
        AchievementsFeature(
            iconName: "01_Welcome",
            title: "Achievements_01_Title",
            subtitle: "Achievements_01_Description",
            status: "completed_zh_tw"
        ),
        AchievementsFeature(
            iconName: "02_FeedBack",
            title: "Achievements_02_Title",
            subtitle: "Achievements_02_Description",
            status: "uncompleted_zh_tw"
        ),
        AchievementsFeature(
            iconName: "03_OhBoy3am",
            title: "Achievements_03_Title",
            subtitle: "Achievements_03_Description",
            status: "uncompleted_zh_tw"
        ),
        AchievementsFeature(
            iconName: "04_April_Fools",
            title: "Achievements_04_Title",
            subtitle: "Achievements_04_Description",
            status: "uncompleted_zh_tw"
        ),
        AchievementsFeature(
            iconName: "05_Birthday",
            title: "Achievements_05_Title",
            subtitle: "Achievements_05_Description",
            status: "uncompleted_zh_tw"
        ),
        AchievementsFeature(
            iconName: "06_Constitution_Day",
            title: "Achievements_06_Title",
            subtitle: "Achievements_06_Description",
            status: "uncompleted_zh_tw"
        ),
        AchievementsFeature(
            iconName: "07_100Days",
            title: "Achievements_07_Title",
            subtitle: "Achievements_07_Description",
            status: "uncompleted_zh_tw"
        ),
        AchievementsFeature(
            iconName: "08_Anniversary",
            title: "Achievements_08_Title",
            subtitle: "Achievements_08_Description",
            status: "uncompleted_zh_tw"
        ),
        AchievementsFeature(
            iconName: "09_Unremitting_Efforts",
            title: "Achievements_09_Title",
            subtitle: "Achievements_09_Description",
            status: "uncompleted_zh_tw"
        ),
        AchievementsFeature(
            iconName: "10_Dark_Repulsor",
            title: "Achievements_10_Title",
            subtitle: "Achievements_10_Description",
            status: "uncompleted_zh_tw"
        ),
        AchievementsFeature(
            iconName: "11_Night_Market_Guy",
            title: "Achievements_11_Title",
            subtitle: "Achievements_11_Description",
            status: "uncompleted_zh_tw"
        )
    ]
    
    
}
