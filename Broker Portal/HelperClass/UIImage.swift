//
//  UIImage.swift
//  Broker Portal
//
//  Created by Pankaj on 05/05/25.
//

import UIKit

struct UserImageGenerator {

    static func generateProfileImage(
        imageURLString: String?,
        firstName: String?,
        lastName: String?,
        size: CGSize = CGSize(width: 40, height: 40), // Adjusted for navigation bar use
        backgroundColor: UIColor = .lightGray,
        textColor: UIColor = .AppWhiteColor,
        font: UIFont = InterFontStyle.bold.with(size: 20) // Adjusted font size
    ) async -> UIImage? {
        
        // Attempt to download the image
        if let urlString = imageURLString,
           let url = URL(string: urlString) {
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let downloadedImage = UIImage(data: data) {
                    return downloadedImage.circularImage(size: size)
                } else {
                    debugPrint("Failed to convert downloaded data to UIImage")
                }
            } catch {
                debugPrint("Error downloading image: \(error)")
            }
        } else {
            debugPrint("Invalid URL: \(String(describing: imageURLString))")
        }
        
        // If image not available, generate initials image
        let initials = "\(firstName?.first?.uppercased() ?? "")\(lastName?.first?.uppercased() ?? "")"
        
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            // Background
            backgroundColor.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            // Initials text
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: textColor,
                .paragraphStyle: paragraphStyle
            ]
            
            let textSize = initials.size(withAttributes: attributes)
            let rect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            
            initials.draw(in: rect, withAttributes: attributes)
        }.circularImage(size: size)
    }
}

extension UIImage {
    func circularImage(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: size))
            path.addClip()
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
