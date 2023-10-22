import SwiftUI

struct ContentView: View {
    @State private var volume: Double = 0.5

    var body: some View {
        ZStack {
            Image("blurred")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VolumeView(
                volume: $volume
            )
        }
    }
}

struct VolumeView: View {
    @Binding var volume: Double
    
    let size: CGSize = .init(width: 100, height: 240)
    let scale = 0.8
    
    @State var originalHeight: CGFloat = 0
    @State var gestureProgress = 0.0
    @State private var scaled: Double = 1
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .frame(width: size.width, height: size.height)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(.white)
                        .frame(height: size.height * max(min(volume, 1),0), alignment: .bottom)
                }
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .gesture(
                    DragGesture(coordinateSpace: .local)
                        .onChanged { gesture in
                            let delta = (gestureProgress - gesture.translation.height) / size.height
                            volume = volume + delta
                            gestureProgress = gesture.translation.height
                            scaled = volume >= 1 || volume <= 0 ? scale : 1
                        }
                        .onEnded { _ in
                            volume = max(min(volume, 1),0)
                            gestureProgress = 0
                            scaled = 1
                        }
                )
        }
        .scaleEffect(x: scaled, y: 1 + (1 - scaled), anchor: volume >= 1 ? .bottom : .top)
        .animation(.easeInOut(duration: 0.5), value: scaled)
    }
}
