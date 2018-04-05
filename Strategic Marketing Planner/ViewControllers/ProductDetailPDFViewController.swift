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
    let pdfView = PDFView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatNavigationBar()
        loadPDF()
        configurePDFView()
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func formatNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
    }
    
    func loadPDF() {
        guard let url = Bundle.main.url(forResource: product, withExtension: "pdf") else { return }
        if let document = PDFDocument(url: url) {
            pdfView.document = document
        }
    }
    
    func configurePDFView() {
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        
        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        switch Devices.currentDevice {
        case .iPadPro9Inch, .otheriPad:
            pdfView.scaleFactor = 0.497
        case .iPadPro10Inch:
            pdfView.scaleFactor = 0.539
        case .iPadPro12Inch:
            pdfView.scaleFactor = 0.664
        default:
             break
        }
    }
}
