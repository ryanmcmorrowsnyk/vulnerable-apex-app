# Vulnerable Apex/Salesforce Application

**⚠️ WARNING: Intentionally vulnerable - NEVER deploy to production!**

## 🎯 Purpose

- **200+ dependency vulnerabilities** (npm packages for LWC)
- **18 code-level vulnerabilities** (OWASP Top 10 + Salesforce-specific)

## 📊 Vulnerabilities

### Dependencies (SCA)
- **40+ vulnerable npm packages** from 2018-2019
- express 4.16.4, lodash 4.17.4, axios 0.18.0, moment 2.19.3
- Expected **200+ total vulnerabilities** in npm dependencies

### Code (SAST) - 18 Vulnerabilities

1. SOQL Injection - VulnerableApiController.cls:70
2. IDOR - VulnerableApiController.cls:95
3. Sensitive Data Exposure - VulnerableApiController.cls:122
4. Command Injection Pattern - VulnerableApiController.cls:147
5. Path Traversal Pattern - VulnerableApiController.cls:167
6. Hardcoded Credentials - VulnerableApiController.cls:10-14, 217
7. Mass Assignment - VulnerableApiController.cls:243
8. Code Injection Pattern - VulnerableApiController.cls:270
9. Missing Authentication - VulnerableApiController.cls:287
10. Information Exposure - VulnerableApiController.cls:313
11. Insufficient Logging - VulnerableApiController.cls:323
12. Weak Cryptography - MD5 - VulnerableApiController.cls:330
13. Insecure Random - VulnerableApiController.cls:339
14. FLS/CRUD Bypass - VulnerableApiController.cls:348
15. Sharing Rules Bypass - VulnerableApiController.cls:359
16. Open Redirect - VulnerableApiController.cls:367
17. SOSL Injection - VulnerableApiController.cls:382
18. SOQL in Loop - VulnerableApiController.cls:395

## 🚀 Setup

### Salesforce Setup

```bash
git clone https://github.com/YOUR_USERNAME/vulnerable-apex-app.git
cd vulnerable-apex-app

# Authenticate with Salesforce org
sfdx force:auth:web:login -a MyOrg

# Deploy to org
sfdx force:source:push -u MyOrg

# Open org
sfdx force:org:open -u MyOrg
```

### npm Dependencies (for LWC)

```bash
npm install
```

Access REST API: `https://your-instance.salesforce.com/services/apexrest/vulnerable`

## 🔍 Testing

```bash
# Test npm dependencies
snyk test
# Expected: 200+ vulnerabilities

# For Apex code scanning, use Salesforce security tools
```

## 📚 Endpoints

- GET /services/apexrest/vulnerable?action=search&query=test - SOQL Injection
- GET /services/apexrest/vulnerable?action=exec&cmd=ls - Command Injection Pattern
- GET /services/apexrest/vulnerable?action=file&filename=test.txt - Path Traversal
- POST /services/apexrest/vulnerable?action=login - Authentication
- GET /services/apexrest/vulnerable?action=user&id=123 - IDOR
- DELETE /services/apexrest/vulnerable?action=delete&id=123 - Missing Auth
- GET /services/apexrest/vulnerable?action=debug - Sensitive Data Exposure

## ⚠️ Security Notice

Educational use only. DO NOT deploy to production or any Salesforce org.

MIT License - Testing purposes only.
