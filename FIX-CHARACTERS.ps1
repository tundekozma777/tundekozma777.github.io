$ErrorActionPreference = 'Stop'
try {
  $root = (Get-Location).Path
  $files = @(Get-ChildItem -Path (Join-Path $root 'jobs') -Filter 'extra-*.html' -File)
  if ($files.Count -ne 249) { throw "Expected 249 new job pages, found $($files.Count). No changes made." }
  $utf8 = New-Object System.Text.UTF8Encoding($false)
  $cp1252 = [System.Text.Encoding]::GetEncoding(1252)
  $codes = @(0x2726,0x2197,0x2190,0x00A9)
  $pairs = @()
  foreach ($code in $codes) {
    $good = [string][char]$code
    $bad = $cp1252.GetString([System.Text.Encoding]::UTF8.GetBytes($good))
    $pairs += [pscustomobject]@{ Bad=$bad; Good=$good }
  }
  $changed = 0
  foreach ($f in $files) {
    $original = [System.IO.File]::ReadAllText($f.FullName,[System.Text.Encoding]::UTF8)
    $fixed = $original
    foreach ($p in $pairs) { $fixed = $fixed.Replace($p.Bad,$p.Good) }
    if ($fixed -ne $original) {
      [System.IO.File]::WriteAllText($f.FullName,$fixed,$utf8)
      $changed++
    }
  }
  Write-Host "SUCCESS: Fixed special characters in $changed pages (of 249)." -ForegroundColor Green
  Write-Host 'No files were uploaded. Check a job page in your browser.'
} catch { Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red }
Read-Host 'Press Enter to close'
