\
    # Reference password policy adjustment (sample)
    # NOTE: Review before use in production.
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) `
      -replace 'MinimumPasswordLength\s*=\s*\d+', 'MinimumPasswordLength = 14' `
      -replace 'PasswordComplexity\s*=\s*\d+', 'PasswordComplexity = 1' `
      | Set-Content C:\secpol.cfg
    secedit /configure /db secedit.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
