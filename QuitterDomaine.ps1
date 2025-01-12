# Variables
$LocalAdminUser = "p888"  # Nom de l'utilisateur local
$LocalAdminPassword = "123456"  # Mot de passe pour l'utilisateur local
$NewComputerName = "poste888"  # Nouveau nom de l'ordinateur
$WorkgroupName = "LGPI"  # Nom du groupe de travail

# Convertir le mot de passe en chaîne sécurisée
$SecPassword = ConvertTo-SecureString $LocalAdminPassword -AsPlainText -Force

# Étape 1 : Créer ou mettre à jour l'utilisateur local
Write-Host "Création ou mise à jour de l'utilisateur local '$LocalAdminUser'..."
Try {
    New-LocalUser -Name $LocalAdminUser -Password $SecPassword -FullName "Administrateur local p888" -Description "Compte local administrateur" -ErrorAction Stop
    Write-Host "Utilisateur '$LocalAdminUser' créé avec succès."
} Catch {
    Write-Host "L'utilisateur '$LocalAdminUser' existe déjà ou une erreur s'est produite : $_"
}

# Ajouter l'utilisateur au groupe Administrateurs
Write-Host "Ajout de l'utilisateur '$LocalAdminUser' au groupe Administrateurs..."
Try {
    Add-LocalGroupMember -Group "Administrateurs" -Member $LocalAdminUser -ErrorAction Stop
    Write-Host "Utilisateur '$LocalAdminUser' ajouté au groupe Administrateurs avec succès."
} Catch {
    Write-Host "Impossible d'ajouter l'utilisateur '$LocalAdminUser' au groupe Administrateurs : $_"
}

# Étape 2 : Modifier le nom de l'ordinateur
Write-Host "Modification du nom de l'ordinateur en '$NewComputerName'..."
Try {
    Rename-Computer -NewName $NewComputerName -Force -ErrorAction Stop
    Write-Host "Nom de l'ordinateur modifié avec succès en '$NewComputerName'."
} Catch {
    Write-Host "Échec de la modification du nom de l'ordinateur : $_"
}

# Étape 3 : Rejoindre le groupe de travail
Write-Host "Ajout de l'ordinateur au groupe de travail '$WorkgroupName'..."
Try {
    Remove-Computer -WorkgroupName $WorkgroupName -LocalCredential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $LocalAdminUser, $SecPassword) -Force -Restart
    Write-Host "Ordinateur ajouté au groupe de travail '$WorkgroupName'."
} Catch {
    Write-Host "Échec de l'ajout au groupe de travail : $_"
}

