protocol TPosition{
	// Coordonnées sur la grille
	// x : Position -> Int
	// Post: Retourne la ligne de la position sur la grille
	var x : Int {get}

	// y: Position -> Int
	// Post: Retourne la colonne de la position sur la grille
	var y : Int {get}
	
	//init: -> Position
	// Création d'une position, x:vertical,y:horizontal
	// Pré: le couple (x,y) n'existe pas encore
	// Post: retourne la position crée
	init(x : Int, y : Int)
	
	// positionOcc: Position -> Bool
	// Tester si une position est occupée sur la grille
	// Pré: !estFinie
	// Post: retourne true si un pion se trouve à la position
	func positionOcc() -> Bool

	// getPion: Position -> Pion
	// Indique si un pion est sur une position
	// retourne le pion sur la position, sinon retourne erreur
	func getPion() -> Pion
}

Class Position : TPosition{
	var x : Int
	var y : Int

	init(x : Int, y : Int){
		self.x = x
		self.y = y
	}

	func positionOcc() -> Bool{
		//On ne peut pas la faire non plus car il faut la partie pour savoir ou sont les pions...
	}

	func getPion() -> Pion{
		//On ne peut pas la faire non plus car il faut la partie pour savoir ou sont les pions...
	}
}