import Photos
import UIKit

enum PhotoLibrarySaver {
    static func save(_ image: UIImage, completion: @escaping (String) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            guard status == .authorized || status == .limited else {
                DispatchQueue.main.async { completion("Permita acesso para salvar a foto.") }
                return
            }

            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            } completionHandler: { success, error in
                DispatchQueue.main.async {
                    completion(success ? "Foto salva na biblioteca." : (error?.localizedDescription ?? "Não foi possível salvar a foto."))
                }
            }
        }
    }
}
