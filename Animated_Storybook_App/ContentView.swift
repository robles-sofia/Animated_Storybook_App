

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
        GeometryReader { geo in
            ZStack {
                if selectedPage == nil {
                    //grid view
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 20) {
                            
                            ForEach(pages) { page in
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(page.color)
                                    .frame(height: geo.size.height * 0.25)
                                    .overlay(Text(page.title).foregroundColor(.white))
                                    .matchedGeometryEffect(id: page.id, in: animation)
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            selectedPage = page
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                } else {
                    //detail view
                    if let page = selectedPage {
                        ZStack {
                            page.color
                                .ignoresSafeArea()
                                .matchedGeometryEffect(id: page.id, in: animation)
                            
                            VStack (spacing: 20) {
                                Text(page.title)
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(.white)
                                
                                if showText {
                                    Text(page.text)
                                        .foregroundColor(.white)
                                        .transition(.opacity)
                                }
                                
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 80, height: 80)
                                    .scaleEffect(scale)
                                    .rotationEffect(rotation)
                                    .offset(dragOffset)
                                    .gesture(
                                        SimultaneousGesture(
                                            MagnificationGesture()
                                                .onChanged { value in
                                                    scale = value
                                                },
                                            RotationGesture()
                                                .onChanged { value in
                                                    rotation = value
                                                }
                                        )
                                    )
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                dragOffset = value.translation
                                            }
                                            .onEnded { _ in
                                                withAnimation(.spring()) {
                                                    dragOffset = .zero
                                                }
                                            }
                                    )
                                
                                Button("Back") {
                                    withAnimation(.easeInOut) {
                                        selectedPage = nil
                                        showText = false
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                            .onTapGesture {
                                withAnimation {
                                    showText.toggle()
                                }
                            }
                        }
                        .transition(.scale)
                    }
                }
            }
        }
    }
}



#Preview {
    ContentView()
}
