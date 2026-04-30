

import SwiftUI

struct StoryPage: Identifiable {
    let id = UUID()
    let title: String
    let text: String
    let color: Color
}

struct ContentView: View {
    @Namespace var animation
    @State private var selectedPage: StoryPage? = nil
    @State private var showText = false
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Angle = .degrees(0)
    @State private var dragOffset: CGSize = .zero
    
    let pages: [StoryPage] = [
        StoryPage(title: "The Forest", text: "Once upon a time, in a magical forest...", color: .green),
        StoryPage(title: "The Ocean", text: "Deep in the vast blue sea lived...", color: .blue),
        StoryPage(title: "The Sky", text: "Up above the clouds soared...", color: .purple),
        StoryPage(title: "The Desert", text: "Across the hot, golden sands wandered...", color: .orange)
    ]
    
    var body: some View {
        
    }
}



#Preview {
    ContentView()
}
