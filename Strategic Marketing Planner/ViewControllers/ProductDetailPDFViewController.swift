//
//  ProductDetailPDFViewController.swift
//  Strategic Marketing Planner
//
//  Created by Steven Brown on 3/28/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit
import PDFKit

class ProductDetailPDFViewController: UIViewController {
    
    // MARK: - Properties
    var product: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pdfViewer()
        navigationController?.navigationBar.tintColor = .white
    }
    
    func pdfViewer() {
        let pdfView = PDFView()
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        
        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pdfView.displayMode = PDFDisplayMode.singlePage
        
        pdfView.autoScales = true
        
        guard let path = Bundle.main.url(forResource: product, withExtension: "pdf") else { return }
        if let pdfDocument = PDFDocument(url: path) {
            pdfView.document = pdfDocument
        }
    }
}
