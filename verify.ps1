# Verificación local de Casa Bigotes. Ejecutar: powershell -ExecutionPolicy Bypass -File verify.ps1
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$base = "https://rodripersonal.github.io/casa-bigotes/"
$bad = @("Ã", "Â", "â", "REEMPLAZAR", "example.com", "TODO")
$all = Get-ChildItem -Path $root -Recurse -Filter *.html
$pages = $all | Where-Object { $_.Name -ne "404.html" }
$fail = @()
$sitemap = Get-Content -Raw -Encoding UTF8 (Join-Path $root "sitemap.xml")
$inbound = @{}
foreach ($file in $pages) {
  $rel = $file.FullName.Substring($root.Length + 1).Replace('\', '/')
  $text = Get-Content -Raw -Encoding UTF8 $file.FullName
  foreach ($token in $bad) { if ($text.Contains($token)) { $fail += "${rel}: token $token" } }
  if ($text -notmatch '<html lang="es">') { $fail += "${rel}: missing lang" }
  $t = [regex]::Match($text, '<title>([^<]+)</title>')
  if (-not $t.Success) { $fail += "${rel}: missing title" } elseif ($t.Groups[1].Value.Length -gt 60) { $fail += "${rel}: title > 60 chars ($($t.Groups[1].Value.Length))" }
  $d = [regex]::Match($text, 'name="description" content="([^"]*)"')
  if (-not $d.Success) { $fail += "${rel}: missing description" } elseif ($d.Groups[1].Value.Length -lt 100 -or $d.Groups[1].Value.Length -gt 158) { $fail += "${rel}: description length $($d.Groups[1].Value.Length)" }
  $c = [regex]::Match($text, 'rel="canonical" href="([^"]+)"')
  if (-not $c.Success) { $fail += "${rel}: missing canonical" }
  else {
    $expected = if ($rel -eq "index.html") { $base } else { $base + $rel }
    if ($c.Groups[1].Value -ne $expected) { $fail += "${rel}: canonical mismatch" }
    $locs = if ($rel -eq "index.html") { $base } else { $base + $rel }
    if ($sitemap -notmatch [regex]::Escape("<loc>$locs</loc>")) { $fail += "${rel}: not in sitemap" }
  }
  if ($text -notmatch 'property="og:image"') { $fail += "${rel}: missing og:image" }
  if (([regex]::Matches($text, '<h1[ >]')).Count -ne 1) { $fail += "${rel}: h1 count != 1" }
  foreach ($m in [regex]::Matches($text, '<script type="application/ld\+json">(.*?)</script>')) {
    try { $null = $m.Groups[1].Value | ConvertFrom-Json } catch { $fail += "${rel}: invalid JSON-LD" }
  }
  if ($rel -like "guias/*" -and $rel -ne "guias/index.html") {
    $body = [regex]::Match($text, '<div class="article-body">(.*)</div></article>').Groups[1].Value
    $n = ([regex]::Matches(($body -replace '<[^>]+>', ' '), '\w+')).Count
    if ($n -lt 1000) { $fail += "${rel}: only $n words in article body (min 1000)" }
  }
  foreach ($m in [regex]::Matches($text, 'href="([^"]+)"')) {
    $href = $m.Groups[1].Value.Split('#')[0].Split('?')[0]
    if ($href -and $href -notmatch '^(https?:|mailto:|#|/)') {
      $target = [System.IO.Path]::GetFullPath((Join-Path $file.DirectoryName $href))
      if (-not (Test-Path $target)) { $fail += "${rel}: broken link $href" } else { $k = $target.Substring($root.Length + 1).Replace('\', '/'); $inbound[$k] = 1 + [int]$inbound[$k] }
    }
  }
  foreach ($m in [regex]::Matches($text, '<a [^>]*href="https?://[^"]*amazon\.[^"]*"[^>]*>')) {
    if ($m.Value -notmatch 'nodeId=201909010' -and $m.Value -notmatch 'rel="[^"]*sponsored[^"]*nofollow[^"]*noopener') { $fail += "${rel}: Amazon link without rel sponsored nofollow noopener" }
  }
}
foreach ($file in $pages) {
  $rel = $file.FullName.Substring($root.Length + 1).Replace('\', '/')
  if ($rel -ne "index.html" -and [int]$inbound[$rel] -lt 3) { $fail += "${rel}: fewer than 3 inbound links ($([int]$inbound[$rel]))" }
}
if ($fail.Count) { $fail | ForEach-Object { "FAIL $_" }; exit 1 } else { "PASS: $($pages.Count) HTML pages (links, sitemap, canonical, title/description length, one h1, og:image, JSON-LD, 1000+ words per guide, 3+ inbound links, UTF-8, Amazon rel)" }
