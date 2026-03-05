<powershell>


# Install OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start and enable sshd
Start-Service sshd
Set-Service -Name sshd -StartupType Automatic

# Allow SSH in Windows Firewall
if (-not (Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue)) {
  New-NetFirewallRule -Name "OpenSSH-Server-In-TCP" `
    -DisplayName "OpenSSH Server (sshd)" -Enabled True -Direction Inbound `
    -Protocol TCP -Action Allow -LocalPort 22
}

# Put your public key for Administrator
New-Item -ItemType Directory -Path C:\ProgramData\ssh -Force | Out-Null
$authKeys = "C:\ProgramData\ssh\administrators_authorized_keys"
New-Item -ItemType File -Path $authKeys -Force | Out-Null

# Replace the line below with your public key (ssh-rsa/ed25519 ...)
$pubKey = "${admin_pubkey}"
Set-Content -Path $authKeys -Value $pubKey -Encoding ascii

# Fix permissions required by OpenSSH
icacls $authKeys /inheritance:r | Out-Null
icacls $authKeys /grant Administrators:F | Out-Null
icacls $authKeys /grant SYSTEM:F | Out-Null

Restart-Service sshd
</powershell>