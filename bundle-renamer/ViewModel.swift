//
//  ViewModel.swift
//  bundle-renamer
//
//  Created by Julian Beck on 09.05.23.
//

import Foundation
import SwiftUI

class XcodeProjectViewModel: ObservableObject {
    @Published var droppedXcodeProjectURL: URL?

    func loadDroppedItem(item: NSItemProvider) async {
        if item.hasItemConformingToTypeIdentifier("public.file-url") {
            do {
                let data = try await item.loadItem(forTypeIdentifier: "public.file-url") as? Data
                if let data = data, let url = URL(dataRepresentation: data, relativeTo: nil) {
                    DispatchQueue.main.async {
                        self.droppedXcodeProjectURL = url
                        self.listFilesInDirectory(url: url.isDirectory ? url : url.deletingLastPathComponent())
                    }
                }
            } catch {
                print("Error loading item: \(error)")
            }
        }
    }
  
    func listFilesInDirectory(url: URL) {
        let fileManager = FileManager.default
        
        do {
            let contents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for fileURL in contents {
                print("File: \(fileURL.lastPathComponent)")
            }
        } catch {
            print("Error listing files in directory: \(error)")
        }
    }
    func promptForDirectory() {
           let openPanel = NSOpenPanel()
           openPanel.title = "Select a folder"
           openPanel.showsResizeIndicator = true
           openPanel.showsHiddenFiles = false
           openPanel.canChooseFiles = false
           openPanel.canChooseDirectories = true
           openPanel.canCreateDirectories = false
           openPanel.allowsMultipleSelection = false

           if openPanel.runModal() == .OK {
               if let url = openPanel.url {
                   DispatchQueue.main.async {
                       self.droppedXcodeProjectURL = url
                       self.listFilesInDirectory(url: url)
                   }
               }
           }
       }
}
extension URL {
    var isDirectory: Bool {
        var isDirectory: ObjCBool = false
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path, isDirectory: &isDirectory) {
            return isDirectory.boolValue
        } else {
            return false
        }
    }
}
