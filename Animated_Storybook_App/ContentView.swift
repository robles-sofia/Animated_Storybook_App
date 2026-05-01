
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
    //interaction states
    @State private var textIndex = 0
    @State private var unlocked = false

    
    
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Angle = .degrees(0)
    @State private var dragOffset: CGSize = .zero
    
    let pages: [StoryPage] = [
        StoryPage(
            title: "The Forest",
            text: "Once upon a time, in a magical forest, a little girl followed a glowing path. The trees whispered as she passed, and the birds sang songs to guide her along safely.",
            color: .green
        ),
        StoryPage(
            title: "The Ocean",
            text: "The girl reached a clearing in the trees, and was met with a vast, blue ocean. The waves shimmered and something beyond them seemed to call out to the girl. Cautiously, she waded into the water and extended her hand, fingertips swirling the surface of the water.",
            color: .blue
        ),
        StoryPage(
            title: "The Sky",
            text: "With little warning, the girl was swept from the ground and found herself soaring atop a manta ray. The wind stung her cheeks, but she felt no fear. The girl and her new friend rose towards the clouds, chasing the sunset. They soard through the vibrant orange and pink sky, away from the forest and ocean.",
            color: .purple),
        StoryPage(
            title: "The Desert",
            text: "Before long, the sun dipped below the horizon, and the stars began to shine. Below the girl, golden sands stretched across her view. The deeper she soared into the desert, the more stars appeared, creating a dome of twinkling clusters up above.",
            color: .orange),
        StoryPage(
            title: "The Ending",
            text: "The manta ray took the girl above the clouds, obscuring the desert from view. When they descended again, the girl recognized her home. She slid off the gentle sea creature, through her bedroom window, and onto her bed. She turned around to wave goodbye, but saw only the moon surrounded by darkness.",
            color: .black)
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
                                    .overlay(
                                        Text(page.title)
                                            .foregroundColor(.white)
                                            .font(.headline)
                                    )
                                    .matchedGeometryEffect(id: page.id, in: animation)
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            selectedPage = page
                                            
                                            //reset states
                                            textIndex = 0
                                            unlocked = false
                                            scale = 1.0
                                            rotation = .zero
                                            dragOffset = .zero
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                }
                //detail view
                else if let page = selectedPage {
                    
                    let storyParts = page.text
                        .components(separatedBy: ".")
                        .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
                    
                    
                    ZStack {
                        //parallax background
                        GeometryReader { geo in
                            page.color
                                .offset(y: geo.frame(in: .global).minY * -0.3)
                                .ignoresSafeArea()
                        }
                        .matchedGeometryEffect(id: page.id, in: animation)
                        
                        VStack (spacing: 20) {
                            Text(page.title)
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)
                            
                            //tap to show text
                            VStack {
                                ForEach(0..<textIndex, id: \.self) { i in
                                    Text(storyParts[i] + ".")
                                        .foregroundColor(.white)
                                        .transition(.opacity)
                                }
                            }
                            
                            //interactive object
                            Circle()
                                .fill(Color.white)
                                .frame(width: 80, height: 80)
                                .scaleEffect(scale)
                                .rotationEffect(rotation)
                                .offset(dragOffset)
                                .gesture(
                                    SimultaneousGesture(
                                        MagnificationGesture()
                                            .onChanged { scale = $0 },
                                        RotationGesture()
                                            .onChanged { rotation = $0 }
                                    )
                                )
                                .gesture(
                                    DragGesture()
                                        .onChanged { dragOffset = $0.translation }
                                        .onEnded { _ in
                                            withAnimation(.spring()) {
                                                dragOffset = .zero
                                            }
                                        }
                                )
                            
                            //bounce animation on tap
                                .onTapGesture {
                                    withAnimation(.interpolatingSpring(stiffness: 200, damping: 5)) {
                                        scale = 1.5
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        scale = 1.0
                                    }
                                }
                            
                            //hidden unlock content
                            if unlocked {
                                Text("You've discovered a hidden path!")
                                    .foregroundColor(.yellow)
                                    .transition(.scale)
                            }
                            
                            
                            Button("Back") {
                                withAnimation(.easeInOut) {
                                    selectedPage = nil
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                        .padding()
                    }
                    .contentShape(Rectangle())
                    
                    .onTapGesture {
                        withAnimation {
                            if textIndex < storyParts.count {
                                textIndex += 1
                            }
                        }
                    }
                            
                            //sequenced gesture (long press and tap)
                    .gesture(
                        LongPressGesture(minimumDuration: 1.0)
                            .sequenced(before: TapGesture())
                            .onEnded { value in
                                switch value {
                                case.second(true, _):
                                    withAnimation(.spring()) {
                                        unlocked = true
                                    }
                                default:
                                    break
                                }
                            }
                        )
                        .transition(.scale)
                    }
                }
            }
        }
    }



#Preview {
    ContentView()
}
