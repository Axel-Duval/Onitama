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


while(!partie.estFinie(j1 : partie.joueur1, j2 : partie.joueur2)){

	affichePlateau(partie : partie)
	print("Voici vos pions :")
	print (partie.joueurCourant.afficherPions())
	print("Voici vos cartes :")
	print(partie.joueurCourant.afficherCartes())
	// Tant que le joueur courant peut encore deplacer un pion (si avec une carte aucun mouvement n'est possible alors propose l'autre carte du joueur)
	// Sinon le jouer ne fait aucun mouvement et l'autre joueur prend son tour
	while(partie.peutJouer(j : partie.joueurCourant)){
		let indiceCarte : Int = saisirEntier(type : "un numéro de carte, 1 ou 2", borneinf : 1, bornesup : 2)
		let carteChoisi : Carte = partie.joueurCourant.selectCarte(indice : indiceCarte)
		let indicePion : Int = saisirEntier(type : "numéro de pion", borneinf : 1, bornesup : partie.joueurCourant.nombrePions())
		let pionChoisi : Pion = partie.joueurCourant.choisirPion(indice : indicePion)
		print("Les mouvements possibles sont :")
		let mouvementsP : [Position] = partie.mouvementsPossibles(c : carteChoisi, p : pionChoisi)
		
		for i in 0...mouvementsP.count{
			print(mouvementsP[i])
		}
		print("Choisissez un mouvement")
		let indiceMouvement : Int = saisirEntier(type : "numéro de mouvement", borneinf : 1, bornesup : partie.nbMouvementsPossibles(c : carteChoisi, p : pionChoisi))
		let mouvementChoisi : Position = partie.selectPosition(mouvements : mouvementsP, indice : indiceMouvement)

		if (mouvementChoisi.positionOcc()) {
			let pionCapture : Pion = mouvementChoisi.getPion()!
			if(partie.capturePion(p : pionCapture)){
				print("Vous avez capturé un pion")
			}
		}
		partie.deplacerPion(p : pionChoisi, pos : mouvementChoisi)
		partie.echangerCarte(l1 : partie.joueurCourant.listeCartes, c1 : carteChoisi, c2 : partie.carteCourante)
	}		
	affichePlateau(partie : partie)
	partie.changerJoueur()
}

if (partie.gagnant().couleur == partie.joueur1.couleur) {
	print("Le joueur 1 a gagné")
}
else {
	print("Le joueur 2 a gagné")
}