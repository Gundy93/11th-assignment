//
//  QRScanner.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

import SwiftUI
import Vision
import VisionKit

struct QRScanner: UIViewControllerRepresentable {
    var onScanned: (String) -> Void
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        
        let controller = DataScannerViewController(
            recognizedDataTypes: [.barcode(symbologies: [.qr])],
            qualityLevel: .balanced,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: true,
            isHighlightingEnabled: true
        )
        
        controller.delegate = context.coordinator
        
        try? controller.startScanning()
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onScanned: onScanned)
    }
}

extension QRScanner {
    final class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var onScanned: (String) -> Void
        
        init(onScanned: @escaping (String) -> Void) {
            self.onScanned = onScanned
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController,
                         didAdd addedItems: [RecognizedItem],
                         allItems: [RecognizedItem]) {
            
            guard let item = addedItems.first else { return }
            
            switch item {
            case .barcode(let barcode):
                if let value = barcode.payloadStringValue {
                    onScanned(value)
                }
            default:
                break
            }
        }
    }
}
