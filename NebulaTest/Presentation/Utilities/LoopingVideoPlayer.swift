import AVFoundation
import SwiftUI

struct LoopingVideoPlayer: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        view.play(url)
        return view
    }

    func updateUIView(_ uiView: PlayerView, context: Context) {
        if uiView.url != url {
            uiView.play(url)
        }
    }

    static func dismantleUIView(_ uiView: PlayerView, coordinator: ()) {
        uiView.stop()
    }

    final class PlayerView: UIView {
        private(set) var url: URL?
        private var looper: AVPlayerLooper?

        override static var layerClass: AnyClass {
            AVPlayerLayer.self
        }

        private var playerLayer: AVPlayerLayer? {
            layer as? AVPlayerLayer
        }

        func play(_ url: URL) {
            self.url = url
            let player = AVQueuePlayer()
            player.isMuted = true
            looper = AVPlayerLooper(player: player, templateItem: AVPlayerItem(url: url))
            playerLayer?.videoGravity = .resizeAspectFill
            playerLayer?.player = player
            player.play()
        }

        func stop() {
            playerLayer?.player?.pause()
            playerLayer?.player = nil
            looper = nil
        }
    }
}
