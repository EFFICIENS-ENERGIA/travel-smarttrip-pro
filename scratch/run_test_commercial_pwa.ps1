$edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if (-not (Test-Path $edgePath)) {
  $edgePath = "C:\Program Files\Microsoft\Edge\Application\msedge.exe"
}
$testUrl = "file:///c:/Users/EFFICIENS%20ENERGIA/Desktop/ANTIGRAVITY/`$HOMEagy2-projectsmy-first-project/scratch/test_commercial_pwa.html"
$screenPath = "C:\Users\EFFICIENS ENERGIA\.gemini\antigravity\brain\f076e0be-08ee-48cc-9303-5a3edb1e0506\commercial_pwa_screenshot.png"

Write-Output "Running Edge Headless Test..."
& $edgePath --headless --disable-gpu --virtual-time-budget=10000 --screenshot=$screenPath --window-size=1280,1200 $testUrl

Start-Sleep -Seconds 2

if (Test-Path $screenPath) {
  Write-Output "Screenshot captured: $screenPath"
} else {
  Write-Output "Screenshot failed"
}
