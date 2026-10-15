import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import SwiftUI
import UIKit

enum EditStyle: String, CaseIterable, Identifiable {
    case original, mono, vivid, dramatic

    var id: String { rawValue }

    var title: String {
        switch self {
        case .original: "Original"
        case .mono: "Mono"
        case .vivid: "Vívido"
        case .dramatic: "Drama"
        }
    }
}

@MainActor
final class EditorViewModel: ObservableObject {
    @Published var originalImage: UIImage?
    @Published var renderedImage: UIImage?
    @Published var style: EditStyle = .original { didSet { render() } }
    @Published var intensity: Double = 0.7 { didSet { render() } }

    private let context = CIContext()

    func load(_ item: PhotosPickerItem?) async {
        guard let data = try? await item?.loadTransferable(type: Data.self),
              let image = UIImage(data: data) else { return }
        originalImage = image
        render()
    }

    func render() {
        guard let originalImage, let input = CIImage(image: originalImage) else { return }
        let output: CIImage

        switch style {
        case .original:
            output = input
        case .mono:
            let filter = CIFilter.photoEffectMono()
            filter.inputImage = input
            output = blend(filter.outputImage, with: input)
        case .vivid:
            let filter = CIFilter.vibrance()
            filter.inputImage = input
            filter.amount = Float(intensity * 1.4)
            output = filter.outputImage ?? input
        case .dramatic:
            let filter = CIFilter.photoEffectProcess()
            filter.inputImage = input
            output = blend(filter.outputImage, with: input)
        }

        guard let cgImage = context.createCGImage(output, from: input.extent) else { return }
        renderedImage = UIImage(cgImage: cgImage, scale: originalImage.scale, orientation: originalImage.imageOrientation)
    }

    private func blend(_ filtered: CIImage?, with original: CIImage) -> CIImage {
        guard let filtered else { return original }
        let blend = CIFilter.blendWithMask()
        blend.inputImage = filtered
        blend.backgroundImage = original
        let value = CGFloat(intensity)
        blend.maskImage = CIImage(color: CIColor(red: value, green: value, blue: value, alpha: 1))
            .cropped(to: original.extent)
        return blend.outputImage ?? original
    }
}
