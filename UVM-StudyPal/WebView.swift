import SwiftUI
import WebKit

// Represents a WebView component in SwiftUI
struct WebView: UIViewRepresentable {
    let url: URL
    var onLoginSuccess: ((String) -> Void)?
    
    // Creates the WKWebView instance
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    // Updates the WebView when SwiftUI state changes
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // Creates a Coordinator for handling WebView events
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Coordinator class for WebView
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }
        
        // Handles WebView navigation completion
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.body.innerText") { result, error in
                guard let bodyText = result as? String else { return }
                if bodyText.contains("Logged in as") {
                    let username = bodyText.replacingOccurrences(of: "Logged in as ", with: "")
                    self.parent.onLoginSuccess?(username)
                    self.parent.retrieveCookies()
                }
            }
        }
    }

    // Clears WebView cookies
    static func clearCookies(completion: @escaping () -> Void) {
        let dataStore = WKWebsiteDataStore.default()
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        dataStore.removeData(ofTypes: websiteDataTypes, modifiedSince: Date(timeIntervalSince1970: 0), completionHandler: completion)
    }

    // Retrieves cookies from the WebView
    private func retrieveCookies() {
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies { cookies in
            processAndStoreCookies(cookies)
        }
    }

    // Processes cookies and updates NetworkManager
    private func processAndStoreCookies(_ cookies: [HTTPCookie]) {
        let csrfToken = cookies.first { $0.name == "csrftoken" }?.value
        let sessionId = cookies.first { $0.name == "sessionid" }?.value
        NetworkManager.shared.updateAuthCookies(csrfToken: csrfToken, sessionId: sessionId)
    }
}
