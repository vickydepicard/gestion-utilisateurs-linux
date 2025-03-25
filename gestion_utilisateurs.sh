#!/bin/bash

# Vérifie si l'utilisateur exécutant le script est root
if [[ $(id -u) -ne 0 ]]; then
    echo "$(whoami) : Vous n'êtes pas autorisé à exécuter cette commande."
    echo "Ce script doit être exécuté en tant que root."
    exit 1
fi

echo "Vous êtes bien root. Le script continue..."

# Fichier contenant les utilisateurs à créer
USER_LIST="users.txt"

# Vérifier si le fichier existe
if [[ ! -f "$USER_LIST" ]]; then
    echo "Erreur : Le fichier $USER_LIST n'existe pas."
    exit 1
fi

# Liste des utilisateurs ajoutés
ADDED_USERS=()

echo "Création des utilisateurs et assignation des permissions..."
while IFS=":" read -r username groupname; do
    # Ignorer les lignes vides ou mal formatées
    if [[ -z "$username" || -z "$groupname" ]]; then
        echo "⚠️ Avertissement : Ligne vide ou mal formatée détectée, ignorée."
        continue
    fi

    # Vérifier si le groupe existe, sinon le créer
    if ! getent group "$groupname" > /dev/null; then
        groupadd "$groupname"
        echo "Groupe $groupname créé."
    fi

    # Vérifier si l'utilisateur existe déjà
    if id "$username" &>/dev/null; then
        echo "L'utilisateur $username existe déjà."
    else
        useradd -m -s /bin/bash -G "$groupname" "$username"
        echo "$username:$username@123" | chpasswd
        echo "✅ Utilisateur $username ajouté avec succès."
        ADDED_USERS+=("$username")
    fi

    # Corriger les permissions du répertoire personnel
    chown "$username:$username" "/home/$username"
    chmod 700 "/home/$username"
    echo "✅ Permissions corrigées pour /home/$username"
done < "$USER_LIST"

echo "Vérification et désactivation des utilisateurs inactifs..."
CURRENT_DATE=$(date +%s)  # Date actuelle en secondes

for user in "${ADDED_USERS[@]}"; do
    # Vérifier si l'utilisateur existe toujours
    if ! id "$user" &>/dev/null; then
        continue
    fi

    # Récupérer la dernière connexion en excluant "still logged in"
    LAST_LOGIN_INFO=$(last -FR "$user" | grep -v "still logged in" | head -n 1 | awk '{print $5, $6, $7}')

    # Vérifier si l'utilisateur ne s'est jamais connecté
    if [[ -z "$LAST_LOGIN_INFO" || "$LAST_LOGIN_INFO" == "**Never logged in**" ]]; then
        echo "⚠️ $user n'a jamais été utilisé. Aucune action prise."
        continue
    fi

    # Vérifier le format de la date avant conversion
    if ! date -d "$LAST_LOGIN_INFO" "+%s" &>/dev/null; then
        echo "⚠️ Format de date invalide pour $user : '$LAST_LOGIN_INFO'"
        continue
    fi

    # Convertir la date en timestamp
    LAST_LOGIN_TIMESTAMP=$(date -d "$LAST_LOGIN_INFO" +%s)

    # Calcul du nombre de jours d'inactivité
    DIFF_DAYS=$(( (CURRENT_DATE - LAST_LOGIN_TIMESTAMP) / 86400 ))

    if (( DIFF_DAYS > 90 )); then
        usermod -L "$user"
        echo "❌ Compte de $user désactivé (inactif depuis $DIFF_DAYS jours)."
    else
        echo "✅ Compte de $user actif (inactif depuis $DIFF_DAYS jours, pas de désactivation)."
    fi
done

echo "Script terminé avec succès."

