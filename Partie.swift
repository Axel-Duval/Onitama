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

	var grille : [[Carte?]] {get set}
	
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
	func premierTour(p : Partie, c : Carte) -> Joueur

	// changerJoueur: Partie
	// changer le joueur courant
	// si joueur1 est le joueur courant, joueur 2 devient le joueur courant et vice versa
	// Pré: !estFinie
	// Post : le joueurCourant est échangé
	func changerJoueur(p : Partie)

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
	// Ind est l'indice de la posion choisie dans la liste des mouvements possibles du joueur courant
  // Pré: La position choisie doit être dans la liste de mouvements posibles du joueur
  // Post: Retourne la position choisie
	func selectPosition(mouvements : [Position],Ind:Int) -> Position
}

Class Partie : TPartie{

	var joueur1 : Joueur
	var joueur2 : Joueur
	var carteCourante : Carte
	var joueurCourant : Joueur
	var estFinie : Bool
	//on créé un deck
	var deck : [Carte](2) {get set}
	//on créé les pions du joueur 1
	var p1 : Pion
	var p2 : Pion
	var p3 : Pion
	var p4 : Pion
	var p5 : Pion 
	//on créé les pions du joueur 2
	var p6 : Pion 
	var p7 : Pion 
	var p8 : Pion 
	var p9 : Pion 
	var p10 : Pion


	init(j1 : Joueur, j2 : Joueur){

		estFinie = false
		//on initialise les pions du joueur 1
		p1 = Pion(j : Joueur1, maitre : false, pos : je peux rien mettre maybe on redéfini position etant juste un type (x : int, y : int) ducoup ici (x : 0, y : 0))
		p2 = Pion(j : Joueur1, maitre : false, pos : (x : 0 , y : 1))
		p3 = Pion(j : Joueur1, maitre : true, pos : (x : 0 , y : 2))
		p4 = Pion(j : Joueur1, maitre : false, pos : (x : 0 , y : 3))
		p5 = Pion(j : Joueur1, maitre : false, pos : (x : 0 , y : 4))
		//on initialise les pions du joueur 2
		p6 = Pion(j : Joueur2, maitre : false, pos : (x : 4 , y : 0))
		p7 = Pion(j : Joueur2, maitre : false, pos : (x : 4 , y : 1))
		p8 = Pion(j : Joueur2, maitre : true, pos : (x : 4 , y : 2))
		p9 = Pion(j : Joueur2, maitre : false, pos : (x : 4 , y : 3))
		vp10 = Pion(j : Joueur2, maitre : false, pos : (x : 4 , y :4))

		j1.couleur = Rouge
		j2.couleur = Bleu
		//on initialise les decks
		j1.deck[0] = "carte1"
		j1.deck[1] = "carte2"
		j2.deck[0] = "carte3"
		j2.deck[1] = "carte4"

		let nb = Int.random(in: 1 .. 2)

		if nb == 1{
			joueurCourant = j1
		}else{
			joueurCourant = j2
		}
		
		carteCourante = "carte5"

	}
	func estFinie(j1 : Joueur, j2 : Joueur) -> Bool{
		
		if ((p3.pos == (x : 4, y : 2)) || (p8.pos == (x : 0, y : 2))){
			self.estFinie = true
		}//definir une seconde position lorsque les pions ne sont plus sur le plateau (pour verifier si le pion maitre d'un joueur est toujours en vie)
		return self.estFinie
	}

	func premierTour(p : Partie, c : Carte) // ne sert a rien car quand on créé une partie on doit définir le joueur courant

	func gagnant(){

		if ((p3.pos == (x : 4, y : 2)) || (p3.pos == ?)) { // pareil ou est le maitre si il est mangé
			return self.joueur1
		}else if ((p8.pos == (x : 0, y : 2)) || (p8.pos == ?)){
			return self.joueur2
		}

	}

}