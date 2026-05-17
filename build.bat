@echo off
cd /d "%~dp0"

echo packing...
"C:\Program Files\7-Zip\7z.exe" a -tzip "fsr_enabler.zip" * -xr!"*.bat" -xr!"*.zip" -xr!"*.vmz"

echo rename to .vmz...
if exist "fsr_enabler.vmz" del "fsr_enabler.vmz"
rename "fsr_enabler.zip" "fsr_enabler.vmz"

echo ready.
pause