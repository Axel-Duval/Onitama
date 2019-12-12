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

while(!partie.estFinie(j1 : partie.joueur1, j2 : partie.joueur2)){
	//On affiche le plateau
	affichePlateau(partie : partie)
	//On affiche les pions du joueur courant
	print("Voici vos pions :")
	print (partie.joueurCourant.afficherPions())
	//On affiche les cartes du joueur courant
	print("Voici vos cartes :")
	print(partie.joueurCourant.afficherCartes())
	//On dit que le joueur viens d'avoir la main il n'a donc pas encore pose de pion
	pass = false
	//Tant que le joueur peut jouer et qu'il n'a pas poser de pion
	while(partie.peutJouer(j : partie.joueurCourant)) && (pass == false){
		//Il doit choisir une carte
		let indiceCarte : Int = saisirEntier(type : "un numéro de carte, 1 ou 2", borneinf : 1, bornesup : 2)
		let carteChoisi : Carte = partie.joueurCourant.selectCarte(indice : indiceCarte)
		//Il doit choisir un pion
		let indicePion : Int = saisirEntier(type : "numéro de pion", borneinf : 1, bornesup : partie.joueurCourant.nombrePions())
		let pionChoisi : Pion = partie.joueurCourant.choisirPion(indice : indicePion)
		//Si il est possible de jouer avec cette carte et ce pion
		if (partie.nbMouvementsPossibles(c : carteChoisi, p : pionChoisi) > 0){
			//Il va pouvoir jouer donc on doit sortir de la boucle
			pass = true
			//On affiche les mouvements possibles avec cette carte et ce pion
			print("Les mouvements possibles sont :")
			let mouvementsP : [Position] = partie.mouvementsPossibles(c : carteChoisi, p : pionChoisi)			
			for i in 0...mouvementsP.count{
				print(mouvementsP[i])
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