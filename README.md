# Issuing CA Configuration Script

![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)

This PowerShell script automates the post-installation configuration of an Active Directory Issuing Certificate Authority (Subordinate CA). It streamlines the process of setting up critical CA parameters, ensuring best practices for Certificate Revocation Lists (CDP) and Authority Information Access (AIA) locations.

**Author:** Ing. Akif Calhan  
**Year:** 2025  
**License:** GNU General Public License v3.0 (GPLv3)

---

## 🚀 Features

This script automates the following configurations using `certutil`:

* **CDP & AIA Configuration:** Sets the HTTP distribution points for Certificate Revocation Lists (CRL) and CA certificates.
* **CRL Intervals:** Configures overlap and publishing periods for Base CRLs (1 week) and Delta CRLs (12 hours).
* **Auditing:** Enables full auditing events for the Certification Authority.
* **Validity Period:** Sets the maximum validity period for issued certificates to 10 years.
* **Security:** Enables Discrete Signature Algorithm (PKCS #1 V2.1).
* **Subject Alternative Name (SAN):** Enables SAN support for FQDNs (Computers) and E-Mails (Users) in certificate requests.
* **Service Management:** Automatically restarts the `CertSvc`, recreates the virtual root, and publishes the initial CRL.

---

## 📋 Prerequisites

Before running this script, ensure you have:
1.  A Windows Server with the **Active Directory Certificate Services (AD CS)** role installed and configured as an Issuing CA.
2.  Administrative privileges (Run PowerShell as Administrator).
3.  A prepared Web Server (IIS or similar) to host the CDP/AIA files.

---

## 💻 Usage

The script is currently formatted as a continuous command (one-liner) using backticks (`` ` ``). You can run it directly in an elevated PowerShell console.

1.  Run the script.
2.  When prompted, enter your **CRL Point** (e.g., `http://pki.yourdomain.local/certdata`).
3.  When prompted, enter your **AD Naming Context** (e.g., `DC=yourdomain,DC=local`).
4.  Verify the inputs and press any key to proceed. The script will apply the settings, restart the CA service, and publish the CRL.

---

## ⚠️ Disclaimer

This program is distributed in the hope that it will be useful, but **WITHOUT ANY WARRANTY**; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the [GNU General Public License](http://www.gnu.org/licenses) for more details.
