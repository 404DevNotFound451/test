# Variables
$LocalAdminUser = "p888"  # Nom de l'utilisateur local
$LocalAdminPassword = "123456"  # Mot de passe pour l'utilisateur local
$NewComputerName = "poste888"  # Nouveau nom de l'ordinateur
$WorkgroupName = "LGPI"  # Nom du groupe de travail

# Convertir le mot de passe en chaîne sécurisée
$SecPassword = ConvertTo-SecureString $LocalAdminPassword -AsPlainText -Force

# Créer ou mettre à jour le compte utilisateur local
Write-Host "Création ou mise à jour du compte local '$LocalAdminUser'..."
Try {
    New-LocalUser -Name $LocalAdminUser -Password $SecPassword -FullName "Administrateur local" -Description "Compte local administrateur" -ErrorAction Stop
    Write-Host "Compte local '$LocalAdminUser' créé avec succès."
} Catch {
    Write-Host "Le compte '$LocalAdminUser' existe déjà ou une erreur s'est produite : $_"
}

# Ajouter l'utilisateur au groupe Administrateurs
Write-Host "Ajout de '$LocalAdminUser' au groupe Administrateurs..."
Try {
    Add-LocalGroupMember -Group "Administrateurs" -Member $LocalAdminUser -ErrorAction Stop
    Write-Host "Utilisateur '$LocalAdminUser' ajouté au groupe Administrateurs avec succès."
} Catch {
    Write-Host "Impossible d'ajouter l'utilisateur '$LocalAdminUser' au groupe Administrateurs : $_"
}

# Modifier le nom de l'ordinateur
Write-Host "Modification du nom de l'ordinateur en '$NewComputerName'..."
Try {
    Rename-Computer -NewName $NewComputerName -Force -ErrorAction Stop
    Write-Host "Nom de l'ordinateur changé en '$NewComputerName' avec succès."
} Catch {
    Write-Host "Échec de la modification du nom de l'ordinateur : $_"
}

# Quitter le domaine et rejoindre le groupe de travail
Write-Host "Sortie du domaine et jonction au groupe de travail '$WorkgroupName'..."
Try {
    Remove-Computer -WorkgroupName $WorkgroupName -LocalCredential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $LocalAdminUser, $SecPassword) -Force -Restart
    Write-Host "Ordinateur retiré du domaine et ajouté au groupe de travail '$WorkgroupName'."
} Catch {
    Write-Host "Échec de la sortie du domaine : $_"
}
