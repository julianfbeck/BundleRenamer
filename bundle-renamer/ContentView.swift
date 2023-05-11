//
//  ContentView.swift
//  bundle-renamer
//
//  Created by Julian Beck on 09.05.23.
//

import SwiftUI
struct VisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()

        view.blendingMode = .behindWindow
        view.state = .active
        view.material = .underWindowBackground
        
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        //
    }
}
struct ContentView: View {
    @StateObject private var viewModel = XcodeProjectViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Drop your Xcode project here")
                .font(.title2)
                .fontWeight(.bold)
            
            if let url = viewModel.droppedXcodeProjectURL {
                Text("Selected folder:")
                    .font(.headline)
                    .padding(.top)

                Text(url.path)
                    .font(.callout)
                    .foregroundColor(.accentColor)
                    .padding(.bottom)
            }
            
            Button(action: {
                viewModel.promptForDirectory()
            }) {
                VStack {
                    Spacer()
                    Text("Select a folder")
                        .padding()
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.accentColor.opacity(0.1))
                .cornerRadius(8)
            }
            .onDrop(of: [.fileURL], isTargeted: nil) { providers in
                Task {
                    await viewModel.loadDroppedItem(item: providers.first!)
                }
                return true
            }.buttonStyle(.plain)
           
        }
        .background(Color.black.opacity(0))
        .padding()
        
        .background(VisualEffectView())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
