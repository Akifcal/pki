# AD CS PKI Configuration Scripts
![PowerShell](https://img.shields.io/badge/PowerShell-%235391FE.svg?style=for-the-badge&logo=powershell&logoColor=white)
![Windows Server](https://img.shields.io/badge/Windows%20Server-%230078D6.svg?style=for-the-badge&logo=microsoft-wardrobe&logoColor=white)
![Security](https://img.shields.io/badge/Security-Hardening-red?style=for-the-badge)

![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)


This repository contains PowerShell scripts (one-liners) to automate the post-installation configuration of a Microsoft 2-Tier PKI hierarchy. It includes configurations for both an **Offline Root CA** and an **Enterprise Issuing CA**.

**Author:** Ing. Akif Calhan  
**Year:** 2025  
**License:** GNU General Public License v3.0 (GPLv3)

---

## 🛡️ Security & Hardening (Modern Best Practices)

These scripts are written with modern Active Directory Certificate Services (AD CS) security standards in mind, mitigating common misconfigurations and attack vectors. The Issuing CA script **actively enforces** the secure state instead of relying on defaults, so it also remediates existing CAs with legacy settings.

* **Mitigation of ESC6 (Certified Pre-Owned):** Explicitly removes the dangerous `EDITF_ATTRIBUTESUBJECTALTNAME2` flag. This prevents unprivileged users from arbitrarily specifying Subject Alternative Names (SANs) in their Certificate Signing Requests (CSRs). SANs must be securely built from Active Directory attributes via Certificate Templates.
* **Mitigation of ESC16:** Ensures the SID security extension (`1.3.6.1.4.1.311.25.2`, KB5014754) is not listed in `DisableExtensionList`, so every issued certificate supports strong certificate mapping on Domain Controllers.
* **Mitigation of ESC11:** Enforces `IF_ENFORCEENCRYPTICERTREQUEST`, so the CA only accepts encrypted RPC (MS-ICPR) requests. This blocks NTLM relay attacks against the CA's RPC interface.
* **Audit Trail Readiness:** Sets `AuditFilter 127` and enables the OS audit subcategory *Certification Services* (success and failure) via `auditpol` using its language-independent GUID. Note: a domain GPO with Advanced Audit Policy may override the local setting — include the subcategory there as well.
* **Cryptographic Strength:** Enables the Discrete Signature Algorithm (PKCS #1 V2.1) for secure PSS padding. Note: some legacy appliances, network devices and older Java stacks cannot validate RSASSA-PSS signatures — verify compatibility before deployment.
* **Root CA Isolation:** Completely disables Delta CRL publication on the Root CA, adhering to the strict offline nature of a Root CA.
* **Verification Output:** At the end of the run, the Issuing CA script prints the relevant registry values and audit policy so the hardened state can be verified at a glance.

> **Out of scope:** Template- and ACL-related findings (ESC1–ESC5, ESC7, ESC9/10, ESC13–15) and HTTP enrollment relay (ESC8) are not addressed by these scripts. Assess them with tools such as [Certipy](https://github.com/ly4k/Certipy) or [Locksmith](https://github.com/jakehildreth/Locksmith).

---

## 📂 Included Scripts

1. **Root CA Configuration:** For the offline standalone root server.
2. **Issuing CA Configuration:** For the domain-joined subordinate server.

---

## 🚀 Features & Configuration Details

### 1. Root CA Script

Designed for a Standalone Offline Root CA.

* **CRL Validity:** Sets Base CRL to **1 Year** (12 Months) with a 42-day overlap.
* **Delta CRL:** **Disabled** (Best practice).
* **Validity Period:** Sets issued certificate validity to **10 Years**.
* **CDP/AIA:** Configures clean HTTP paths (removes LDAP/File/etc. default noise).

### 2. Issuing CA Script

Designed for an Enterprise Subordinate CA (Domain Joined).

* **CRL Validity:** Sets Base CRL to **1 Week**.
* **Delta CRL:** Enabled and set to **12 Hours**.
* **Validity Period:** Sets absolute maximum issued certificate validity to **10 Years**.
* **AD Integration:** Configures the `Configuration Naming Context` in Active Directory.
* **Hardening:** Enforces ESC6/ESC11/ESC16 mitigations and enables CA audit logging.
* **Verification:** Prints the resulting hardening state after the service restart.

---

## 💻 Usage

These scripts are formatted as PowerShell one-liners using backticks for easy copy-pasting. Run them in an elevated PowerShell window.

### For the Root CA

1. Run the Root CA script on your offline server.
2. **Input:** Enter the CRL distribution point URL (e.g., `http://pki.yourdomain.com/certdata`).
3. The script will configure the registry, disable Delta CRLs, and restart the service.

### For the Issuing CA

1. Run the Issuing CA script on your domain-joined server.
2. **Input 1:** Enter the CRL distribution point URL.
3. **Input 2:** Enter the AD Naming Context (e.g., `DC=company,DC=local`).
4. The script will configure the registry, set AD contexts, apply the hardening settings, restart the CA service, publish the initial CRL and print the verification output.

---

## ⚠️ Disclaimer

This program is distributed in the hope that it will be useful, but **WITHOUT ANY WARRANTY**; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the [GNU General Public License](http://www.gnu.org/licenses) for more details.
