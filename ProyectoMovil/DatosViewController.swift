//
//  DatosViewController.swift
//  ProyectoMovil
//
//  Created by AngelRZ on 7/05/24.
//

import UIKit
import Alamofire

class DatosViewController: UIViewController {
    
    @IBOutlet weak var txtCodigo: UITextField!
    
    
    @IBOutlet weak var txtNombre: UITextField!
    
    
    @IBOutlet weak var txtDescripcion: UITextField!
    
    
    @IBOutlet weak var txtCalidad: UITextField!
    
    
    @IBOutlet weak var fotoPelicula: UIImageView!
    
    var bean:Pelicula!
    var viewController:ViewController?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtCodigo.text=String(bean.codigo)
        txtNombre.text=bean.nombre
        txtDescripcion.text=bean.descripcion
        txtCalidad.text=bean.calidad
        fotoPelicula.image = UIImage(named: bean.foto)
        
    }
    
    @IBAction func btnActualizar(_ sender: UIButton) {
        let cod=Int(txtCodigo.text ?? "0") ?? 0
        let nom=txtNombre.text ?? ""
        let des=txtDescripcion.text ?? ""
        let cal=txtCalidad.text ?? ""
        let foto = bean.foto
        
        let peli=Pelicula(codigo: cod, nombre: nom, descripcion: des, calidad: cal, foto: foto);actualizarPelicula(bean:peli)
        
        
        self.dismiss(animated: true) {
            self.viewController?.actualizarTabla()
        }
        
    }
    
    func actualizarPelicula(bean:Pelicula){
        AF.request("http://localhost:3000/Peliculas/actualizar",
                    method: .put,parameters: bean,
                    encoder: JSONParameterEncoder.default
         ).response( completionHandler: { info in
                 switch info.result{
                    case .success(let data):
                     do{
                         let row=try JSONDecoder().decode(Pelicula.self, from: data!)
                         print("codigo : "+String(row.codigo))
                     }catch{
                       print("Error en el JSON")
                     }
                    case .failure(let error):
                     print(error.localizedDescription)
                 }
             })
    }
    
    
    @IBAction func btnVolver(_ sender: UIButton) {
        dismiss(animated: true)
    }
    

    
}
