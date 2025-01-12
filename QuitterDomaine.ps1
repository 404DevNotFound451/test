# Variables pour l'utilisateur local
$LocalAdminUser = "p888"
$LocalAdminPassword = "123456"

# Convertir le mot de passe en chaîne sécurisée
$SecPassword = ConvertTo-SecureString $LocalAdminPassword -AsPlainText -Force

# Création de l'utilisateur local
Write-Host "Création ou mise à jour de l'utilisateur '$LocalAdminUser'..."
Try {
    # Tenter de créer l'utilisateur
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

