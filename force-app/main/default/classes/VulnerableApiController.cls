/**
 * Intentionally Vulnerable Apex/Salesforce Application
 * DO NOT USE IN PRODUCTION - FOR SECURITY TESTING ONLY
 */

// VULNERABILITY: Hardcoded Secrets (CWE-798)
@RestResource(urlMapping='/vulnerable/*')
global class VulnerableApiController {

    private static final String JWT_SECRET = 'super_secret_jwt_key_12345';
    private static final String ADMIN_PASSWORD = 'admin123';
    private static final String DB_PASSWORD = 'password123';
    private static final String API_KEY = 'AKIA_FAKE_APEX_KEY_FOR_TESTING_ONLY';
    private static final String AWS_SECRET_KEY = 'fake_aws_secret_key_12345678901234567890';

    /**
     * VULNERABILITY 1: SOQL Injection (CWE-89)
     * Home page with vulnerability list
     */
    @HttpGet
    global static void handleGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String action = req.params.get('action');

        if (action == 'search') {
            handleSearch();
        } else if (action == 'user') {
            handleGetUser();
        } else if (action == 'debug') {
            handleDebug();
        } else if (action == 'exec') {
            handleExec();
        } else if (action == 'file') {
            handleReadFile();
        } else {
            res.statusCode = 200;
            res.addHeader('Content-Type', 'text/html');
            res.responseBody = Blob.valueOf(
                '<html>' +
                '<head><title>Vulnerable Apex App</title></head>' +
                '<body>' +
                '<h1>Intentionally Vulnerable Apex/Salesforce Application</h1>' +
                '<p>This application contains numerous security vulnerabilities for testing purposes.</p>' +
                '<h2>Available Endpoints:</h2>' +
                '<ul>' +
                '<li>GET /services/apexrest/vulnerable?action=search&query=test - SOQL Injection</li>' +
                '<li>GET /services/apexrest/vulnerable?action=exec&cmd=ls - Command Injection (via Process Builder)</li>' +
                '<li>GET /services/apexrest/vulnerable?action=file&filename=test.txt - Path Traversal</li>' +
                '<li>POST /services/apexrest/vulnerable?action=login - Authentication</li>' +
                '<li>GET /services/apexrest/vulnerable?action=user&id=123 - IDOR</li>' +
                '<li>DELETE /services/apexrest/vulnerable?action=delete&id=123 - Missing Auth</li>' +
                '<li>GET /services/apexrest/vulnerable?action=debug - Sensitive Data Exposure</li>' +
                '</ul>' +
                '</body>' +
                '</html>'
            );
        }
    }

    /**
     * VULNERABILITY 2: SOQL Injection (CWE-89)
     * Concatenating user input directly into SOQL query
     */
    private static void handleSearch() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String searchQuery = req.params.get('query');

        // Vulnerable: String concatenation in SOQL query
        String query = 'SELECT Id, Name, Email FROM Contact WHERE Name LIKE \'%' + searchQuery + '%\'';

        try {
            List<Contact> contacts = Database.query(query);

            res.statusCode = 200;
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(
                '{"query": "' + query + '", "vulnerable": true, "count": ' + contacts.size() + '}'
            );
        } catch (Exception e) {
            res.statusCode = 500;
            res.responseBody = Blob.valueOf('{"error": "' + e.getMessage() + '"}');
        }
    }

    /**
     * VULNERABILITY 3: Insecure Direct Object Reference (IDOR) (CWE-639)
     * No authorization check before accessing user data
     */
    private static void handleGetUser() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String userId = req.params.get('id');

        // Vulnerable: No authorization check
        try {
            User u = [SELECT Id, Username, Email FROM User WHERE Id = :userId LIMIT 1];

            res.statusCode = 200;
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(
                '{"id": "' + u.Id + '", "username": "' + u.Username + '", "email": "' + u.Email + '"}'
            );
        } catch (Exception e) {
            res.statusCode = 500;
            res.responseBody = Blob.valueOf('{"error": "' + e.getMessage() + '"}');
        }
    }

    /**
     * VULNERABILITY 4: Sensitive Data Exposure (CWE-200)
     * Exposes hardcoded secrets and system information
     */
    private static void handleDebug() {
        RestResponse res = RestContext.response;

        res.statusCode = 200;
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(
            '{' +
            '"jwt_secret": "' + JWT_SECRET + '",' +
            '"admin_password": "' + ADMIN_PASSWORD + '",' +
            '"db_password": "' + DB_PASSWORD + '",' +
            '"api_key": "' + API_KEY + '",' +
            '"aws_secret_key": "' + AWS_SECRET_KEY + '"' +
            '}'
        );
    }

    /**
     * VULNERABILITY 5: Command Injection via Process Builder (CWE-78)
     * Simulated - Apex cannot execute shell commands directly
     */
    private static void handleExec() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String cmd = req.params.get('cmd');

        // Vulnerable pattern: Command injection risk in integrations
        res.statusCode = 200;
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(
            '{"message": "Command execution pattern (vulnerable)", "cmd": "' + cmd + '"}'
        );
    }

    /**
     * VULNERABILITY 6: Path Traversal (CWE-22)
     * Simulated - Apex has limited file system access
     */
    private static void handleReadFile() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String filename = req.params.get('filename');

        // Vulnerable: No sanitization of file path
        String path = '/uploads/' + filename;

        res.statusCode = 200;
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(
            '{"message": "Path traversal pattern (vulnerable)", "path": "' + path + '"}'
        );
    }

    /**
     * VULNERABILITY 7: Missing Authentication (CWE-306)
     * POST endpoint to handle various operations
     */
    @HttpPost
    global static void handlePost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String action = req.params.get('action');

        if (action == 'login') {
            handleLogin();
        } else if (action == 'register') {
            handleRegister();
        } else if (action == 'eval') {
            handleEval();
        } else {
            res.statusCode = 404;
            res.responseBody = Blob.valueOf('{"error": "Not found"}');
        }
    }

    /**
     * VULNERABILITY 8: Hardcoded Credentials (CWE-798)
     * Authentication with hardcoded password
     */
    private static void handleLogin() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String bodyStr = req.requestBody.toString();
        Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(bodyStr);

        String username = (String) body.get('username');
        String password = (String) body.get('password');

        // Vulnerable: Hardcoded admin password
        Boolean success = (password == ADMIN_PASSWORD);

        res.statusCode = 200;
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(
            '{"success": ' + success + ', "role": "' + (success ? 'admin' : '') + '"}'
        );
    }

    /**
     * VULNERABILITY 9: Mass Assignment (CWE-915)
     * Allows setting privileged fields
     */
    private static void handleRegister() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String bodyStr = req.requestBody.toString();
        Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(bodyStr);

        // Vulnerable: Allows setting 'IsActive' and other privileged fields
        Contact newContact = new Contact();
        newContact.FirstName = (String) body.get('firstName');
        newContact.LastName = (String) body.get('lastName');
        newContact.Email = (String) body.get('email');

        // Attacker can set restricted fields
        if (body.containsKey('isActive')) {
            // In real Salesforce, this would be a privileged field
            newContact.Description = 'IsActive: ' + body.get('isActive');
        }

        insert newContact;

        res.statusCode = 200;
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf('{"success": true, "id": "' + newContact.Id + '"}');
    }

    /**
     * VULNERABILITY 10: Code Injection (CWE-94)
     * Dynamic SOQL/SOSL evaluation
     */
    private static void handleEval() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String bodyStr = req.requestBody.toString();
        Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(bodyStr);

        String code = (String) body.get('code');

        // Vulnerable: Dynamic SOQL execution pattern
        res.statusCode = 200;
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(
            '{"message": "Code evaluation pattern (vulnerable)", "input": "' + code + '"}'
        );
    }

    /**
     * VULNERABILITY 11: Missing Authorization (CWE-306)
     * DELETE endpoint without authentication
     */
    @HttpDelete
    global static void handleDelete() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String action = req.params.get('action');

        if (action == 'delete') {
            String recordId = req.params.get('id');

            // Vulnerable: No authentication or authorization check
            try {
                Contact c = [SELECT Id FROM Contact WHERE Id = :recordId LIMIT 1];
                delete c;

                res.statusCode = 200;
                res.addHeader('Content-Type', 'application/json');
                res.responseBody = Blob.valueOf('{"success": true, "deleted": "' + recordId + '"}');
            } catch (Exception e) {
                res.statusCode = 500;
                res.responseBody = Blob.valueOf('{"error": "' + e.getMessage() + '"}');
            }
        }
    }

    /**
     * VULNERABILITY 12: Information Exposure Through Error Messages (CWE-209)
     */
    public static String getDatabasePassword() {
        // Vulnerable: Returns sensitive information
        return DB_PASSWORD;
    }

    /**
     * VULNERABILITY 13: Insufficient Logging (CWE-778)
     */
    public static void processPayment(Decimal amount) {
        // Vulnerable: No audit trail for payment operations
        // Payment processed without logging
    }

    /**
     * VULNERABILITY 14: Weak Cryptography (CWE-327)
     */
    public static String hashPassword(String password) {
        // Vulnerable: Using weak hashing (MD5 simulation)
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(password));
        return EncodingUtil.convertToHex(hash);
    }

    /**
     * VULNERABILITY 15: Insecure Random (CWE-330)
     */
    public static String generateToken() {
        // Vulnerable: Predictable token generation
        Integer token = Math.mod(DateTime.now().getTime().intValue(), 999999999);
        return String.valueOf(token);
    }

    /**
     * VULNERABILITY 16: FLS/CRUD Bypass (Salesforce-specific)
     * No field-level security check
     */
    public static void updateSensitiveField(Id recordId, String value) {
        // Vulnerable: No FLS check before update
        Contact c = [SELECT Id FROM Contact WHERE Id = :recordId];
        c.Description = value;
        update c;
    }

    /**
     * VULNERABILITY 17: Sharing Rules Bypass (Salesforce-specific)
     * Using 'without sharing' implicitly
     */
    public static List<Contact> getAllContacts() {
        // Vulnerable: No sharing rules enforcement
        return [SELECT Id, Name, Email FROM Contact];
    }

    /**
     * VULNERABILITY 18: Open Redirect (CWE-601)
     */
    @HttpPatch
    global static void handlePatch() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String url = req.params.get('redirect_url');

        // Vulnerable: No validation of redirect URL
        res.statusCode = 302;
        res.addHeader('Location', url);
        res.responseBody = Blob.valueOf('Redirecting to: ' + url);
    }

    /**
     * Additional vulnerable helper methods
     */

    // VULNERABILITY: SOSL Injection
    public static List<List<SObject>> searchRecords(String searchTerm) {
        // Vulnerable: String concatenation in SOSL
        String soslQuery = 'FIND {' + searchTerm + '} IN ALL FIELDS RETURNING Contact(Name)';
        return Search.query(soslQuery);
    }

    // VULNERABILITY: DML without error handling
    public static void bulkInsert(List<Contact> contacts) {
        // Vulnerable: No error handling, will fail entirely if one record fails
        insert contacts;
    }

    // VULNERABILITY: Governor limit ignorance
    public static void inefficientQuery() {
        // Vulnerable: SOQL in loop
        List<Account> accounts = [SELECT Id FROM Account];
        for (Account acc : accounts) {
            List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
        }
    }
}
