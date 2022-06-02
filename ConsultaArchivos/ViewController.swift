//
//  ViewController.swift
//  ConsultaArchivos
//
//  Created by Oscar Hernandez on 28/05/22.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var webview: WKWebView!
    
    var indicator = UIActivityIndicatorView()
    
    var options: String?
    var fileName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = options
        setFileName(options!)

        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        
        if existeLocalmente() {
            print("Existe")
            self.mostrarArchivo()
        }
        else {
            
            // 1. comprueba conexión a internet
            if InternetStatus.instance.internetType != .none {
                descargaArchivo()
            } else {
                DispatchQueue.main.async {
                let alert = UIAlertController(title: "No internet connectiom", message: "Internet connection is needed", preferredStyle: .alert)
                let boton = UIAlertAction(title: "OK",style: .default)
                alert.addAction(boton)
                self.present(alert,animated: true)
                self.indicator.stopAnimating()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(InternetStatus.instance.internetType)
    }
    
    func setFileName(_ option: String) {
        switch options {
            case "Excel" : fileName = "localidades.xlsx"
            case "PDF"  : fileName = "Articles.pdf"
            case "Image"    : fileName = "geo_vertical.jpg"
            default: print("No file")
        }
    }
    
    func existeLocalmente() -> Bool {
        
        var exists: Bool = false
        //setting home directory
        let homeDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        if let rutaArchivo = URL(string: homeDirURL.path + "/" + fileName){
            if FileManager.default.fileExists(atPath: rutaArchivo.path) {
                exists = true
            } else {
                exists = false
            }
        }
        self.indicator.startAnimating()
        return exists
    }
    
    func descargaArchivo(){
        let baseURL = "http://janzelaznog.com/DDAM/iOS/vim/"
        if let url = URL(string: baseURL + fileName ) {
            var request = URLRequest(url: url )
            request.httpMethod = "GET"
            let sesion = URLSession.shared
            let task = sesion.dataTask(with: request) { data, response, error in
                if error != nil {
                    print ("Error: \(error!.localizedDescription)")
                }
                else {
                    //guardamos archivo
                    print("Saving file... " + self.fileName)
                    self.guardaArchivo(data!, self.fileName)
                    DispatchQueue.main.async {
                        self.mostrarArchivo()
                        self.indicator.stopAnimating()
                    }
                }
            }
            indicator.startAnimating()
            task.resume()
        }
        else {
            print("URL error")
        }
    }
    
    func guardaArchivo(_ bytes:Data, _ nombre:String) {
        // 1. Obtenemos la ubicacion de la carpeta de documents
        let urlAdocs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let urlAlArchivo = urlAdocs.appendingPathComponent(nombre)
        do {
            try bytes.write(to: urlAlArchivo)
        }
        catch {
            print ("File couldn't be saved \(error.localizedDescription)")
        }
    }
    
    // mostrar archivo
    func mostrarArchivo() {
        //setting home directory
        let homeDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        if let rutaArchivo = URL(string: homeDirURL.path + "/" + fileName){
            if FileManager.default.fileExists(atPath: rutaArchivo.path) {
                let request = URLRequest(url: URL(fileURLWithPath: rutaArchivo.path))
                        DispatchQueue.main.async {
                            self.webview.load(request)
                            self.indicator.stopAnimating()
                        }

            } else {
                print(fileName + " file doesn't exists")
            }
        }
        self.indicator.startAnimating()
    }


}

