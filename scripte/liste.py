#!/usr/bin/env python3
''' 
Ce script pour Python 3 récupère trois listes d'adresses IP a bannir sur les réseaux Peer-to-Peer
Ces listes sont récupérées depuis le site ipblocklist.com
Comme le site les fournit compressées en GZip, ce script se charge de la décompression.
Il se charge aussi d'assembler les trois listes, en les concaténant vers un fichier dans le répertoire courant
Ce script se lance sans argument, par exemple avec la commande suivante:
	$ python3 charger_listes.py
La sortie se situera dans le fichier liste_filtrage_bittorrent.txt du répertoire courant. Ce fichier 
sera écrasé s'il existe déja au moment du lancement du programme. 
'''


from io import BytesIO
import gzip, codecs, sys, time
from urllib.request import Request
from urllib.request import urlopen 


# Les chemins d'acces vers les trois listes a recuperer
chemin_bt_level_1 = r'http://list.iblocklist.com/?list=bt_level1&fileformat=p2p&archiveformat=gz'
chemin_bt_level_2 = r'http://list.iblocklist.com/?list=bt_level2&fileformat=p2p&archiveformat=gz'
chemin_bt_level_3 = r'http://list.iblocklist.com/?list=bt_level3&fileformat=p2p&archiveformat=gz'


'''
Une fonction qui se connecte au serveur, récupère la liste dont le chemin est passé en argument,
Décompresse la liste, et la renvoie sous la forme d'une chaine de caracteres
prete a etre affichee ou inseree dans un fichier
'''
def charger(chemin):
	request = Request(chemin)
	request.add_header('Accept-encoding', 'gzip')

	print('Connexion...')
	response = urlopen(request)
	info = response.info()

	sys.stdout.write('Chargement... ')
	sys.stdout.flush()
	temps = time.time()
	data = response.read()
	buf = BytesIO(data)
	temps = time.time() - temps
	print ('terminé en %.3f secondes, %d octets lus' % (temps, len(data)))

	sys.stdout.write('Decompression... ')
	sys.stdout.flush()
	temps = time.time()
	f = gzip.GzipFile(fileobj=buf)
	data = f.read()
	temps = time.time() - temps
	print('terminé en %.3f secondes, %d octets décompressés' % (temps, len(data)))

	texte = data.decode(errors='ignore')
	return texte


'''
Fonction principale du programme
Appelle trois fois la fonction charger() pour récupérer les trois listes
Ouvre un fichier en écriture ; ce fichier est écrasé s'il existe deja
Replit le fichier avec la concaténation des trois listes récupérées depuis Internet
'''
def main():
	contenus = []
	adresses = [chemin_bt_level_1, chemin_bt_level_2, chemin_bt_level_3]

	for adresse in adresses:
		print(adresse)
		contenus.append(charger(adresse))
		print("Fini.\n")

	fichier = './liste_filtrage_bittorrent.txt'

	with codecs.open(fichier, 'w', encoding='utf8', errors='ignore') as sortie:
		print("\nCreation du fichier de sortie : " + fichier)
		for contenu in contenus:
			sortie.write(contenu)
		print('Fichier de sortie termine')



'''
Si ce fichier est le fichier passé en argument a l'interpréteur et non inclus 
en tant que module on lance la fonction principale
'''
if __name__ == '__main__':
	main()
