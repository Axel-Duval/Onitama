protocol TPion{
	// position : Pion -> Position
	// Indique la position du pion
	// Post: Retourne la position du pion
	var position : Position {get set}

	var joueur : Joueur {get}

	private var estMaitre : Bool {get}

	// estMaitre: Pion -> Bool
	// Indique si le pion est maitre
	// Post: Retourne true si le pion est un pion maitre, false sinon
	func estMaitre() -> Bool
	
	//init: -> Pion
	// Création d'un pion pour un joueur
	// Pré: le joueur existe et !estFinie
	// Pré:	le joueur ne possede pas plus de 5 pions déjà
	// Post: ajout du pion dans la liste de pions du joueur
	init(j : Joueur, maitre : Bool, position : Position)
}

class Pion : TPion {

	var maitre : Bool
	var joueur : Joueur
	var position : Position

	required init(j : Joueur, maitre : Bool, position : Position){
		self.joueur = j
		self.maitre = maitre
		self.position = position
	}

	func estMaitre() -> Bool{
		return self.estMaitre
	}
}