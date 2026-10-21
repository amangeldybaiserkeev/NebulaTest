import AVFoundation
import SwiftUI

struct VideoPlayerView: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        view.attach(player)
        return view
    }

    func updateUIView(_ uiView: PlayerView, context: Context) {
        uiView.attach(player)
    }

    final class PlayerView: UIView {
        override static var layerClass: AnyClass {
            AVPlayerLayer.self
        }

        func attach(_ player: AVPlayer) {
            guard let playerLayer = layer as? AVPlayerLayer, playerLayer.player !== player else { return }
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.player = player
        }
    }
}
