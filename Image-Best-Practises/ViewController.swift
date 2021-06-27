//
//  ViewController.swift
//  Image-Best-Practises
//
//  Created by Kumar on 27/06/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imageView1 = UIImageView(frame: CGRect(x: 80, y:300, width: 100, height: 100))
    let imageView2 = UIImageView(frame: CGRect(x: 200, y:300, width: 100, height: 100))
    let imageView3 = UIImageView(frame: CGRect(x: 80, y:400, width: 100, height: 100))
    let imageView4 = UIImageView(frame: CGRect(x: 200, y:400, width: 100, height: 100))
    let imageView5 = UIImageView(frame: CGRect(x: 80, y:500, width: 100, height: 100))
    
    var downSample: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubviews(imageView1, imageView2, imageView3, imageView4, imageView5)
    }
    
    @IBAction func toggleDownSampling(_ sender: Any) {
        self.downSample = !self.downSample
    }
    
    @IBAction func loadPhotos(_ sender: Any) {
        openGallery()
    }
    
    private func openGallery() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image", "public.movie"]
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        var downSampleImage: UIImage!
        if self.downSample {
            downSampleImage = downSample(data: image.pngData()!, pointSize: CGSize(width: 75, height: 75), scale: 2)
        } else {
            downSampleImage = image
        }

        if self.imageView1.image == nil {
            self.imageView1.image = downSampleImage
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.openGallery()
            }
        } else if self.imageView2.image == nil {
            self.imageView2.image = downSampleImage
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.openGallery()
            }
        } else if self.imageView3.image == nil {
            self.imageView3.image = downSampleImage
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.openGallery()
            }
        } else if self.imageView4.image == nil {
            self.imageView4.image = downSampleImage
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.openGallery()
            }
        } else if self.imageView5.image == nil {
            self.imageView5.image = downSampleImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func downSample(data: Data, pointSize: CGSize, scale: CGFloat = 2.0) -> UIImage {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions)!
        
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        let downsampleOptions =
        [kCGImageSourceCreateThumbnailFromImageAlways: true,
        kCGImageSourceShouldCacheImmediately: true,
        kCGImageSourceCreateThumbnailWithTransform: true,
        kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary

        let downsampledImage =
        CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)!
        return UIImage(cgImage: downsampledImage)
    }
}

extension UIView {
    func addSubviews(_ view: UIView...) {
        for v in view {
            addSubview(v)
        }
    }
}

