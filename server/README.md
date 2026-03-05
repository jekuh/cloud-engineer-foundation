
system.mbonteh.com: : system engineer foundation playbook for linux and windows server management using bash, powershell, ansible, terraform, and kubernetes:

MBP --> linux and windows server management using bash, powershell, ansible, terraform, and kubernetes.

00: MPB Control Node
- Access 01 and 02 via ssh and rdp respectively
- Setup ssh on 02
- manage 01 and 02 using ansible from MPB Control Node


01: linux server
- instance type: t3.micro
- ami: Amazon Linux 2 AMI (HVM), SSD Volume Type


02: windows server
- instance type: t3.micro
- Microsoft Windows Server 2022 Core Base - ami-0e3af9e89c78d4b08

connect via RDP using the following credentials:

Public DNS: ec2-18-185-114-74.eu-central-1.compute.amazonaws.com
Public IP: 18.185.114.74
Username: Administrator 
Password: 5y$5=yUZc63kK4ko2E%Gz?X$3SOg40I3

setup ssh on windows server using the following steps:
1. Open PowerShell as Administrator
2. Install the OpenSSH Server feature:
   ```powershell
   Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.
3. Start the sshd service and set it to start automatically:
   ```powershell
   Start-Service sshd
   Set-Service -Name sshd -StartupType 'Automatic'
4. Allow ssh traffic through the firewall:
   ```powershell
   New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Group 'System Engineer Foundation' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
5. Verify that the sshd service is running:
   ```powershell
   Get-Service sshd
6. You can now connect to the Windows server using ssh from the MPB Control Node or any other machine with ssh client installed using the following command:
   ```bash
   ssh Administrator@<Public IP or Public DNS>
   





