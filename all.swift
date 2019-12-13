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
		//init de pions avec position absurde (pions pas sur le plateau)
		let pos : Position = Position(x : -10, y : -10, pion : nil)
		let p1 : Pion = Pion(j : self, maitre : false, position : pos)
		let p2 : Pion = Pion(j : self, maitre : true, position : pos)
		self.listePions = [p1, p1, p2, p1, p1]
		//init de fausse cartes pour pouvoir ensuite leur donner une vrai valeur...
		let c1 : Carte = Carte(nom : "pour init", couleur : couleur, listeMouvements : [pos])
		self.listeCartes = [c1,c1]
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
	var estFinie : Bool
	var plateau : [[Position]]

	required init(j1 : Joueur, j2 : Joueur){
		self.joueur1 = j1
		self.joueur2 = j2
		self.estFinie = false
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
			self.plateau[0][i].setPion(pion : self.joueur1.listePions[i])
			self.plateau[4][i].setPion(pion : self.joueur2.listePions[i])
			self.joueur1.listePions[i].position = self.plateau[0][i]
			self.joueur2.listePions[i].position = self.plateau[4][i]
		}
		self.joueurCourant = [self.joueur1,self.joueur2].randomElement()!
	}

	func estFinie(j1 : Joueur, j2 : Joueur) -> Bool{
		return false
	}

	//func premierTour(p : Partie, c : Carte) // ne sert a rien car quand on créé une partie on doit définir le joueur courant

	func gagnant() -> Joueur{
		//Si le joueur 2 a perdu tous ses pions
		if (self.joueur2.nombrePions() == 0){
			return self.joueur1
		}
		//Si le joueur 1 a perdu tous ses pions
		else if (self.joueur1.nombrePions() == 0){
			return self.joueur2
		}
		else{
			//Si le joueur 2 a perdu son maitre alors joueur 1 gagne sinon c'est l'inverse
			var winner : Joueur = self.joueur1
			for elt in self.joueur2.afficherPions(){
				if (elt.estMaitre()){
					winner = self.joueur2
				}
			}
			return winner
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
				return self.plateau[new_x][new_y].getPion()!.joueur.couleur != p.joueur.couleur
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
		self.plateau[pos.x][pos.y].pion = p//On dit que le nouvel emplacement du pion est occupee
	}

	func capturePion(p : Pion) -> Bool {
		changerJoueur()//on change de joueur courant
		if (self.joueurCourant.supprimerPion(p : p)){
			self.joueurCourant.supprimerPion(p : p)//On supprime le pion du deck du joueur
			changerJoueur()//on change de joueur courant
			return true
		}
		else {
			changerJoueur()
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
		return self.estMaitre()
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
		return (self.pion === nil) 
	}

	func getPion() -> Pion?{
		return self.pion
	}

	func setPion(pion : Pion?){
		self.pion = pion
	}
}

func saisirEntier(type : String, borneinf : Int, bornesup : Int) -> Int{
	print("Veuillez choisir " + type + " : ")
	guard let input = readLine() else{
		return saisirEntier(type : type, borneinf : borneinf, bornesup : bornesup)
	}
	if let result = Int(input) {
		//On verifie que l'entier est compris entre borneinf et bornesup 
		if (result >= borneinf) && (result <= bornesup){
			return result
		}
		else{
			print("Veuillez saisir un entier entre \(borneinf) et \(bornesup)")
			return saisirEntier(type : type, borneinf : borneinf, bornesup : bornesup)
		}
	}
	else{
		print("L'entier saisi n'est pas valide !")
		return saisirEntier(type : type, borneinf : borneinf, bornesup : bornesup)
	}
}

func affichePlateau(partie : Partie){
	var ligne : String
	print("0\t1\t2\t3\t4\t5")
	for l in 0...4{
		ligne = String(l+1)
		for c in 0...4{

			if !partie.getPosition(x : l, y : c).positionOcc(){
				ligne = ligne + " \t"

			}
			else{
				var pionCourant : Pion
				if let x = partie.getPosition(x : l, y : c).getPion(){
					pionCourant = x
					var forme : String
					if (partie.joueurCourant.couleur == partie.joueur1.couleur){
						// les pions du joueur 1 prend la forme O
						forme = "O"
					}
					else{
						// les pions du joueur 2 prend la forme X
						forme = "X"
					}
					if(pionCourant.estMaitre()){
						// les maitres prennent la forme suivante : <X> ou <O>
						forme = "<" + forme + ">"
					}
					ligne = ligne + forme
				}
				
			}
		}
	}
}

func saisirNom()->String {
	print("Veuillez entrer votre nom : ")
	let input = readLine()
	if let nom : String = input {
		return nom
	}
	else{
		print("Nom invalide")
		return saisirNom()
	}
}


print("Nom du joueur 1")
var nomjoueur1 : String = saisirNom()

print("Nom du joueur 2")
var nomjoueur2 : String = saisirNom()

var joueur1: Joueur = Joueur(nom : nomjoueur1, couleur : Couleur.Rouge)
var joueur2: Joueur = Joueur(nom : nomjoueur2, couleur : Couleur.Bleu)
var partie : Partie  = Partie(j1 : joueur1, j2 : joueur2)

//Cette variable est pour savoir si le joueur a joue ou non
var pass : Bool = false

print("C'est parti !")

while(!partie.estFinie(j1 : partie.joueur1, j2 : partie.joueur2)){
	var ligne : String = ""
	//On affiche le plateau
	affichePlateau(partie : partie)
	//On affiche les pions du joueur courant
	print("\nVoici vos pions :")
	for elt in partie.joueurCourant.afficherPions(){
		ligne = ligne + "(x : \(elt.position.x) y : \(elt.position.y))\t"
	}
	print(ligne)
	//On affiche les cartes du joueur courant
	print("\nVoici vos cartes :")
	ligne = ""
	for elt in partie.joueurCourant.afficherCartes(){
		ligne = ligne + elt.afficherCarte() + "\t"
	}
	print(ligne)
	//On dit que le joueur viens d'avoir la main il n'a donc pas encore pose de pion
	pass = false
	//Tant que le joueur peut jouer et qu'il n'a pas poser de pion
	while(partie.peutJouer(j : partie.joueurCourant)) && (pass == false){
		//Il doit choisir une carte
		let indiceCarte : Int = saisirEntier(type : "un numéro de carte, 1 ou 2", borneinf : 1, bornesup : 2)
		let carteChoisi : Carte = partie.joueurCourant.selectCarte(indice : indiceCarte)
		//Il doit choisir un pion
		let indicePion : Int = saisirEntier(type : "un numéro de pion", borneinf : 1, bornesup : partie.joueurCourant.nombrePions())
		let pionChoisi : Pion = partie.joueurCourant.choisirPion(indice : indicePion)
		//Si il est possible de jouer avec cette carte et ce pion
		if (partie.nbMouvementsPossibles(c : carteChoisi, p : pionChoisi) > 0){
			//Il va pouvoir jouer donc on doit sortir de la boucle
			pass = true
			//On affiche les mouvements possibles avec cette carte et ce pion
			print("Les mouvements possibles sont :")
			let mouvementsP : [Position] = partie.mouvementsPossibles(c : carteChoisi, p : pionChoisi)	
			for elt in mouvementsP{
				print(elt.x)
			}
			//On demande au joueur de choisir un mouvement
			print("Choisissez un mouvement : ")
			let indiceMouvement : Int = saisirEntier(type : "un numéro de mouvement", borneinf : 1, bornesup : partie.nbMouvementsPossibles(c : carteChoisi, p : pionChoisi))
			let mouvementChoisi : Position = partie.selectPosition(mouvements : mouvementsP, indice : indiceMouvement)
			//Si grace a ce mouvement il tombe sur un pion adverse
			if (mouvementChoisi.positionOcc()){
				//Il capture le pion adverse
				partie.capturePion(p : mouvementChoisi.getPion()!)
				print("Vous avez capturé un pion adverse")
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

if (partie.gagnant().couleur == partie.joueur1.couleur) {
	print("Le joueur 1 a gagné")
}
else {
	print("Le joueur 2 a gagné")
}