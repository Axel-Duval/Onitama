protocol TPosition{
	// Coordonnées sur la grille OU mouvements de cartes donc peut etre negatif
	// x : Position -> Int
	// Post: Retourne la ligne de la position sur la grille
	var x : Int {get}

	// y: Position -> Int
	// Post: Retourne la colonne de la position sur la grille
	var y : Int {get}

	// getPion: Position -> Pion
	// Indique si un pion est sur une position
	// retourne le pion sur la position, sinon retourne erreur
	var pion : Pion? {get set}
	
	//init: -> Position
	// Création d'une position, x:vertical,y:horizontal
	// Pré: le couple (x,y) n'existe pas encore
	// Post: retourne la position crée
	init(x : Int, y : Int, pion : Pion?)
	
	// positionOcc: Position -> Bool
	// Tester si une position est occupée sur la grille
	// Pré: !estFinie
	// Post: retourne true si un pion se trouve à la position
	func positionOcc() -> Bool

	// getPion: Position -> Pion
	// Indique si un pion est sur une position
	// retourne le pion sur la position, sinon retourne erreur
	func getPion() -> Pion?

	func setPion(pion : Pion?)
}

class Position : TPosition{
	var x : Int
	var y : Int
	var pion : Pion?

	required init(x : Int, y : Int, pion : Pion?){
		self.x = x
		self.y = y
		self.pion = pion
	}

	func positionOcc() -> Bool{
		return (self.pion === nil) 
	}

	func getPion() -> Pion?{
		return self.pion
	}

	func setPion(pion : Pion?){
		self.pion = pion
	}
}