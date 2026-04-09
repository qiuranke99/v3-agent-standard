# Security Checklist

## Input / Output
- [ ] All user input validated at system boundaries
- [ ] Output encoded to prevent XSS
- [ ] SQL queries parameterized (no string concatenation)
- [ ] File uploads have type and size limits
- [ ] External data sources treated as untrusted

## Authentication & Authorization
- [ ] Auth logic uses mature library (not hand-rolled)
- [ ] All protected routes/endpoints have auth checks
- [ ] Permission checks are server-side (not client-only)
- [ ] Session/Token has expiration mechanism

## Secrets
- [ ] No hardcoded secrets/passwords/API keys
- [ ] .env is in .gitignore
- [ ] Logs don't output sensitive data
- [ ] Error messages don't expose internal implementation

## Dependencies
- [ ] No known vulnerabilities (npm audit / pip audit)
- [ ] Dependencies from trusted sources
- [ ] Dependency versions locked
- [ ] License compatibility verified
