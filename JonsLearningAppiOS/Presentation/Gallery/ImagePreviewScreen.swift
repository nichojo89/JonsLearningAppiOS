//
//  ImagePreview.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 1/4/25.
//
import SwiftUI

struct ImagePreviewScreen : View {
    @ObservedObject private var viewmodel: ImagePreviewViewmodel
    init(image: UIImage) {
        viewmodel = AppContainer.shared.resolve(ImagePreviewViewmodel.self, argument:image)!
    }
    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: 0xFFE0EAFC),
                    Color(hex: 0xFF9CFDEF3)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            VStack{
                Image(uiImage: viewmodel.image)
                    .resizable()
                    .scaledToFit()
                    .onLongPressGesture{
                        downloadImage()
                    }
               
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    func downloadImage(){
        UIImageWriteToSavedPhotosAlbum(viewmodel.image, nil, nil, nil)
    }
}

struct ImagePreviewScreen_Preview : PreviewProvider {
    static var previews : some View {
        ImagePreviewScreen(image: UIImage(named: "jonsLearningAppLogo")!)
    }
}
