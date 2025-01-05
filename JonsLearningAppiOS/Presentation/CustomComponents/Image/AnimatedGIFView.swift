//
//  AnimatedGIFView.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 1/5/25.
//

import SwiftUI
import ImageIO

struct AnimatedGIFView: View {
    @State private var frames: [Image] = []
    @State private var currentFrameIndex = 0
    @State private var timer: Timer?

    let gifName: String
    let frameDuration: Double = 1.0 / 40.0 // ~16.67 ms per frame for 60 fps

    var body: some View {
        if !frames.isEmpty {
            frames[currentFrameIndex]
                .resizable()
                .scaledToFit()
                .onAppear {
                    startAnimation()
                }
                .onDisappear {
                    stopAnimation()
                }
        } else {
            ProgressView() // Placeholder while loading frames
                .onAppear {
                    loadGIF()
                }
        }
    }

    func loadGIF() {
        guard let path = Bundle.main.path(forResource: gifName, ofType: "gif"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let source = CGImageSourceCreateWithData(data as CFData, nil) else { return }

        for index in 0..<CGImageSourceGetCount(source) {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, index, nil) {
                let uiImage = UIImage(cgImage: cgImage)
                frames.append(Image(uiImage: uiImage))
            }
        }
    }

    func startAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: frameDuration, repeats: true) { _ in
            currentFrameIndex = (currentFrameIndex + 1) % frames.count
        }
    }

    func stopAnimation() {
        timer?.invalidate()
        timer = nil
    }
}
