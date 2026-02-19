
<#  ISSUING CA Configuration
#####################################################
(c) GPLv3 by Ing. Akif Calhan 2025.07.21
CA configuration script in Powershell version
In Addition to C:\Windows\CAPolicy.inf
The naming context applies to the individual organizations Active Directory
$myADnamingcontext="DC=DOMAIN,DC=LOCAL"#>; `
write-output "" ; `
write-output "Description: ca config for issuing ca" ; `
write-output "Copyright (C) 2025  Ing. Akif Calhan" ; `
write-output "" ; `
write-output "This program is free software; you can redistribute it and/or modify it" ; `
write-output "under the terms of the GNU General Public License as published by the" ; `
write-output "Free Software Foundation; either version 3 of the write-output License, or (at" ; `
write-output "your option) any later version." ; `
write-output "" ; `
write-output "This program is distributed in the hope that it will be useful, but" ; `
write-output "WITHOUT ANY WARRANTY; without even the implied warranty of" ; `
write-output "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU write-output" ; `
write-output "General Public License for more details." ; `
write-output "" ; `
write-output "You should have received a copy of the GNU General Public License along" ; `
write-output "with this program; if not, see http://www.gnu.org/licenses" ; `
write-output "" ; `
write-output "" ; `
write-output "Hostname:" ; `
hostname ; `
write-output "" ; `
write-output "" ; `
<# This variable directs to the HTTP publication location that is used for the CRL and AIA publication #> ; `
write-output "Enter CRL point        syntax: http://<DNS NAME in fqdn>/certdata" ; `
$myhttpPKIvroot=Read-Host ; `
write-output "" ; `
write-output "Enter ADnamingcontext  syntax: DC=DOMAIN,DC=LOCAL" ; `
$myADnamingcontext=Read-Host ; `
write-output "" ; `
write-output "" ; `
write-output "this is the cdp point:        $myhttpPKIvroot" ; `
write-output "this is the ADnamingcontext:  $myADnamingcontext" ; `
write-output "" ; `
write-output "" ; `
Read-Host -Prompt "Press any key to continue or CTRL+C to quit" | Out-Null ; `
write-output "wait 10s" ; `
Start-Sleep -Seconds 10 ; `
<# config in powershell certutil will be outdated in future version ; `
# this is a prepare config; `
# ; `
# view caname in registry #>; `
$caRegPath = "HKLM:\SYSTEM\CurrentControlSet\Services\CertSvc\Configuration" ; `
$caName = Get-ChildItem -Path $caRegPath | Select-Object -ExpandProperty PSChildName ; `
$fullRegPath = "$caRegPath\$caName" ; `
Write-Output "Issuing CA Name: $caName" ; `
<# Set registry values for CRL and CA configuration#> ; `
<# Configuration Naming Context #> ; `
certutil -setreg CA\DSConfigDN "CN=Configuration,$myADnamingcontext"; `
<# CDP and deltaCDP Extension URLs #> ; `
certutil -setreg CA\CRLPeriod "weeks"; `
certutil -setreg CA\CRLPeriodUnits 1; `
certutil -setreg CA\CRLOverlapPeriod "days"; `
certutil -setreg CA\CRLOverlapUnits 3; `
certutil -setreg CA\CRLDeltaPeriod "hours"; `
certutil -setreg CA\CRLDeltaPeriodUnits 12; `
certutil -setreg CA\CRLDeltaOverlapPeriod "hours"; `
certutil -setreg CA\CRLDeltaOverlapUnits 4; `
<# CDP and deltaCDP Extension URLs #> ; `
certutil -setreg CA\CRLPublicationURLs "65:$env:WinDir\System32\CertSrv\CertEnroll\%3%8%9.crl\n6:$myhttpPKIvroot/%3%8%9.crl"; `
<# AIA Extension URLs #> ; `
certutil -setreg CA\CACertPublicationURLs "1:$env:WinDir\System32\CertSrv\CertEnroll\%1_%3%4.crt\n2:$myhttpPKIvroot/%1_%3%4.crt"; `
<# Auditing - enable all auditing events for the CA #> ; `
certutil -setreg CA\AuditFilter 127; `
<# Set the validity period for issued certificates #> ; `
certutil -setreg CA\ValidityPeriod "years"; `
certutil -setreg CA\ValidityPeriodUnits 10; `
<# enable Discrete Signature Algorithm (PKCS #1 V2.1) #> ; `
certutil -setreg CA\CSP\DiscreteSignatureAlgorithm 1; `
<# Enable SubjectAltName - FQDN for Computers, E-Mail for Users #> ; `
certutil -setreg Policy\SubjectAltName ENABLED; `
certutil -setreg Policy\SubjectAltName2 ENABLED; `
<# Restart Certificate Services#>; `
Restart-Service -Name "CertSvc"; `
<# Correcting acl & share - if CertEnroll vDir created remove the vdir from IIS!#>; `
certutil -vroot ; `
Start-Sleep -Seconds 5 ; `
<# Publish CRL !#>; `
certutil -crl ; `
Write-Output "CRL published in $env:WinDir\System32\CertSrv\CertEnroll"
