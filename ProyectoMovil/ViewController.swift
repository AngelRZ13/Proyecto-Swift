//
//  ViewController.swift
//  ProyectoMovil
//
//  Created by AngelRZ on 25/04/24.
//

import UIKit
import Alamofire

class ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tvPelicula: UITableView!
    
    var lista:[Pelicula] = []
    var objPelicula:Pelicula!
    
    @IBOutlet weak var txtBuscador: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvPelicula.rowHeight=110
        tvPelicula.dataSource=self
        tvPelicula.delegate=self
        // Do any additional setup after loading the view.
        Cargar()
    }
    func Cargar(){
        /*AF.request("http://localhost:3000/peliculas/lista").response{
            data in
            debugPrint(data)
        }*/
        AF.request("http://localhost:3000/peliculas/lista").responseDecodable(of: ApiResponse.self){
            response in
            switch response.result{
            case .success(let apiResponse):
                self.lista=apiResponse.Peliculas
                self.tvPelicula.dataSource=self
                self.tvPelicula.reloadData()
            case .failure(let error):
                print("Error al cargar los datos: \(error)")
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lista.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row=tvPelicula.dequeueReusableCell(withIdentifier: "detalle") as!
        PeliculaTableViewCell
        
        row.lblNombre.text = "Nombres: "+String(lista[indexPath.row].nombre)
        row.lblCalidad.text = "Calidad: "+lista[indexPath.row].calidad
        
        row.imgPelicula.image = UIImage(named: lista[indexPath.row].foto)
        return row
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        objPelicula=lista[indexPath.row]
        performSegue(withIdentifier: "datos", sender: nil)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
                let cod = lista[indexPath.row].codigo
                let url = "http://localhost:3000/Peliculas/eliminar/\(cod)"
                
                // Crear una alerta de confirmación
                let alertController = UIAlertController(title: "Confirmar Eliminación", message: "¿Estás seguro de que deseas eliminar este elemento?", preferredStyle: .alert)
                
                // Agregar acciones a la alerta
                let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
                alertController.addAction(cancelAction)
                
                let deleteAction = UIAlertAction(title: "Eliminar", style: .destructive) { _ in
                    // Procesar la eliminación si el usuario confirma
                    AF.request(url, method: .delete).response { [weak self] response in
                        switch response.result {
                        case .success:
                            print("Elemento eliminado correctamente")
                            // Eliminar el elemento de la lista local
                            self?.lista.remove(at: indexPath.row)
                            // Eliminar la fila de la tabla
                            tableView.deleteRows(at: [indexPath], with: .automatic)
                        case .failure(let error):
                            print("Error al eliminar el elemento:", error.localizedDescription)
                        }
                    }
                }
                alertController.addAction(deleteAction)
                
                // Mostrar la alerta
                present(alertController, animated: true)
            }
        }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "datos" {
            if let datosViewController = segue.destination as? DatosViewController {
                datosViewController.bean = objPelicula
                datosViewController.viewController = self
            }
        } else if segue.identifier == "nuevo" {
            if let nuevoViewController = segue.destination as? NuevoViewController {
                nuevoViewController.viewController = self
            }
        }
    }
    
    
    @IBAction func btnNuevo(_ sender: UIButton) {
        performSegue(withIdentifier: "nuevo", sender: nil)
    }
    
    @IBAction func btnBuscar(_ sender: UIButton) {
        guard let nombreABuscar = txtBuscador.text else {
                return
            }
            
            // Verificar si el nombre a buscar está vacío o no
            if nombreABuscar.isEmpty {
                // Si está vacío, cargar todas las películas
                cargarTodasLasPeliculas()
            } else {
                // Si no está vacío, buscar por nombre
                buscarPorNombre(nombre: nombreABuscar)
            }
    }
    
    func cargarTodasLasPeliculas() {
        let url = "http://localhost:3000/peliculas/lista"
        
        AF.request(url).responseDecodable(of: ApiResponse.self) { response in
            switch response.result {
            case .success(let apiResponse):
                self.lista = apiResponse.Peliculas
                self.tvPelicula.reloadData()
            case .failure(let error):
                print("Error al cargar todas las películas: \(error.localizedDescription)")
            }
        }
    }
    
    func buscarPorNombre(nombre: String){
        let url:String
        
        if nombre.isEmpty {
                url = "http://localhost:3000/peliculas/lista"
            } else {
                url = "http://localhost:3000/buscarPorNombre/\(nombre)"
            }
        
        AF.request(url).responseDecodable(of: ApiResponse.self) { response in
            switch response.result {
            case .success(let apiResponse):
                        self.lista = apiResponse.Peliculas
                        self.tvPelicula.reloadData()
                    case .failure(let error):
                        print("Error al buscar la película: \(error.localizedDescription)")
            }
            
        }
        
    }
    func actualizarTabla() {
            // Actualiza la lista de datos
            // Recarga la tabla para reflejar los cambios
         AF.request("http://localhost:3000/peliculas/lista").responseDecodable(of: ApiResponse.self){
            response in
            switch response.result{
            case .success(let apiResponse):
                self.lista=apiResponse.Peliculas
                self.tvPelicula.dataSource=self
                self.tvPelicula.reloadData()
            case .failure(let error):
                print("Error al cargar los datos: \(error)")
            }
            
        }
        
            tvPelicula.reloadData()
        }
    
    
    }
