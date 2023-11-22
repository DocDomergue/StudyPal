import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    var onLoginSuccess: ((String) -> Void)?
    
    func makeUIView(context: Context) -> WKWebView {

        
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator

        return webView
    }
    
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.body.innerText") { (result, error) in
                if let bodyText = result as? String, bodyText.contains("Logged in as") {
                    let username = bodyText.replacingOccurrences(of: "Logged in as ", with: "")
                    self.parent.onLoginSuccess?(username)
                    self.parent.retrieveCookies()
                }
            }
        }
    }

    // Clear cookies when logging out
    static func clearCookies(completion: @escaping () -> Void) {
        let dataStore = WKWebsiteDataStore.default()
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let date = Date(timeIntervalSince1970: 0)
        dataStore.removeData(ofTypes: websiteDataTypes, modifiedSince: date, completionHandler: completion)
    }

    func retrieveCookies() {
            WKWebsiteDataStore.default().httpCookieStore.getAllCookies { cookies in
                // Process cookies and pass to NetworkManager
                processAndStoreCookies(cookies)
            }
        }

    private func processAndStoreCookies(_ cookies: [HTTPCookie]) {
            let csrfToken = cookies.first(where: { $0.name == "csrftoken" })?.value
            let sessionId = cookies.first(where: { $0.name == "sessionid" })?.value

            // Pass the cookies to NetworkManager
            NetworkManager.shared.updateAuthCookies(csrfToken: csrfToken, sessionId: sessionId)
        }
}
