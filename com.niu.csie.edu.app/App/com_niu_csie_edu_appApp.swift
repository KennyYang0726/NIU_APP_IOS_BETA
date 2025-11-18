//  com_niu_csie_edu_appApp.swift
//  指定 app 進入點
//  新版寫法，有漸變切換主題效果
import SwiftUI



@main
struct com_niu_csie_edu_appApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var settings = AppSettings()
    @StateObject private var session  = SessionManager()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(settings)
                .environmentObject(session)
                // 不再用 preferredColorScheme 來控制主題，改由 UIKit 管
                .onAppear {
                    // 啟動時套一次目前主題（不動畫）
                    applyTheme(animated: false)
                    // App 啟動後先執行匿名登入
                    FirebaseAuthManager.shared.signInAnonymously()
                }
                .onChange(of: settings.theme) { _ in
                    // 之後每次改 theme 都用淡入淡出
                    applyTheme(animated: true)
                }
        }
    }
    
    // MARK: - 把 AppTheme 轉成 UIKit 的 UIUserInterfaceStyle
    private func uiStyle(for theme: AppTheme) -> UIUserInterfaceStyle {
        switch theme {
        case .default:
            return .unspecified   // 跟隨系統
        case .bright:
            return .light
        case .dark:
            return .dark
        }
    }
    
    // MARK: - 套用主題（可以選擇要不要動畫）
    private func applyTheme(animated: Bool) {
        guard let windowScene = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first,
              let window = windowScene.windows.first
        else { return }
        
        let style = uiStyle(for: settings.theme)
        
        if animated {
            UIView.transition(
                with: window,
                duration: 0.35,
                options: [.transitionCrossDissolve, .allowAnimatedContent],
                animations: {
                    window.overrideUserInterfaceStyle = style
                },
                completion: nil
            )
        } else {
            window.overrideUserInterfaceStyle = style
        }
    }
}


/*
舊版寫法，會瞬間應用切換主題
@main
struct com_niu_csie_edu_appApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var settings = AppSettings()
    @StateObject private var session = SessionManager()

    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(settings)
                .environmentObject(session)
                .preferredColorScheme(resolveColorScheme(settings.theme)) // 即時反映設定改變
                .onAppear {
                    // App 啟動後先執行匿名登入
                    FirebaseAuthManager.shared.signInAnonymously()
                }
        }
    }
    
    // 傳遞當前設置的主題色
    private func resolveColorScheme(_ theme: AppTheme) -> ColorScheme? {
        switch theme {
            case .default:
                return nil
            case .bright:
                return .light
            case .dark:
                return .dark
        }
    }
}
*/
