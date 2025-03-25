# Gestion des Utilisateurs sous Linux

Ce projet propose un script Bash permettant d'ajouter des utilisateurs, de leur attribuer des permissions et de désactiver uniquement les comptes utilisateurs créés par ce script s'ils sont inactifs pendant plus de 90 jours.

##  Fonctionnalités

- Création automatique d'utilisateurs à partir d'un fichier `users.txt`.
- Attribution des groupes et permissions correctes pour chaque utilisateur.
- Désactivation uniquement des comptes utilisateurs créés par le script s'ils sont inactifs depuis plus de 90 jours.
- Vérification et correction des permissions des répertoires personnels des utilisateurs.

##  Installation et Utilisation

###  Prérequis
- Système Linux avec `bash` installé.
- Droits `root` pour exécuter le script.
- Fichier `users.txt` contenant les utilisateurs à créer sous le format :
  ```
  username:groupname
  ```

###  Installation
Clonez le dépôt Git :
```bash
 git clone https://github.com/votre-utilisateur/gestion-utilisateurs.git
 cd gestion-utilisateurs
```

###  Exécution du script
Donnez les permissions d'exécution :
```bash
chmod +x gestion_utilisateurs.sh
```
Exécutez le script en tant que `root` :
```bash
sudo ./gestion_utilisateurs.sh
```

##  Exemple d’exécution
```bash
$ sudo ./gestion_utilisateurs.sh
Création des utilisateurs et assignation des permissions...
✅ Utilisateur alice ajouté avec succès.
✅ Utilisateur hen ajouté avec succès.
✅ Utilisateur vicky ajouté avec succès.
...
✅ Permissions corrigées pour /home/alice
✅ Permissions corrigées pour /home/hen
✅ Permissions corrigées pour /home/vicky
...
Vérification et désactivation des utilisateurs inactifs...
❌ Compte de alice désactivé (inactif depuis 120 jours).
✅ Compte de hen actif (inactif depuis 50 jours, pas de désactivation).
...
Script terminé avec succès.
```

##  Contributions
Les contributions sont les bienvenues ! Pour proposer des améliorations :
1. Forkez le projet 📌.
2. Créez une branche (`git checkout -b feature-nom`).
3. Commitez vos modifications (`git commit -m "Ajout d'une nouvelle fonctionnalité"`).
4. Pushez sur votre branche (`git push origin feature-nom`).
5. Ouvrez une Pull Request 🚀.

## 📄 Licence
Ce projet est sous licence MIT. Vous êtes libre de l'utiliser et de le modifier selon vos besoins.

---
💡 *N’hésitez pas à laisser une étoile ⭐ sur le projet si vous le trouvez utile !*

