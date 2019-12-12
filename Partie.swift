protocol TPartie{

	// joueur1 : Partie -> Joueur
  // Le 1er joueur de la partie
  // Post: Retourne le 1er joueur
	var joueur1 : Joueur {get set}
  
  // joueur2 : Partie -> Joueur
  // Le 2eme joueur de la partie
  // Post: Retourne le 2eme joueur
	var joueur2 : Joueur {get set}
  
  // carteCourant : Partie -> Carte
  // La carte au milleu en jeu
  // Post: Retourne la carte qui n'appartient à aucun joueur en jeu
	var carteCourante : Carte {get set}
  
  // joueurCourant : Partie -> Carte
  // Indique le joueur courant
  // Post: Retourne le joueur qui fait son tour , joueur1 ou joueur2
	var joueurCourant : Joueur {get} 

	// init : Joueur x Joueur-> Partie
	// Création de la partie
	// Pré: rien
	// Post: Initialise la grille, les joueurs,la couleur des joueurs, les listes de cartes (une liste de 2 cartes par joueur et une liste de 1 carte apart)
	init(j1 : Joueur, j2 : Joueur)

	// estFinie : Joueur x Joueur -> Bool
	// Tester si une partie est terminée
	// Si un pion capture le maitre du joueur adverse ou
	// si un pion maitre arrive sur la case arche du jouer adversaire, la partie est finie
	// Pré: la partie est initialisée et !estFinie
	func estFinie(j1 : Joueur, j2 : Joueur) -> Bool

	// premierTour: Partie x Carte -> Joueur
	// set le joueur courant au debut de la partie
	// test la couleur du joueur avec la couleur de la carte courante
	// if partie.carteCourant.couleur == joueur1.couleur puis partie.joueurCourant = joueur1 
	// et return joueur1 else partie.joueurCourant = joueur2 return joueur2
	//func premierTour(p : Partie, c : Carte) -> Joueur

	// changerJoueur: Partie
	// changer le joueur courant
	// si joueur1 est le joueur courant, joueur 2 devient le joueur courant et vice versa
	// Pré: !estFinie
	// Post : le joueurCourant est échangé
	func changerJoueur()

	// gagnant: -> Joueur
	// Si la partie est terminée, renvoie le joueur gagnant
	//Pré: estFinie = True
	//Post: retourne un joueur
	func gagnant() -> Joueur
  
  // getPosition : Int x Int -> Position 
	// retourne la position selon les coordonnées x et y
	// Pré: !estFinie et position existe
	// Post: retourne la position, erreur sinon
	func getPosition(x : Int, y : Int) -> Position

	// estPossible: Carte x Pion x Position -> Bool
	// Tester si un mouvement est possible
	// Si un pion adverse se trouve sur la position, ou si la position sort de la grille, retourne false
	// Utilise la func mouvement de Carte
	// Pré: !estFinie
	// Post: retourne true si la deplacement du pion choisi à la position choisie est possible
	func estPossible(c : Carte, p : Pion, pos : Position) -> Bool

	//mouvementsPossibles: Carte x Pion -> [Position]
	// Utilise la func estPossible
	// retourne toutes les positions possible pour un pion selon la carte choisie
  // Pré: Au moins un mouvement possible (boucle while)
	// si aucun mouvement possible, on sort du boucle while, le cas est pris en compte par la fonction peutJouer
  // Post: Retourne un tableau de positions indiquant les mouvements possible pour la carte et le pion choisi
	func mouvementsPossibles(c : Carte, p : Pion) -> [Position]

	// nbMouvementsPossibles: Carte x Pion -> Int
  // Utilise la fonction mouvementsPossibles pour indiquer le nombre des mouvements possibles pour une carte et un pion 
  // Post: si aucun mouvement possible, retourne 0, sinon retourne le nombre de mouvements possibles
	func nbMouvementsPossibles(c : Carte, p : Pion) -> Int

	// deplacerPion: Pion x Position 
	// deplacer un pion sur la grille de jeu
  // Pré: le déplacement est valide
  // Post: le pion déplace sur la position, si un pion adverse est présent, il est capturé
	func deplacerPion(p : Pion, pos : Position)

	// capturePion: Pion -> Bool
	// capturer un pion sur la grille
	// Pré: pion existe et n'appartient pas au joueur courant
	// Post: le pion est supprimé de la liste pion de l'autre joueur et retourne true si réussi
	func capturePion(p : Pion) -> Bool

	// echangerCarte: [Carte] x Carte x Carte 
	// Echanger une carte avec une autre
	// c1 et c2 les indices
	// l1 la liste des cartes du joueur
	func echangerCarte( l1 : [Carte], c1 : Carte, c2 : Carte)
	
  // peutJouer : Partie x Joueur -> Bool
	// Indique si le joueur peut jouer 
	// Post : retourne false si aucun mouvement possible pour toutes les cartes et pions du joueur, ou si le joueur a déjà passé son tour, true si il n'a pas encore joué et il lui reste des mouvements possibles
	func peutJouer(j : Joueur) -> Bool
  
 // selectPosiion: [Position] x Int -> Postion
	// Le joueur curant selectionne une carte
	// Ind est l'indice de la position choisie dans la liste des mouvements possibles du joueur courant
  // Pré: La position choisie doit être dans la liste de mouvements posibles du joueur
  // Post: Retourne la position choisie
	func selectPosition(mouvements : [Position], indice : Int) -> Position
}

class Partie : TPartie {
	var joueur1 : Joueur
	var joueur2 : Joueur
	var carteCourante : Carte
	var joueurCourant : Joueur
	var estFinie : Bool
	var plateau : [[Position]]

	required init(j1 : Joueur, j2 : Joueur){
		self.joueur1 = j1
		self.joueur2 = j2
		self.estFinie = false
		self.joueurCourant = [j1,j2].randomElement()!
		//On creer les mouvements pour les deplacements
		let arriere : Position = Position(x : 1, y : 0, pion : nil)
		let avant : Position = Position(x : -1, y : 0, pion : nil)
		let gauche : Position = Position(x : 0, y : -1, pion : nil)
		let droite : Position = Position(x : 0, y : 1, pion : nil)
		let diago_avant_droite : Position = Position(x : -1, y : 1, pion : nil)
		let diago_avant_gauche : Position = Position(x : -1, y : -1, pion : nil)
		let diago_arriere_gauche : Position = Position(x : 1, y : -1, pion : nil)
		let diago_arriere_droite : Position = Position(x : 1, y : 1, pion : nil)
		let double_arriere : Position = Position(x : 2, y : 0, pion : nil)
		let double_avant : Position = Position(x : -2, y : 0, pion : nil)
		let double_gauche : Position = Position(x : 0, y : -2, pion : nil)
		let double_droite : Position = Position(x : 0, y : 2, pion : nil)
		let double_diago_avant_droite : Position = Position(x : -1, y : 2, pion : nil)
		let double_diago_avant_gauche : Position = Position(x : -1, y : -2, pion : nil)
		//On creer les cartes
		let hahn : Carte = Carte(nom : "hahn", couleur : Couleur.Rouge, listeMouvements : [droite, diago_avant_droite, gauche, diago_arriere_gauche])
		let krabbe : Carte = Carte(nom : "krabbe", couleur : Couleur.Rouge, listeMouvements : [double_droite,double_gauche,avant])
		let wild : Carte = Carte(nom : "wild-schwein", couleur : Couleur.Rouge, listeMouvements : [avant,droite,gauche])
		let drache : Carte = Carte(nom : "drache", couleur : Couleur.Rouge, listeMouvements : [diago_arriere_gauche,diago_arriere_droite,double_diago_avant_gauche,double_diago_avant_gauche])
		let affe : Carte = Carte(nom : "affe", couleur : Couleur.Rouge, listeMouvements : [diago_avant_gauche,diago_arriere_gauche,diago_avant_droite,diago_arriere_droite])
		//On affecte les cartes aux joueurs
		var all_cards : [Carte] = [hahn,krabbe,wild,drache,affe]
		var cards : [Carte] = all_cards.shuffled()
		self.joueur1.listeCartes = [cards[0],cards[1]]
		self.joueur2.listeCartes = [cards[2],cards[3]]
		self.carteCourante = cards[4]
		//On creer les 25 positions
		self.plateau = [[Position]](repeating : [Position](repeating : Position(x : 0, y : 0, pion : nil), count : 5), count : 5)
		for l in 0...4{
			for c in 0...4{
				self.plateau[l][c] = Position(x : l, y : c, pion : nil)
			}
		}
		//On affecte la bonne position aux pions des 2 joueurs
		for i in 0...4{
			self.joueur1.afficherPions()[i].position = self.plateau[i][0]
			self.joueur2.afficherPions()[i].position = self.plateau[i][4]
			self.plateau[i][0].setPion(pion : self.joueur1.afficherPions()[i])
			self.plateau[i][4].setPion(pion : self.joueur2.afficherPions()[i])
		}
	}

	func estFinie(j1 : Joueur, j2 : Joueur) -> Bool{
		//On verifie que le maitre de chaque joueur
		if ((j2.afficherPions()[2].position === plateau[2][0]) || (j1.afficherPions()[2].position === plateau[2][4])){
			return true
		}// on verifie ensuite que le pion maitre est encore sur le plateau, si celui-ci ne l'est plus on sait qu'il sera placé a la position (x=-1 et y=-1)
		else if(((j2.afficherPions()[2].position.x == -1) && (j2.afficherPions()[2].position.y == -1)) || ((j1.afficherPions()[2].position.x == -1) && (j1.afficherPions()[2].position.y == -1))){
			return true
		}
		else{
			return false
		}
	}

	//func premierTour(p : Partie, c : Carte) // ne sert a rien car quand on créé une partie on doit définir le joueur courant

	func gagnant() -> Joueur{
		if ((self.joueur1.afficherPions()[2].position === plateau[2][4]) || ((self.joueur2.afficherPions()[2].position.x == -1) && (self.joueur2.afficherPions()[2].position.y == -1))){
			return self.joueur1
		}
		else {
			return self.joueur2
		}
	}

	func changerJoueur(){
		if(self.joueurCourant === self.joueur1){
			self.joueurCourant = joueur2
		}
		else{
			self.joueurCourant = joueur1
		}
	}

	func getPosition(x : Int, y : Int) -> Position{
		return self.plateau[x][y]
	}

	func estPossible(c : Carte, p : Pion, pos : Position) -> Bool {
		var new_x : Int = p.position.x + pos.x
		var new_y : Int = p.position.y + pos.y
		if ((new_x >= 0) && (new_x <= 4) && (new_y >= 0) && (new_y <= 4)){
			if (!self.plateau[new_x][new_y].positionOcc()){
				return true
			}
			else{
				return self.plateau[new_x][new_y].getPion()!.joueur.couleur == p.joueur.couleur
			}
		}
		else{
			return false
		}
	}

	func mouvementsPossibles(c : Carte, p : Pion) -> [Position] {
		var res : [Position] = []
		for elt in c.mouvement(){
			if (estPossible(c : c, p : p, pos : elt)){
				res.append(elt)
			}
		}
		return res
	}

	func nbMouvementsPossibles(c : Carte, p : Pion) -> Int {
		return self.mouvementsPossibles(c : c, p : p).count
	}

	func deplacerPion(p : Pion, pos : Position){
		self.plateau[p.position.x][p.position.y].setPion(pion : nil)//on dit que l'emplacement actuel du pion va devenir vide
		p.position = pos//on dit que la position du pion est la nouvelle position
		if (pos.positionOcc()){//Dans le cas ou la position d'arrivee est occupee
			capturePion(p : pos.getPion()!)
		}
		self.plateau[pos.x][pos.y].pion = p//On dit que lenouvel emplacement du pion est occupee
	}

	func capturePion(p : Pion) -> Bool {
		changerJoueur()//on change de joueur courant
		if (self.joueurCourant.supprimerPion(p : p)){
			self.joueurCourant.supprimerPion(p : p)
			changerJoueur()//on change de joueur courant
			return true
		}
		else {
			return false
		}
	}

	func selectPosition(mouvements : [Position], indice : Int) -> Position {
		return mouvements[indice-1]
	}

	func peutJouer(j : Joueur) -> Bool {
		for pion in j.afficherPions(){
			for carte in j.afficherCartes(){
				for deplacement in carte.mouvement(){
					if (estPossible(c : carte, p : pion, pos : deplacement)){
						return true
					}
				}
			}
		}
		return false
	}

	func echangerCarte( l1 : [Carte], c1 : Carte, c2 : Carte){
		var temp : Carte = self.carteCourante
		self.carteCourante = c1
		//On cherche la carte c1 dans le deck du joueur courant et on l'echange avec temp (ancienne carte courante)
		if (self.joueurCourant.listeCartes[0] === c1){
			self.joueurCourant.listeCartes[0] = temp
		}
		else {
			self.joueurCourant.listeCartes[1] = temp
		}
	}
}