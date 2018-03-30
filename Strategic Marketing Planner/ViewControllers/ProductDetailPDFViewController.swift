//
//  ProductDetailPDFViewController.swift
//  Strategic Marketing Planner
//
//  Created by Steven Brown on 3/28/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit
import PDFKit
import WebKit

class ProductDetailPDFViewController: UIViewController {
    
    // MARK: - Properties
    var product: String?
    @IBOutlet weak var pdfWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pdfViewer()
        navigationController?.navigationBar.tintColor = .white
    }
    
    func pdfViewer() {
        if let path = Bundle.main.url(forResource: product, withExtension: "pdf") {
        let pdfDocument = NSURLRequest(url: path)
            pdfWebView.load(pdfDocument as URLRequest)
        }
    }
}
