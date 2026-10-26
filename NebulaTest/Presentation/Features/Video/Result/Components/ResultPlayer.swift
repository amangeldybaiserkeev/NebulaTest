import AVFoundation
import SwiftUI

struct ResultPlayer: View {
    let url: URL
    let isPlaying: Bool
    let onReplace: () -> Void

    @State private var player: AVPlayer?

    private let playIconWidth: Double = 39
    private let playIconHeight: Double = 45

    private var playbackEnded: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }

    var body: some View {
        Group {
            if let player {
                VideoPlayerView(player: player)
            } else {
                Color.black
            }
        }
            .overlay {
                if !isPlaying {
                    Color.black.opacity(Opacity.muted)
                    Image(.icPlay56)
                        .resizable()
                        .frame(width: playIconWidth, height: playIconHeight)
                        .foregroundStyle(.white)
                }
            }
            .overlay(alignment: .topTrailing) {
                if !isPlaying {
                    ReplaceButton(action: onReplace)
                        .padding(Spacing.reg)
                }
            }
            .animation(Animations.state, value: isPlaying)
            .onAppear {
                guard player == nil else { return }
                let player = AVPlayer(url: url)
                self.player = player
                if isPlaying { player.play() }
            }
            .onChange(of: isPlaying) { isPlaying in
                isPlaying ? player?.play() : player?.pause()
            }
            .onReceive(playbackEnded) { _ in
                guard let player else { return }
                player.seek(to: .zero)
                player.play()
            }
            .onDisappear { player?.pause() }
    }
}
