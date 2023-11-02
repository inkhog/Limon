//
//  LMGamesController+UIDocumentPickerDelegate.swift
//  Limon
//
//  Created by Jarrod Norwell on 10/9/23.
//

import Foundation
import UIKit

extension LMGamesController : UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            return
        }
        
        let importingController = LMImportingController(url)
        importingController.modalPresentationStyle = .fullScreen
        present(importingController, animated: true)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
}
