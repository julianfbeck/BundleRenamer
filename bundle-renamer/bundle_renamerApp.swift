//
//  bundle_renamerApp.swift
//  bundle-renamer
//
//  Created by Julian Beck on 09.05.23.
//

import SwiftUI
final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            let visualEffect = NSVisualEffectView()
            visualEffect.blendingMode = .behindWindow
            visualEffect.state = .active
            visualEffect.material = .underWindowBackground
            
            let hostView = NSHostingView(rootView: ContentView())
            
            window.contentView = visualEffect
            
            visualEffect.addSubview(hostView)
            
            hostView.frame = visualEffect.frame
            
            window.titlebarAppearsTransparent = true
            window.title = "bundle-renamer"
            window.styleMask.remove(.resizable)
            
            window.styleMask.insert(.fullSizeContentView)
        }
    }
}
@main
struct bundle_renamerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView().frame(width: 200, height: 200)
        }
    }
}
