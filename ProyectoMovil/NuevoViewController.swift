//
//  NuevoViewController.swift
//  ProyectoMovil
//
//  Created by AngelRZ on 25/04/24.
//

import UIKit
import DropDown
import Alamofire
class NuevoViewController: UIViewController {
    
    @IBOutlet weak var txtNombre: UITextField!
    
    @IBOutlet weak var txtDescripcion: UITextField!
    
    
    @IBOutlet weak var txtFoto: UITextField!
    var viewController:ViewController?
    
    
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCalidad(_ sender: UIButton) {
        dropDown.anchorView = sender
        dropDown.dataSource = ["IMAX","3D","2D"]
        dropDown.show()
        
        dropDown.bottomOffset = CGPoint(x:0 ,y: (dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.selectionAction = { [unowned self] (index:Int, item:String) in
            sender.setTitle(item, for: .normal)
            
        }
    }
    
    @IBAction func btnCrear(_ sender: UIButton) {
        guard let nom = txtNombre.text, !nom.isEmpty else {
                mostrarError(mensaje: "Por favor, ingresa un nombre válido.")
                return
            }

            guard let des = txtDescripcion.text, !des.isEmpty else {
                mostrarError(mensaje: "Por favor, ingresa una descripción válida.")
                return
            }

            guard let cal = dropDown.selectedItem, !cal.isEmpty else {
                mostrarError(mensaje: "Por favor, selecciona una calidad.")
                return
            }

            guard let fot = txtFoto.text, !fot.isEmpty else {
                mostrarError(mensaje: "Por favor, ingresa una URL de foto válida.")
                return
            }
        
        
        let peli = Pelicula(codigo: 0, nombre: nom, descripcion: des, calidad: cal, foto: fot);grabarMPelicula(bean: peli)
        
        viewController?.actualizarTabla()
        dismiss(animated: true)
        
    }
    func grabarMPelicula(bean:Pelicula){
        AF.request("http://localhost:3000/peliculas",
                   method: .post,parameters:bean,
                   encoder: JSONParameterEncoder.default
        ).response(completionHandler: { info in
            switch info.result{
            case .success(let data):
                do{
                    let row=try JSONDecoder().decode(Pelicula.self, from: data!)
                    print("codigo: "+String(row.codigo))
                }catch{
                    print("Error en el JSON")
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    
    
    
    @IBAction func btnVolver(_ sender: UIButton) {
        dismiss(animated: true)
    }
    func mostrarError(mensaje: String) {
        let alert = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
