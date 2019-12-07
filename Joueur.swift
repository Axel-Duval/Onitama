protocol TJoueur{
	
	// Liste de cartes du joueur
	var listeCartes : [Carte]{get}

	// Liste de pions du joueur
	var listePions : [Pion] {get set}

	// Nom du joueur
	var nom : String {get}

	// Couleur du joueur
	var couleur : Couleur {get}

	//init : -> Joueur
	//Création d'un nouveau joueur
	init(nom : String, couleur : Couleur)

	// selectCarte: Int -> Carte
	// Le joueur curant selectionne une carte
	// Ind est l'indice de la carte choisie dans la liste des cartes du joueur courant
	// Pré: La carte choisie doit être dans la liste de cartes du joueur
	// Post: Retourne la carte choisie
	func selectCarte(indice : Int) -> Carte

	// afficherCartes: Joueur -> [Carte]
	// retourne les cartes du joueur
	// Pré: estFinie = false
	// Post: retourne la liste de cartes
	func afficherCartes() -> [Carte]

	// afficherPions: Joueur -> [Pion]
	// retourne les pions en vie pour un joueur
	// Pré: estFinie = false
	// Post: resultat = joueur.listePions
	func afficherPions() -> [Pion]

	// nombrePions: Joueur -> Int
	// retourne les pions en vie pour un joueur
	// Pré: estFinie = false
	// Post: retourne le nombre de pions restant du joueur
	func nombrePions() -> Int

	//choisirPion: Int -> Pion 
	// Permettre au joueur courant de choisir un Pion à jouer
	// Pré: liste de pions du joueur n'est pas vide, et l'indice ne dépasse pas le nombre de pions restant
	// Post: retourne un pion
	func choisirPion(indice : Int) -> Pion

	// supprimerPion: Joueur x Pion -> Bool
	// supprime un pion au cas de sa capture
	// Pré: estFinie = False, le Pion existe
	// Post: retourne un boolean indiquant si la suppression a marché
	func supprimerPion(p : Pion) -> Bool
}

Class Joueur : TJoueur {
	var listeCartes : [Carte]
	var listePions : [Pion]
	var nom : String
	var couleur : Couleur

	init(nom : String, couleur : Couleur){
		self.nom = nom
		self.couleur = couleur
	}

	func selectCarte(indice : Int) -> Carte{
		return self.afficherCartes()[indice-1]
	}

	func afficherCartes() -> [Carte]{
		return self.listeCartes
	}

	func afficherPions() -> [Pion]{
		return self.listePions
	}

	func nombrePions() -> Int{
		return self.afficherPions().count
	}

	func choisirPion(indice : Int) -> Pion{
		return self.afficherPions()[indice-1]
	}

	func supprimerPion(p : Pion) -> Bool{
		var res = [Pion]()
		for i in 0..<self.nombrePions(){
			if(self.afficherPions()[i] !== p){
				res.append(self.afficherPions()[i])
			}
		}
		var temp = self.afficherPions()
		self.pions = res
		return (temp == self.afficherPions())
	}
}