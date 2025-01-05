//
//  ImageToolBar.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 1/5/25.
//
import SwiftUI

struct ImageToolBar : View {
    @State var image: UIImage
    var body: some View {
        HStack {
            Spacer()
            Button{
                //TODO Add to "Collection"
            } label: {
                HStack {
                    Image(systemName: "heart.fill")
                        .tint(.red)
                }
                .padding(8)
                .background(.black.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .shadow(color: .black.opacity(0.2), radius:2, x: 4, y: 4)
            }
            Button{
                downloadImage()
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.down")
                        .tint(.white)
                }
                .padding(8)
                .background(.black.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .shadow(color: .black.opacity(0.2), radius:2, x: 4, y: 4)
                .padding(.horizontal,12)
            }
            Button{
                shareImage()
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .tint(.white)
                }
                .padding(8)
                .background(.black.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: .black.opacity(0.2), radius:2, x: 4, y: 4)
                    
            }
        }
    }
    
    func downloadImage(){
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    func shareImage() {
        let activityVC = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            
            activityVC.popoverPresentationController?.sourceView = rootVC.view
            rootVC.present(activityVC, animated: true)
        }
    }
}


//struct ImageToolBar_Preview : PreviewProvider {
//    static var previews: some View {
//        ImageToolBar()
//    }
//}
