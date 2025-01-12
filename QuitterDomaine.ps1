# Variables
$LocalAdminUser = "p1"           # Nom du compte local
$LocalAdminPassword = ""         # Pas de mot de passe
$WorkgroupName = "LGPI"          # Groupe de travail après sortie du domaine
$ComputerName = "poste1"         # Nom du poste local

# Création ou mise à jour du compte local
Write-Host "Création ou mise à jour du compte local '$LocalAdminUser'..."
$SecPassword = ConvertTo-SecureString $LocalAdminPassword -AsPlainText -Force
Try {
    # Tente de créer l'utilisateur local
    New-LocalUser -Name $LocalAdminUser -Password $SecPassword -FullName "Administrateur local" -ErrorAction Stop
    Write-Host "Compte local '$LocalAdminUser' créé avec succès."
} Catch {
    Write-Host "Le compte '$LocalAdminUser' existe déjà ou une erreur est survenue."
}

# Ajout du compte local au groupe Administrateurs
Write-Host "Ajout de '$LocalAdminUser' au groupe 'Administrateurs'..."
Add-LocalGroupMember -Group "Administrateurs" -Member $LocalAdminUser -ErrorAction SilentlyContinue

# Quitter le domaine et rejoindre le groupe de travail
Write-Host "Sortie du domaine pour l'ordinateur '$ComputerName'..."
Try {
    Remove-Computer -WorkgroupName $WorkgroupName -LocalCredential $LocalAdminUser -Force -Restart
    Write-Host "L'ordinateur '$ComputerName' quittera le domaine et redémarrera dans le groupe de travail '$WorkgroupName'."
} Catch {
    Write-Host "Échec de la sortie du domaine : $_"
}
