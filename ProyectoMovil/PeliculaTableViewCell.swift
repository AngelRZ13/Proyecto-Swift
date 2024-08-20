//
//  PeliculaTableViewCell.swift
//  ProyectoMovil
//
//  Created by AngelRZ on 4/05/24.
//

import UIKit

class PeliculaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblNombre: UILabel!
    
    @IBOutlet weak var lblCalidad: UILabel!
    

    @IBOutlet weak var imgPelicula: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
