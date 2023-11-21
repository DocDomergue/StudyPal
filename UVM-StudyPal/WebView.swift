import SwiftUI
import WebKit

// The Web view for displaying the UVM login page and handling cookies

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
        
        // Check to see if we get to the login success page
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.body.innerText") { (result, error) in
                if let bodyText = result as? String, bodyText.contains("Logged in as") {
                    let username = bodyText.replacingOccurrences(of: "Logged in as ", with: "")
                    self.parent.onLoginSuccess?(username)
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
}
