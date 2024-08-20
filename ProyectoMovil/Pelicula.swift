//
//  Pelicula.swift
//  ProyectoMovil
//
//  Created by AngelRZ on 4/05/24.
//

import UIKit

struct Pelicula: Codable {
    var codigo:Int
    var nombre:String
    var descripcion:String
    var calidad:String
    var foto:String
}

struct ApiResponse: Codable{
    let Peliculas:[Pelicula]
}
