import SwiftUI

// MARK: - Message Model

enum AlertMessage {
    case plain(LocalizedStringKey)
    case rich([AlertMessagePart])
}

enum AlertMessagePart: Identifiable {
    case text(String)
    case textKey(LocalizedStringKey)
    case link(text: String, id: String)
    case linkKey(key: LocalizedStringKey, id: String)

    var id: String {
        UUID().uuidString
    }
}

// MARK: - Main View

struct CustomAlertOverlay2: View {

    let title: LocalizedStringKey
    let icon: Image?
    let message: AlertMessage
    let onCancel: () -> Void
    let onConfirm: () -> Void

    // link action map
    let linkActions: [String: () -> Void]?

    @Environment(\.colorScheme) private var scheme
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {

        let P = DialogPalette(scheme)

        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()

            VStack(spacing: 0) {

                // ===== 標題列 =====
                HStack {
                    Text(title)
                        .font(.system(size: isPad ? 26 : 17, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, isPad ? 14 : 10)
                        .padding(.horizontal, isPad ? 11 : 7)

                    if let icon = icon {
                        icon
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: isPad ? 28 : 20, height: isPad ? 28 : 20)
                            .padding(.trailing, isPad ? 17 : 11)
                    }
                }
                .background(P.titleBG)
                .clipShape(
                    RoundedCornerShape(
                        radius: isPad ? 18 : 12,
                        corners: [.topLeft, .topRight]
                    )
                )

                // ===== 白色內容區 =====
                VStack(alignment: .leading, spacing: isPad ? 24 : 14) {

                    Group {
                        switch message {
                        case .plain(let key):
                            Text(key)
                                .font(.system(size: isPad ? 23 : 15))
                                .foregroundColor(Color("Text_Color"))
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 12)

                        case .rich(let parts):
                            if let linkActions {
                                RichTextMessageView(parts: parts, linkActions: linkActions)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 12)
                            } else {
                                // 沒有 linkActions 就當作純文字處理
                                RichTextMessageView(parts: parts, linkActions: [:])
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 12)
                            }
                        }
                    }

                    // ---- 按鈕列 ----
                    HStack(spacing: isPad ? 22 : 16) {
                        Button(action: onCancel) {
                            Text("Dialog_Cancel")
                                .font(.system(size: isPad ? 23 : 15))
                                .frame(minWidth: isPad ? 120 : 90)
                                .padding(isPad ? 17 : 11)
                        }
                        .buttonStyle(DialogButtonStyle(bg: P.buttonBlue, fg: .white))
                        .frame(maxWidth: .infinity)

                        Button(action: onConfirm) {
                            Text("Dialog_OK")
                                .font(.system(size: isPad ? 23 : 15))
                                .frame(minWidth: isPad ? 120 : 90)
                                .padding(isPad ? 17 : 11)
                        }
                        .buttonStyle(DialogButtonStyle(bg: P.buttonBlue, fg: .white))
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, isPad ? 60 : 40)
                    .padding(.bottom, isPad ? 10 : 6)
                }
                .padding(isPad ? 32 : 20)
                .background(P.cardBG)
                .clipShape(
                    RoundedCornerShape(
                        radius: isPad ? 18 : 12,
                        corners: [.bottomLeft, .bottomRight]
                    )
                )
            }
            .frame(maxWidth: isPad ? 700 : 640)
            .shadow(radius: isPad ? 30 : 20)
            .padding(.horizontal, isPad ? 40 : 20)
        }
    }
}

// MARK: - Rich Text View (AttributedString + URL + linkActions)

struct RichTextMessageView: View {

    let parts: [AlertMessagePart]
    let linkActions: [String: () -> Void]

    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        let attributed = buildAttributedString()

        Text(attributed)
            .font(.system(size: isPad ? 23 : 15))
            .multilineTextAlignment(.center)
            // 攔截所有 URL 開啟請求，自己處理 linkActions
            .environment(\.openURL, OpenURLAction { url in
                // 只處理我們自訂的 myapp://alertlink/{id}
                guard url.scheme == "myapp",
                      url.host == "alertlink",
                      let id = url.path.split(separator: "/").map(String.init).last
                else {
                    // 其他 URL（如果有真正的 http link）交回系統處理
                    return .systemAction
                }

                linkActions[id]?()
                return .handled
            })
    }

    // 把所有 parts 組成一個 AttributedString
    private func buildAttributedString() -> AttributedString {
        var result = AttributedString()

        for part in parts {
            switch part {

            case .text(let s):
                appendText(&result, s)

            case .textKey(let key):
                let raw = extractKey(from: key)
                let localized = NSLocalizedString(raw, comment: "")
                appendText(&result, localized)

            case .link(let text, let id):
                appendLink(&result, text: text, id: id)

            case .linkKey(let key, let id):
                let raw = extractKey(from: key)
                let localized = NSLocalizedString(raw, comment: "")
                appendLink(&result, text: localized, id: id)
            }
        }
        return result
    }

    // 一般文字（顏色用 app 的 Text_Color）
    private func appendText(_ result: inout AttributedString, _ text: String) {
        var attributed = AttributedString(text)
        attributed.foregroundColor = Color("Text_Color")
        result.append(attributed)
    }

    // 可點擊連結
    private func appendLink(_ result: inout AttributedString, text: String, id: String) {
        var attributed = AttributedString(text)
        // 用自訂 scheme + id 當識別
        attributed.link = URL(string: "myapp://alertlink/\(id)")
        attributed.foregroundColor = .blue
        attributed.underlineStyle = .single
        result.append(attributed)
    }

    // 從 LocalizedStringKey 中抽出原始 key 字串
    private func extractKey(from key: LocalizedStringKey) -> String {
        let mirror = Mirror(reflecting: key)
        if let value = mirror.children.first(where: { $0.label == "key" })?.value as? String {
            return value
        }
        return String(describing: key)
    }
}

/*
// textKey + linkKey + link +  text 4 者混用
#Preview {
    CustomAlertOverlay2(
        title: "String",
        icon: nil,
        message: .rich([
            .textKey("EUNI_First_Loading_Tip"),
            .linkKey(key: "EUNI_Sub_Item1", id: "terms"),
            .text("\n\n 與 \n"),
            .link(text: "隱私權政策", id: "privacy"),
            .text("，才能繼續使用本服務。")
        ]),
        onCancel: {},
        onConfirm: {},
        linkActions: [
            "terms": {
                print("點擊：使用條款")
            },
            "privacy": {
                print("點擊：隱私權政策")
            }
        ]
    )
}
*/
