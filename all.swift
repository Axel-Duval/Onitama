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
	// Post: retourne un string qui contient le nom (et la couleur) de la carte (autres params possible)
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

class Joueur : TJoueur {
	var listeCartes : [Carte]
	var listePions : [Pion]
	var nom : String
	var couleur : Couleur 


	required init(nom : String, couleur : Couleur){
		self.nom = nom
		self.couleur = couleur
		//Obligation de definir des listes vides pour pouvoir ensuite initialiser les pions qui ont eux-meme besoin d'un joueur en parametre...
		self.listePions = []
		self.listeCartes = []
		//init de pions avec position absurde (pions pas sur le plateau) mais c'est juste pour l'init
		let pos : Position = Position(x : -10, y : -10, pion : nil)
		let p1 : Pion = Pion(j : self, maitre : false, position : pos)
		p1.position.pion = p1
		let p2 : Pion = Pion(j : self, maitre : false, position : pos)
		p2.position.pion = p2
		let p3 : Pion = Pion(j : self, maitre : true, position : pos)
		p3.position.pion = p3
		let p4 : Pion = Pion(j : self, maitre : false, position : pos)
		p4.position.pion = p4
		let p5 : Pion = Pion(j : self, maitre : false, position : pos)
		p5.position.pion = p5
		self.listePions = [p1, p2, p3, p4, p5]
		//init de fausse cartes pour pouvoir ensuite leur donner une vrai valeur...
		let c1 : Carte = Carte(nom : "pour init", couleur : couleur, listeMouvements : [pos])
		let c2 : Carte = Carte(nom : "pour init", couleur : couleur, listeMouvements : [pos])
		self.listeCartes = [c1,c2]
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
		let temp = self.nombrePions()
		for i in 0..<(self.nombrePions()){
			if(self.afficherPions()[i] !== p){
				res.append(self.afficherPions()[i])
			}
		}
		self.listePions = res
		return (temp == self.nombrePions()+1)
	}
}

enum Couleur{
// La couleur d'un joueur est soit rouge soit bleu
	case Rouge
	case Bleu
}

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
	private var estFinie : Bool
	var plateau : [[Position]]

	required init(j1 : Joueur, j2 : Joueur){
		self.joueur1 = j1
		self.joueur2 = j2
		self.estFinie = false
		//On creer les mouvements pour les deplacements
		let arriere : Position = Position(x : 1, y : 0, pion : nil)
		let avant : Position = Position(x : -1, y : 0, pion : nil)
		let gauche : Position = Position(x : 0, y : 1, pion : nil)
		let droite : Position = Position(x : 0, y : -1, pion : nil)
		let diago_avant_droite : Position = Position(x : -1, y : -1, pion : nil)
		let diago_avant_gauche : Position = Position(x : -1, y : 1, pion : nil)
		let diago_arriere_gauche : Position = Position(x : 1, y : 1, pion : nil)
		let diago_arriere_droite : Position = Position(x : 1, y : -1, pion : nil)
		let double_arriere : Position = Position(x : 2, y : 0, pion : nil)
		let double_avant : Position = Position(x : -2, y : 0, pion : nil)
		let double_gauche : Position = Position(x : 0, y : 2, pion : nil)
		let double_droite : Position = Position(x : 0, y : -2, pion : nil)
		let double_diago_avant_droite : Position = Position(x : -1, y : -2, pion : nil)
		let double_diago_avant_gauche : Position = Position(x : -1, y : 2, pion : nil)
		//On creer les cartes avec les mouvements (referentiel : joueur2)
		let coq : Carte = Carte(nom : "coq", couleur : Couleur.Rouge, listeMouvements : [droite, diago_avant_droite, gauche, diago_arriere_gauche])
		let porc : Carte = Carte(nom : "porc", couleur : Couleur.Rouge, listeMouvements : [gauche,arriere,avant])
		let crabe : Carte = Carte(nom : "crabe", couleur : Couleur.Rouge, listeMouvements : [double_droite,double_gauche,avant])
		let dragon : Carte = Carte(nom : "dragon", couleur : Couleur.Rouge, listeMouvements : [diago_arriere_gauche,diago_arriere_droite,double_diago_avant_gauche,double_diago_avant_droite])
		let singe : Carte = Carte(nom : "singe", couleur : Couleur.Rouge, listeMouvements : [diago_avant_gauche,diago_arriere_gauche,diago_avant_droite,diago_arriere_droite])
		let tigre : Carte = Carte(nom : "tigre", couleur : Couleur.Rouge, listeMouvements : [arriere, double_avant])
		let grenouille : Carte = Carte(nom : "grenouille", couleur : Couleur.Rouge, listeMouvements : [diago_avant_gauche,diago_arriere_droite,double_gauche])
		let lapin : Carte = Carte(nom : "lapin", couleur : Couleur.Rouge, listeMouvements : [diago_arriere_gauche,diago_avant_droite,double_droite])
		let elephant : Carte = Carte(nom : "elephant", couleur : Couleur.Rouge, listeMouvements : [gauche,droite,diago_avant_droite,diago_avant_gauche])
		let oie : Carte = Carte(nom : "oie", couleur : Couleur.Rouge, listeMouvements : [gauche,diago_avant_gauche,droite,diago_arriere_droite])
		let cheval : Carte = Carte(nom : "cheval", couleur : Couleur.Rouge, listeMouvements : [gauche,avant,arriere])
		let bison : Carte = Carte(nom : "bison", couleur : Couleur.Rouge, listeMouvements : [droite,avant,arriere])
		let sanglier : Carte = Carte(nom : "sanglier", couleur : Couleur.Rouge, listeMouvements : [gauche,droite,avant])
		let mante : Carte = Carte(nom : "mante", couleur : Couleur.Rouge, listeMouvements : [arriere,diago_avant_gauche,diago_avant_droite])
		let anguille : Carte = Carte(nom : "anguille", couleur : Couleur.Rouge, listeMouvements : [droite,diago_avant_gauche,diago_arriere_gauche])
		let cobra : Carte = Carte(nom : "cobra", couleur : Couleur.Rouge, listeMouvements : [gauche,diago_arriere_droite,diago_avant_droite])
		//On affecte les cartes aux joueurs
		var all_cards : [Carte] = [porc,dragon,singe,tigre,grenouille,lapin,elephant,cheval,bison,sanglier,anguille,cobra,oie,coq,mante,crabe]
		//On mélange les cartes
		var cards : [Carte] = all_cards.shuffled()
		//On distribue les cartes
		self.joueur1.listeCartes = [cards[0],cards[1]]
		self.joueur2.listeCartes = [cards[2],cards[3]]
		self.carteCourante = cards[4]
		//On creer les 25 positions
		self.plateau = [[Position]](repeating : [Position](repeating : Position(x : 0, y : 0, pion : nil), count : 5), count : 5)
		for l in 0...4{
			for c in 0...4{
				self.plateau[l][c] = Position(x : c, y : l, pion : nil)
			}
		}
		self.joueurCourant = [self.joueur1,self.joueur2].randomElement()!
		//On affecte la bonne position aux pions des 2 joueurs
		for i in 0...4{
			self.joueur1.listePions[i].position = self.getPosition(x : 0, y : i)
			self.joueur2.listePions[i].position = self.getPosition(x : 4, y : i)
			self.getPosition(x : 0, y : i).setPion(pion : self.joueur1.listePions[i])
			self.getPosition(x : 4, y : i).setPion(pion : self.joueur2.listePions[i])
		}
	}

	func estFinie(j1 : Joueur, j2 : Joueur) -> Bool{
		//j1 ou j2 n'as plus de pions
		if(j1.nombrePions() == 0) || (j2.nombrePions() == 0){
			return true
		}
		else{
			//On regarde si les deux joueurs possedent encore leurs maitres
			var nbMaitre : Int = 0
			for elt in j1.afficherPions(){
				if (elt.estMaitre()){
					nbMaitre = nbMaitre + 1
					if ((elt.position.x == 4) && (elt.position.y == 2)){
						return true
					}
				}
			}
			for elt in j2.afficherPions(){
				if (elt.estMaitre()){
					nbMaitre = nbMaitre + 1
					if ((elt.position.x == 0) && (elt.position.y == 2)){
						return true
					}
				}
			}
			return (nbMaitre != 2)
		}
	}

	//func premierTour(p : Partie, c : Carte) // ne sert a rien car quand on créé une partie on doit définir le joueur courant

	func gagnant() -> Joueur{
		//Si le joueur 1 a perdu tous ses pions
		if(self.joueur1.nombrePions() == 0){
			return self.joueur2
		}
		//Si le joueur 1 a perdu tous ses pions
		else if(self.joueur2.nombrePions() == 0){
			return self.joueur1
		}
		else{
			//On regarde si le joueur 1 possede encore son maitre
			for elt in self.joueur1.afficherPions(){
				if (elt.estMaitre()){
					if ((elt.position.x == 2) && (elt.position.y == 4)){
						return self.joueur1
					}
				}
			}
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

	func getPosition(x : Int, y : Int) -> Position {
		return self.plateau[y][x]
	}

	func estPossible(c : Carte, p : Pion, pos : Position) -> Bool {
		var new_x : Int
		var new_y : Int
		if (p.joueur === self.joueur2){
			new_x = p.position.x + pos.x
			new_y = p.position.y + pos.y
		}
		else{
			new_x = p.position.x - pos.x
			new_y = p.position.y - pos.y
		}
		//Il faut vérifier que ces positions appartiennent au plateau
		if ((new_x >= 0) && (new_x <= 4) && (new_y >= 0) && (new_y <= 4)){
			if (!self.getPosition(x : new_x, y : new_y).positionOcc()){
				return true
			}
			else{
				return self.getPosition(x : new_x, y : new_y).getPion()!.joueur.couleur != p.joueur.couleur
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
				if (p.joueur === self.joueur2){
					res.append(self.getPosition(x : elt.x + p.position.x, y : elt.y + p.position.y))
				}
				else{
					res.append(self.getPosition(x : p.position.x - elt.x, y : p.position.y - elt.y))
				}
			}
		}
		return res
	}

	func nbMouvementsPossibles(c : Carte, p : Pion) -> Int {
		return self.mouvementsPossibles(c : c, p : p).count
	}

	func deplacerPion(p : Pion, pos : Position){
		self.getPosition(x : p.position.x, y : p.position.y).pion = nil
		if (self.getPosition(x : pos.x, y : pos.y).positionOcc() ){
			//Il y a un pion sur la position visee
			if (self.getPosition(x : pos.x, y : pos.y).pion!.joueur.couleur != p.joueur.couleur){
				//On capture ce pion, c'est a dire qu'on le supprime du deck de l'autre joueur
				capturePion(p : self.getPosition(x : pos.x, y : pos.y).pion!)
		
			}
		}
		//On dis que le pion sur la position visee est desormais le pion passe en parametre
		self.getPosition(x : pos.x, y : pos.y).pion = p
		//On dit que l'emplacement du pion devient l'emplacement vise
		self.getPosition(x : pos.x, y : pos.y).pion!.position = self.getPosition(x : pos.x, y : pos.y)

	}

	func capturePion(p : Pion) -> Bool {
		//On doit supprimer le pion du deck de l'autre joueur
		changerJoueur()//on change de joueur courant
		if (self.joueurCourant.supprimerPion(p : p)){
			self.joueurCourant.supprimerPion(p : p)//On supprime le pion du deck du joueur
			changerJoueur()//on change de joueur courant
			return true
		}
		else {//On ne peut pas supprimer ou il y a eu un probleme...
			changerJoueur()//on change de joueur courant
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
		//On cherche la carte c1 dans le deck du joueur courant et on l'echange avec :temp: (ancienne carte courante)
		if (self.joueurCourant.listeCartes[0] === c1){
			self.joueurCourant.listeCartes[0] = temp
		}
		else {
			self.joueurCourant.listeCartes[1] = temp
		}
	}
}

protocol TPion{
	// position : Pion -> Position
	// Indique la position du pion
	// Post: Retourne la position du pion
	var position : Position {get set}

	var joueur : Joueur {get}

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

	private var maitre : Bool
	var joueur : Joueur
	var position : Position

	required init(j : Joueur, maitre : Bool, position : Position){
		self.joueur = j
		self.maitre = maitre
		self.position = position
	}

	func estMaitre() -> Bool{
		return self.maitre
	}
}

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
		return (self.pion !== nil) 
	}

	func getPion() -> Pion?{
		return self.pion
	}

	func setPion(pion : Pion?){
		self.pion = pion
	}
}

/*									Programme principal									*/


func saisirEntier(type : String, borneinf : Int, bornesup : Int) -> Int{
	print(">> Veuillez choisir " + type + " : ")
	guard let input = readLine() else{
		return saisirEntier(type : type, borneinf : borneinf, bornesup : bornesup)
	}
	if let result = Int(input) {
		//On verifie que l'entier est compris entre borneinf et bornesup 
		if (result >= borneinf) && (result <= bornesup){
			return result
		}
		else{
			print(">> Veuillez saisir un entier entre \(borneinf) et \(bornesup)")
			return saisirEntier(type : type, borneinf : borneinf, bornesup : bornesup)
		}
	}
	else{
		print("<Oops> L'entier saisi n'est pas valide ! <Oops>")
		return saisirEntier(type : type, borneinf : borneinf, bornesup : bornesup)
	}
}

func affichePlateau(partie : Partie){
	var ligne : String
	print("\t       \\\t0\t1\t2\t3\t4\t(x)\n")
	for l in 0...4{
		ligne = "\t       " + String(l) + "\t"
		for c in 0...4{

			if !partie.getPosition(x : c, y : l).positionOcc(){
				ligne = ligne + " \t"
			}

			else{
				var pionCourant : Pion = partie.getPosition(x : c, y : l).getPion()!
				var forme : String
				if (pionCourant.joueur.couleur == partie.joueur1.couleur) && (!pionCourant.estMaitre()){
					// les pions du joueur 1 prend la forme O
					forme = "\u{25A1}"
				}
				else if (pionCourant.joueur.couleur == partie.joueur1.couleur) && (pionCourant.estMaitre()){
					// les pions du joueur 1 prend la forme O
					forme = "\u{25A0}"
				}
				else if (pionCourant.joueur.couleur == partie.joueur2.couleur) && (!pionCourant.estMaitre()){
					// les pions du joueur 1 prend la forme O
					forme = "\u{25CB}"
				}
				else{
					// les pions du joueur 2 prend la forme X
					forme = "\u{25CF}"
				}
				ligne = ligne + forme + "\t"				
			}
		}
		print(ligne + "\n")
	}
	print("\t      (y)\n\n")
}

func saisirNom(num : Int)->String {
	print(">> Veuillez entrer votre nom joueur \(num): ")
	let input = readLine()
	if let nom : String = input {
		return nom
	}
	else{
		print("<Oops> Nom invalide <Oops>")
		return saisirNom(num : num)
	}
}

//Demander les noms des joueurs
var nomjoueur1 : String = saisirNom(num : 1)
var nomjoueur2 : String = saisirNom(num : 2)

//Création des joueurs
var joueur1 : Joueur = Joueur(nom : nomjoueur1, couleur : Couleur.Rouge)
var joueur2 : Joueur = Joueur(nom : nomjoueur2, couleur : Couleur.Bleu)
var partie : Partie  = Partie(j1 : joueur1, j2 : joueur2)

//Cette variable est pour savoir si le joueur a joué ou non
var pass : Bool = false

//Un peu d'affichage d'ascii art..
var temple = "\n\n               )\\         O_._._._A_._._._O         /(\n                \\`--.___,'=================`.___,--'/\n                 \\`--._.__                 __._,--'/\n                   \\  ,. l`~~~~~~~~~~~~~~~'l ,.  /\n       __            \\||(_)!_!_!_.-._!_!_!(_)||/            __\n       \\`-.__        ||_|____!!_|;|_!!____|_||        __,-'//\n        \\    `==---='-----------'='-----------`=---=='    //\n        | `--.                                         ,--' |\n         \\  ,.`~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',.  /\n           \\||  ____,-------._,-------._,-------.____  ||/\n            ||\\|___!`======='!`======='!`======='!___|/||\n            || |---||--------||-| | |-!!--------||---| ||\n  __O_____O_ll_lO_____O_____O|| |'|'| ||O_____O_____Ol_ll_O_____O__\n  o H o o H o o H o o H o o |-----------| o o H o o H o o H o o H o\n ___H_____H_____H_____H____O =========== O____H_____H_____H_____H___\n                          /|=============|\\\n()______()______()______() '==== +-+ ====' ()______()______()______()\n||{_}{_}||{_}{_}||{_}{_}/| ===== |_| ===== |\\{_}{_}||{_}{_}||{_}{_}||\n||      ||      ||     / |==== s(   )s ====| \\     ||      ||      ||\n======================()  =================  ()======================\n----------------------/| ------------------- |\\----------------------\n                     / |---------------------| \\\n-'--'--'           ()  '---------------------'  ()\n                   /| ------------------------- |\\    --'--'--'\n       --'--'     / |---------------------------| \\    '--'\n                ()  |___________________________|  ()           '--'-\n  --'-          /| _______________________________  |\\|\n --'           / |__________________________________| \\ \n\n"
var onitama = "\n\n\n                _____       _ _\n               |  _  |     (_) |\n               | | | |_ __  _| |_ __ _ _ __ ___   __ _\n               | | | | '_ \\| | __/ _` | '_ ` _ \\ / _` |\n               \\ \\_/ / | | | | || (_| | | | | | | (_| |\n                \\___/|_| |_|_|\\__\\__,_|_| |_| |_|\\__,_|\n"
var parch = "                    ______________________________\n                  / \\                             \\\n                 |   |  Bienvenue petits scarabés |\n                  \\_ |  ''''''''''''''''''''''''' |\n                     | Les règles du jeu sont     |\n                     | simples, vous allez vous   |\n                     | affronter dans un combat   |\n                     | sans pitié où seul le plus |\n                     | rusé l'emportera.          |\n                     |                            |\n                     | Vous serez accompagné de   |\n                     | vos plus fidèles disciples |\n                     | pour accomplir cette tache.|\n                     |                            |\n                     | Bonne chance à vous deux ! |\n                     |   _________________________|___\n                     |  /                -Bruce Lee- /\n                     \\_/____________________________/\n\n"
let space = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
print(onitama)
print(temple)
print("~ Vous venez de recevoir un parchemin, pressez sur une touche pour le lire ~\n")
var enter = readLine()//Pour n'afficher le reste que si le joueur reagit
print(parch)
print("               Pressez une touche pour commencer le combat...\n")
enter = readLine()//Pour n'afficher le reste que si le joueur reagit
print(space)

//Boucle principale
while(!partie.estFinie(j1 : partie.joueur1, j2 : partie.joueur2)){
	//On affiche le plateau
	print(space)
	print(onitama)
	print(temple)
	affichePlateau(partie : partie)
	//On affiche les pions du joueur courant
	var ligne : String = "\n>> \(partie.joueurCourant.nom), voici vos pions :\t\t"
	var i : Int = 1
	for elt in partie.joueurCourant.afficherPions(){
		ligne = ligne + "\(i).(x : \(elt.position.x) , y : \(elt.position.y))\t\t"
		i = i + 1
	}
	print(ligne)
	//On affiche les cartes du joueur courant
	print(">>\n>> et voici vos cartes :\t\t1.<\(partie.joueurCourant.afficherCartes()[0].nom)>\t\t2.<\(partie.joueurCourant.afficherCartes()[1].nom)>\n>>")
	//On afiche aussi la carte courante
	print(">> voici la carte courante :\t\t1.<\(partie.carteCourante.afficherCarte())>\n>>")
	//On dit que le joueur viens d'avoir la main il n'a donc pas encore pose de pion
	pass = false
	//Tant que le joueur peut jouer et qu'il n'a pas poser de pion
	while(partie.peutJouer(j : partie.joueurCourant)) && (pass == false){
		//Il doit choisir une carte
		let indiceCarte : Int = saisirEntier(type : "une carte", borneinf : 1, bornesup : 2)
		let carteChoisi : Carte = partie.joueurCourant.selectCarte(indice : indiceCarte)
		//Il doit choisir un pion
		let indicePion : Int = saisirEntier(type : "un pion", borneinf : 1, bornesup : partie.joueurCourant.nombrePions())
		let pionChoisi : Pion = partie.joueurCourant.choisirPion(indice : indicePion)
		//Si il est possible de jouer avec cette carte et ce pion
		if (partie.nbMouvementsPossibles(c : carteChoisi, p : pionChoisi) > 0){
			//Il va pouvoir jouer donc on doit sortir de la boucle
			pass = true
			//On affiche les mouvements possibles avec cette carte et ce pion
			ligne = ">> Vous pouvez bouger ce pion en :\t\t"
			let mouvementsP : [Position] = partie.mouvementsPossibles(c : carteChoisi, p : pionChoisi)
			var i : Int = 1
			for elt in mouvementsP{
				if (elt.positionOcc()){
					ligne = ligne + "~ \(i).(x : \(elt.x) , y : \(elt.y)) ~\t\t"
				}
				else{
					ligne = ligne + "\(i).(x : \(elt.x) , y : \(elt.y))\t\t"
				}
				i = i + 1
			}
			print(ligne + "\n>>")
			//On demande au joueur de choisir un mouvement
			let indiceMouvement : Int = saisirEntier(type : "le numéro de la nouvelle position", borneinf : 1, bornesup : partie.nbMouvementsPossibles(c : carteChoisi, p : pionChoisi))
			let mouvementChoisi : Position = partie.selectPosition(mouvements : mouvementsP, indice : indiceMouvement)
			//Si grace a ce mouvement il tombe sur un pion adverse
			if (mouvementChoisi.positionOcc()){
				//Il capture le pion adverse
				var sword = "\n\n,_._._._._._._._._|__________________________________________________________,\n|_|_|_|_|_|_|_|_|_|_________________________________________________________/\n                  !         Bravo, pion du joueur adverse elimine\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
				print(space)
				print(sword)
				print("               Pressez une touche pour continuer le combat...\n")
				enter = readLine()//Pour n'afficher le reste que si le joueur reagit

			}
			//On deplace reelement le pion a son nouvel emplacement
			partie.deplacerPion(p : pionChoisi, pos : mouvementChoisi)
			//On echange la carte jouee avec la carte courante
			partie.echangerCarte(l1 : partie.joueurCourant.listeCartes, c1 : carteChoisi, c2 : partie.carteCourante)
		}
		//Si il n'est pas possible de joueur avec cette carte et ce pion
		else{
			print("Il n'existe aucun mouvement possible pour cette carte et ce pion...")
		}
	//On recommence si le joueur n'as pas pu jouer
	}
	partie.changerJoueur()
}


//Fin de partie, affichage du vainqueur
var nom : String
if (partie.gagnant() === partie.joueur1) {
	nom = partie.joueur1.nom + "." + String(repeating : " ", count : (20 - partie.joueur1.nom.count))//formater correctement le nom pour le print final
}
else {
	nom = partie.joueur2.nom + "." + String(repeating : " ", count : (20 - partie.joueur1.nom.count))//formater correctement le nom pour le print final
}

let bravo = "\n\n  ____                                                 _        _\n |  _ \\                                               | |      //\n | |_) |_ __ __ ___   _____    ___  ___ __ _ _ __ __ _| |__   ___\n |  _ <| '__/ _` \\ \\ / / _ \\  / __|/ __/ _` | '__/ _` | '_ \\ / _ \\\n | |_) | | | (_| |\\ V / (_) | \\__ \\ (_| (_| | | | (_| | |_) |  __/\n |____/|_|  \\__,_| \\_/ \\___/  |___/\\___\\__,_|_|  \\__,_|_.__/ \\___|\n\n"
var fin = "\n                    ______________________________\n                  / \\                             \\\n                 |   |     Bravo jeune scarabé    |\n                  \\_ |  ''''''''''''''''''''''''' |\n                     | Je n'ai jamais douté de ta |\n                     | force \(nom)|\n                     |                            |\n                     | Je ne suis pas surpris que |\n                     | tu ais vaincu ces minables |\n                     | apprentis mal entrainés.   |\n                     |                            |\n                     | Reviens me voir quand tu   |\n                     | sera prêt à relever un     |\n                     | autre défis. Encore bravo  |\n                     | et bon repos.              |\n                     |   _________________________|___\n                     |  /                -Bruce Lee- /\n                     \\_/____________________________/\n\n\n"
print(space)
print(bravo)
print(fin) 
//FIN