protocol TCarte{
	
	//Nom de la carte
	var nom : String {get}

	// Couleur de la carte
	var couleur : Couleur {get}

	// Liste de mouvements possibles (relatifs au pion choisi)
	// Quand un pion se deplace, on prend la position actuel du pion, et on rajoute la position du mouvement pour arriver à la nouvelle position
	var listeMouvements : [Position] {get}
	
	//init : -> Carte
	// Création d'une carte
	init(nom : String, couleur : Couleur, listeMouvements : [Position])

	//mouvement: Carte -> [Position]
	// Liste de mouvements possibles pour une carte
	// Pré: !estFinie
	// Post: Retourne une liste de positions possibles pour une carte
	func mouvement() -> [Position]

	//afficherCarte: Carte -> String
	// Affiche les propriétés d'une carte
	// Pré: estFinie = false
	// Post: retourne un string qui contient le nom et la couleur de la carte (autres params possible)
	func afficherCarte() -> String
}

class Carte : TCarte{
	var nom : String
	var couleur : Couleur
	var listeMouvements : [Position]

	required init(nom : String, couleur : Couleur, listeMouvements : [Position]){
		self.nom = nom
		self.couleur = couleur
		self.listeMouvements = listeMouvements
	}

	func mouvement() -> [Position]{
		return self.listeMouvements
	}

	func afficherCarte() -> String{
		let res : String = self.nom
		return res
	}
}