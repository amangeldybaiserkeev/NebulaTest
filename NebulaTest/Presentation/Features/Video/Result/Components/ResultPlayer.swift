import AVFoundation
import SwiftUI

struct ResultPlayer: View {
    let url: URL
    let isPlaying: Bool
    let onReplace: () -> Void

    @State private var player: AVPlayer

    private let playIconWidth: Double = 39
    private let playIconHeight: Double = 45

    init(url: URL, isPlaying: Bool, onReplace: @escaping () -> Void) {
        self.url = url
        self.isPlaying = isPlaying
        self.onReplace = onReplace
        _player = State(initialValue: AVPlayer(url: url))
    }

    private var playbackEnded: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }

    var body: some View {
        VideoPlayerView(player: player)
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
            .onChange(of: isPlaying) { isPlaying in
                isPlaying ? player.play() : player.pause()
            }
            .onReceive(playbackEnded) { _ in
                player.seek(to: .zero)
                player.play()
            }
            .onDisappear(perform: player.pause)
    }
}
