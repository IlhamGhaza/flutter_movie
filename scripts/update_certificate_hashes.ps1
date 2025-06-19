<#
.SYNOPSIS
    Updates the SSL certificate hashes for the Flutter Movie app.
.DESCRIPTION
    This script fetches the current SSL certificate hashes from api.themoviedb.org
    and updates the certificate_pinner.dart file with the new hashes.
.EXAMPLE
    .\update_certificate_hashes.ps1
#>

# Configuration
$domain = "api.themoviedb.org"
$port = 443
$certPinnerPath = "..\lib\core\ssl\certificate_pinner.dart"

Write-Host "🔍 Fetching SSL certificate for $domain..." -ForegroundColor Cyan

try {
    # Create a TCP client to connect to the server
    $tcpClient = New-Object System.Net.Sockets.TcpClient($domain, $port)
    $tcpStream = $tcpClient.GetStream()
    
    # Create an SSL stream
    $sslStream = New-Object System.Net.Security.SslStream($tcpStream, $false, 
        { param($sender, $cert, $chain, $errors) $true })
    
    # Authenticate the server
    $sslStream.AuthenticateAsClient($domain)
    
    # Get the server certificate
    $serverCert = $sslStream.RemoteCertificate
    
    if ($null -eq $serverCert) {
        throw "Failed to retrieve server certificate"
    }
    
    # Convert the certificate to X509Certificate2 for better handling
    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($serverCert)
    
    # Get the SHA-256 fingerprint
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    $hash = $sha256.ComputeHash($cert.RawData)
    $fingerprint = ($hash | ForEach-Object { $_.ToString("X2") }) -join ":"
    
    Write-Host "✅ Successfully retrieved certificate:" -ForegroundColor Green
    Write-Host "   Subject: $($cert.Subject)" -ForegroundColor Green
    Write-Host "   Issuer: $($cert.Issuer)" -ForegroundColor Green
    Write-Host "   Valid From: $($cert.NotBefore)" -ForegroundColor Green
    Write-Host "   Valid To: $($cert.NotAfter)" -ForegroundColor Green
    Write-Host "   SHA-256 Fingerprint: $fingerprint" -ForegroundColor Green
    
    # Read the current certificate_pinner.dart file
    $certPinnerContent = Get-Content -Path $certPinnerPath -Raw
    
    # Update the pinned hashes
    $newContent = $certPinnerContent -replace 
        "'BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB'",
        "'$fingerprint'  // Updated $(Get-Date -Format 'yyyy-MM-dd')"
    
    # Write the updated content back to the file
    Set-Content -Path $certPinnerPath -Value $newContent -NoNewline
    
    Write-Host "\n✅ Successfully updated $certPinnerPath with the new certificate hash" -ForegroundColor Green
    
} catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
} finally {
    # Clean up
    if ($null -ne $sslStream) { $sslStream.Dispose() }
    if ($null -ne $tcpStream) { $tcpStream.Dispose() }
    if ($null -ne $tcpClient) { $tcpClient.Dispose() }
}

Write-Host "\n🔍 Verifying the updated file..." -ForegroundColor Cyan

# Display the updated lines from the certificate_pinner.dart file
try {
    $updatedContent = Get-Content -Path $certPinnerPath | Select-String -Pattern "pinnedHashes" -Context 0,5
    Write-Host "\nUpdated pinnedHashes in certificate_pinner.dart:" -ForegroundColor Green
    $updatedContent
} catch {
    Write-Host "❌ Error reading updated file: $_" -ForegroundColor Red
}
