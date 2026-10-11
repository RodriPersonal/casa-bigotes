$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$bad = @("Ã", "Â", "â", "REEMPLAZAR", "example.com", "TODO")
$html = Get-ChildItem -Path $root -Recurse -Filter *.html | Where-Object { $_.Name -ne "404.html" }
$fail = @()
foreach ($file in $html) {
  $text = Get-Content -Raw -Encoding UTF8 $file.FullName
  foreach ($token in $bad) { if ($text.Contains($token)) { $fail += "$($file.Name): token $token" } }
  if ($text -notmatch '<html lang="es">') { $fail += "$($file.Name): missing lang" }
  if ($text -notmatch '<title>[^<]+</title>') { $fail += "$($file.Name): missing title" }
  if ($text -notmatch 'name="description"') { $fail += "$($file.Name): missing description" }
  if ($text -notmatch 'rel="canonical"') { $fail += "$($file.Name): missing canonical" }
  $matches = [regex]::Matches($text, 'href="([^"]+)"')
  foreach ($m in $matches) {
    $href = $m.Groups[1].Value.Split('#')[0].Split('?')[0]
    if ($href -and $href -notmatch '^(https?:|mailto:|#|/)') {
      $target = Join-Path $file.DirectoryName $href
      if (-not (Test-Path $target)) { $fail += "$($file.Name): broken $href" }
    }
  }
}
$sitemap = Get-Content -Raw -Encoding UTF8 (Join-Path $root "sitemap.xml")
foreach ($file in $html) { if ($file.Name -ne "index.html" -and $sitemap -notmatch [regex]::Escape($file.Name)) { $fail += "sitemap missing $($file.Name)" } }
$amazon = Get-ChildItem -Path $root -Recurse -Filter *.html | ForEach-Object { Select-String -Path $_.FullName -Pattern 'amazon\.' -SimpleMatch }
foreach ($hit in $amazon) { if ($hit.Line -match 'href="https?://[^" ]*amazon\.' -and $hit.Line -notmatch 'nodeId=201909010' -and $hit.Line -notmatch 'rel="[^"]*sponsored') { $fail += "$($hit.Path): Amazon link missing sponsored rel" } }
if ($fail.Count) { $fail | ForEach-Object { "FAIL $_" }; exit 1 } else { "PASS: $($html.Count) HTML pages, internal links, sitemap, SEO fields, UTF-8 and Amazon rel checks" }
