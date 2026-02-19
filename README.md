# AD CS PKI Configuration Scripts

![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)

This repository contains PowerShell scripts (one-liners) to automate the post-installation configuration of a Microsoft 2-Tier PKI hierarchy. It includes configurations for both an **Offline Root CA** and an **Enterprise Issuing CA**.

**Author:** Ing. Akif Calhan  
**Year:** 2025  
**License:** GNU General Public License v3.0 (GPLv3)

---

## 📂 Included Scripts

1.  **Root CA Configuration:** For the offline standalone root server.
2.  **Issuing CA Configuration:** For the domain-joined subordinate server.

---

## 🚀 Features & Configuration Details

### 1. Root CA Script
Designed for a Standalone Offline Root CA.
* **CRL Validity:** Sets Base CRL to **1 Year** (12 Months) with 42 days overlap.
* **Delta CRL:** **Disabled** (Best practice for offline Root CAs).
* **Validity Period:** Sets issued certificate validity to **10 Years**.
* **CDP/AIA:** Configures HTTP paths (removes LDAP/File/etc. default noise).

### 2. Issuing CA Script
Designed for an Enterprise Subordinate CA (Domain Joined).
* **CRL Validity:** Sets Base CRL to **1 Week**.
* **Delta CRL:** Enabled and set to **12 Hours**.
* **Validity Period:** Sets issued certificate validity to **10 Years**.
* **AD Integration:** Configures the `Configuration Naming Context` in AD.
* **Sanity Checks:** Enables Subject Alternative Name (SAN) support for FQDNs and Emails.

### Common Features (Both Scripts)
* **Auditing:** Enables full auditing (Filter 127).
* **Security:** Enables Discrete Signature Algorithm (PKCS #1 V2.1).
* **Automation:** Auto-restarts services and publishes the initial CRL.

---

## 💻 Usage

These scripts are formatted as PowerShell one-liners using backticks for easy copy-pasting. Run them in an elevated PowerShell window.

### For the Root CA
1.  Run the Root CA script on your offline server.
2.  **Input:** Enter the CRL distribution point URL (e.g., `http://pki.yourdomain.com/certdata`).
3.  The script will configure the registry, disable Delta CRLs, and restart the service.

### For the Issuing CA
1.  Run the Issuing CA script on your domain-joined server.
2.  **Input 1:** Enter the CRL distribution point URL.
3.  **Input 2:** Enter the AD Naming Context (e.g., `DC=company,DC=local`).
4.  The script will configure the registry, enable Delta CRLs, and set AD contexts.

---

## ⚠️ Disclaimer

This program is distributed in the hope that it will be useful, but **WITHOUT ANY WARRANTY**; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the [GNU General Public License](http://www.gnu.org/licenses) for more details.
