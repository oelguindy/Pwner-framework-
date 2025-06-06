#!/bin/bash
# ----------------------------
# Install or update all tools (apt + GitHub)
install_and_update() {
  clear
  echo -e "${CYAN}[*] Updating package lists and upgrading installed packages...${NC}"
  sudo apt update && sudo apt upgrade -y

  echo -e "${CYAN}[*] Installing apt packages...${NC}"
  sudo apt install -y \
    figlet \
    nmap masscan sublist3r amass recon-ng theharvester spiderfoot dnsenum dnsutils fierce \
    nikto xsstrike dirsearch ffuf nuclei searchsploit hydra medusa ncrack wfuzz brutex \
    hashcat john cewl crunch cupp aircrack-ng reaver bettercap sslstrip wifiphisher \
    metasploit-framework commix msfvenom netcat veil-framework \
    tcpdump netsniff-ng dsniff arpspoof macchanger dnschef sqlmap burpsuite wafw00f \
    proxychains4 bashfuscator tor

  echo -e "${CYAN}[*] Cloning/updating GitHub tools...${NC}"
  GIT_BASE="$HOME/tools"
  mkdir -p "$GIT_BASE"

  git_clone_or_pull() {
    local repo_url="$1"
    local dest="$2"
    if [[ -d "$dest/.git" ]]; then
      echo "[*] Updating $dest..."
      git -C "$dest" pull
    else
      echo "[*] Cloning $repo_url into $dest..."
      git clone "$repo_url" "$dest"
    fi
  }

  git_clone_or_pull https://github.com/projectdiscovery/subfinder.git           "$GIT_BASE/subfinder"
  git_clone_or_pull https://github.com/TrustedSec/SET.git                      "$GIT_BASE/SET"
  git_clone_or_pull https://github.com/htr-tech/zphisher.git                   "$GIT_BASE/zphisher"
  git_clone_or_pull https://github.com/kgretzky/evilginx2.git                  "$GIT_BASE/evilginx2"
  git_clone_or_pull https://github.com/Veil-Framework/Veil.git                  "$GIT_BASE/veil-framework"

  echo -e "${GREEN}[+] All tools installed and updated.${NC}"
  pause
  main_menu
}

# ----------------------------
# Information Gathering Menu
info_gathering() {
  while true; do
    clear
    echo -e "${CYAN}Information Gathering Modules:${NC}"
    echo "  1) Port Scanning"
    echo "  2) Subdomain Scanning"
    echo "  3) OSINT"
    echo "  4) DNS Enumeration"
    echo "  99) Back to Main Menu"
    read -p "Choose an option: " ig

    case "$ig" in
      1)  # Port Scanning
        while true; do
          clear
          echo -e "${CYAN}Port Scanning Tools:${NC}"
          echo "  1) Nmap"
          echo "  2) Masscan"
          echo "  99) Back"
          read -p "Choose: " ps
          case "$ps" in
            1)
              read -p "Enter target (IP/domain) for Nmap: " target
              nmap "$target"
              pause
              ;;
            2)
              read -p "Enter target (IP/subnet) for Masscan: " target
              masscan "$target"
              pause
              ;;
            99) break ;;
            *) echo "Invalid option"; sleep 1 ;;
          esac
        done
        ;;
      2)  # Subdomain Scanning
        while true; do
          clear
          echo -e "${CYAN}Subdomain Scanning Tools:${NC}"
          echo "  1) Sublist3r"
          echo "  2) Subfinder"
          echo "  3) Amass"
          echo "  99) Back"
          read -p "Choose: " sd
          case "$sd" in
            1)
              read -p "Enter domain for Sublist3r: " domain
              sublist3r -d "$domain"
              pause
              ;;
            2)
              read -p "Enter domain for Subfinder: " domain
              "$HOME/tools/subfinder/subfinder" -d "$domain"
              pause
              ;;
            3)
              read -p "Enter domain for Amass: " domain
              amass enum -d "$domain"
              pause
              ;;
            99) break ;;
            *) echo "Invalid option"; sleep 1 ;;
          esac
        done
        ;;
      3)  # OSINT
        while true; do
          clear
          echo -e "${CYAN}OSINT Tools:${NC}"
          echo "  1) Recon-ng"
          echo "  2) The Harvester"
          echo "  3) Spiderfoot"
          echo "  99) Back"
          read -p "Choose: " osint
          case "$osint" in
            1)
              recon-ng
              pause
              ;;
            2)
              read -p "Enter domain for The Harvester: " domain
              theharvester -d "$domain" -b all
              pause
              ;;
            3)
              spiderfoot
              pause
              ;;
            99) break ;;
            *) echo "Invalid option"; sleep 1 ;;
          esac
        done
        ;;
      4)  # DNS Enumeration
        while true; do
          clear
          echo -e "${CYAN}DNS Enumeration Tools:${NC}"
          echo "  1) Dnsenum"
          echo "  2) Dig"
          echo "  3) Fierce"
          echo "  99) Back"
          read -p "Choose: " dns
          case "$dns" in
            1)
              read -p "Enter domain for Dnsenum: " domain
              dnsenum "$domain"
              pause
              ;;
            2)
              read -p "Enter domain for Dig: " domain
              dig "$domain" any
              pause
              ;;
            3)
              read -p "Enter domain for Fierce: " domain
              fierce --domain "$domain"
              pause
              ;;
            99) break ;;
            *) echo "Invalid option"; sleep 1 ;;
          esac
        done
        ;;
      99) return ;;
      *) echo "Invalid option"; sleep 1 ;;
    esac
  done
}

# ----------------------------
# Vulnerability Scanning Menu
vuln_scanning() {
  while true; do
    clear
    echo -e "${CYAN}Vulnerability Scanning Modules:${NC}"
    echo "  1) General Vulnerability Scanning"
    echo "  2) Web App Scanning"
    echo "  3) CVE Scanner"
    echo "  99) Back to Main Menu"
    read -p "Choose an option: " vs

    case "$vs" in
      1)  # General Vulnerability Scanning
        while true; do
          clear
          echo -e "${CYAN}General Vulnerability Scanning Tools:${NC}"
          echo "  1) Nikto"
          echo "  2) Vulscan (via Nmap script)"
          echo "  99) Back"
          read -p "Choose: " gvs
          case "$gvs" in
            1)
              read -p "Enter target (URL/IP) for Nikto: " target
              nikto -h "$target"
              pause
              ;;
            2)
              read -p "Enter target (IP/hostname) for Nmap+Vulscan: " target
              nmap --script vuln "$target"
              pause
              ;;
            99) break ;;
            *) echo "Invalid option"; sleep 1 ;;
          esac
        done
        ;;
      2)  # Web App Scanning
        while true; do
          clear
          echo -e "${CYAN}Web App Scanning Tools:${NC}"
          echo "  1) XSStrike"
          echo "  2) Dirsearch"
          echo "  3) Fuff"
          echo "  4) Nuclei"
          echo "  99) Back"
          read -p "Choose: " was
          case "$was" in
            1)
              read -p "Enter target URL for XSStrike: " url
              xsstrike -u "$url"
              pause
              ;;
            2)
              read -p "Enter target URL for Dirsearch: " url
              dirsearch -u "$url"
              pause
              ;;
            3)
              read -p "Enter target URL for Fuff: " url
              ffuf -u "$url/FUZZ" -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
              pause
              ;;
            4)
              read -p "Enter target URL for Nuclei: " url
              nuclei -u "$url"
              pause
              ;;
            99) break ;;
            *) echo "Invalid option"; sleep 1 ;;
          esac
        done
        ;;
      3)  # CVE Scanner
        while true; do
          clear
          echo -e "${CYAN}CVE Scanner Tools:${NC}"
          echo "  1) Searchsploit"
          echo "  99) Back"
          read -p "Choose: " cve
          case "$cve" in
            1)
              read -p "Enter CVE or keyword for Searchsploit: " kw
              searchsploit "$kw"
              pause
              ;;
            99) break ;;
            *) echo "Invalid option"; sleep 1 ;;
          esac
        done
        ;;
      99) return ;;
      *) echo "Invalid option"; sleep 1 ;;
    esac
  done
}

# ----------------------------
# Password Attacks Menu
password_attacks() {
  while true; do
    clear
    echo -e "${CYAN}Password Attacks Modules:${NC}"
    echo "  1) Brute force / Dictionary Attack"
    echo "  2) Web Attack"
    echo "  3) Hash Cracking"
    echo "  4) Wordlist Generator"
    echo "  99) Back to Main Menu"
    read -p "Choose an option: " pa

    case "$pa" in
      1)  # Brute force / Dictionary Attack
        while true; do
          clear
          echo -e "${CYAN}Brute force / Dictionary Tools:${NC}"
          echo "  1) Hydra"
          echo "  2) Medusa"
          echo "  3) Ncrack"
          echo "  99) Back"
          read -p "Choose: " bf
          case "$bf" in
            1)
              echo "Example: hydra -l user -P passwordlist.txt ftp://target"
              read -p "Enter full Hydra command (arguments only): " args
              hydra $args
              pause
              ;;
            2)
              echo "Example: medusa -h target -u user -P passwordlist.txt -M ftp"
              read -p "Enter full Medusa command (arguments only): " args
              medusa $args
              pause
              ;;
            3)
              echo "Example: ncrack -p 22 ssh://target"
              read -p "Enter full Ncrack command (arguments only): " args
              ncrack $args
              pause
              ;;
            99) break ;;
            *) echo "Invalid option"; sleep 1 ;;
          esac
        done
        ;;
      2)  # Web Attack
        while true; do
          clear
          echo -e "${CYAN}Web Attack Tools:${NC}"
          echo "  1) Wfuzz"
          echo "  2) Brutex"
          echo "  99) Back"
          read -p "Choose: " wa
          case "$wa" in
            1)
              read -p "Enter Wfuzz command (arguments only): " args
              wfuzz $args
              pause
              ;;
            2)
              read -p "Enter Brutex command (if installed): " args
              brutex $args
              pause
              ;;
            99) break ;;
            *) echo "Invalid option"; sleep 1 ;;
          esac
        done
        ;;
      3)  # Hash Cracking
        while true; do
          clear
          echo -e "${CYAN}Hash Cracking Tools:${NC}"
          echo "  1) Hashcat"
          echo "  2) John the Ripper"
          echo "  99) Back"
          read -p "Choose: " hc
          case "$hc" in
            1)
              read -p "Enter hash file path: " hf
              read -p "Enter attack mode (e.g., 0): " mode
              read -p "Enter wordlist path: " wl
              hashcat -m "$mode" "$hf" "$wl"
              pause
              ;;
            2)
              read -p "Enter password hash file: " hf
              john "$hf"
              pause
              ;;
            99) break ;;
            *) echo "Invalid option"; sleep 1 ;;
          esac
        done
        ;;
      4)  # Wordlist Generator
        while true; do
          clear
          echo -e "${CYAN}Wordlist Generator Tools:${NC}"
          echo "  1) Cewl"
          echo "  2) Crunch"
          echo "  3) Cupp"
          echo "  99) Back"
          read -p "Choose: " wg
          case "$wg" in
            1)
              read -p "Enter URL for Cewl: " url
              read -p "Output filename: " out
              cewl "$url" -w "$out"
              pause
              ;;
            2)
              read -p "Enter min length: " min
              read -p "Enter max length: " max
              read -p "Output filename: " out
              crunch "$min" "$max" -o "$out"
              pause
              ;;
            3)
              read -p "Generate wordlist using cupp interactive mode? (y/n): " yn
              if [[ "$yn" =~ ^[Yy]$ ]]; then
                cupp
              else
                echo "Canceled."
                sleep 1
              fi
              ;;
            99) break ;;
            *) echo "Invalid option"; sleep 1 ;;
          esac
        done
        ;;
      99) return ;;
      *) echo "Invalid option"; sleep 1 ;;
    esac
  done
}

# ----------------------------
# Wireless Testing Menu
wireless_testing() {
  while true; do
    clear
    echo -e "${CYAN}Wireless Testing Modules:${NC}"
    echo "  1) Wifi Cracking"
    echo "  2) MITM Attacks"
    echo "  3) Evil Twin"
    echo "  99) Back to Main Menu"
    read -p "Choose an option: " wt

    case "$wt" in
      1)  # Wifi Cracking
        while true; do
          clear
          echo -e "${CYAN}Wifi Cracking Tools:${NC}"
          echo "  1) Aircrack-ng"
          echo "  2) Reaver"
          echo "  99) Back"
          read -p "Choose: " wc
          case "$wc" in
            1)
              echo "Example: airodump-ng wlan0; aireplay-ng -0 5 -a <AP MAC> wlan0"
              read -p "Enter Aircrack-ng command (arguments only): " args
              aircrack-ng $args
              pause
              ;;
            2)
              read -p "Enter target BSSID: " bssid
              read -p "Enter interface: " iface
              reaver -i "$iface" -b "$bssid"
              pause
              ;;
            99) break ;;
            *) echo "Invalid option"; sleep 1 ;;
          esac
        done
        ;;
      2)  # MITM Attacks
        while true; do
          clear
          echo -e "${CYAN}MITM Attack Tools:${NC}"
          echo "  1) Bettercap"
          echo "  2) SSLStrip"
          echo "  99) Back"
          read -p "Choose: " mitm
          case "$mitm" in
            1)
              sudo bettercap
              pause
              ;;
            2)
              sudo sslstrip -l 8080
              pause
              ;;
            99) break ;;
            *) echo "Invalid option"; sleep 1 ;;
          esac
        done
        ;;
      3)  # Evil Twin
        while true; do
          clear
          echo -e "${CYAN}Evil Twin Tool:${NC}"
          echo "  1) Wifiphisher"
          echo "  99) Back"
          read -p "Choose: " et
          case "$et" in
            1)
              sudo wifiphisher
              pause
              ;;
            99) break ;;
            *) echo "Invalid option"; sleep 1 ;;
          esac
        done
        ;;
      99) return ;;
      *) echo "Invalid option"; sleep 1 ;;
    esac
  done
}

# ----------------------------
# Exploitation Tools Menu
exploitation_tools() {
  while true; do
    clear
    echo -e "${CYAN}Exploitation Tools Modules:${NC}"
    echo "  1) General Exploitation"
    echo "  2) Payload Generator"
    echo "  3) Payload Obfuscation"
    echo "  99) Back to Main Menu"
    read -p "Choose an option: " et

    case "$et" in
      1)  # General Exploitation
        while true; do
          clear
          echo -e "${CYAN}General Exploitation Tools:${NC}"
          echo "  1) Metasploit Framework"
          echo "  2) Commix"
          echo "  99) Back"
          read -p "Choose: " ge
          case "$ge" in
            1)
              msfconsole
              pause
              ;;
            2)
              read -p "Enter target URL for Commix: " url
              commix --url="$url"
              pause
              ;;
            99) break ;;
            *) echo "Invalid option"; sleep 1 ;;
          esac
        done
        ;;
      2)  # Payload Generator
        while true; do
          clear
          echo -e "${CYAN}Payload Generator Tools:${NC}"
          echo "  1) Msfvenom"
          echo "  2) Netcat"
          echo "  99) Back"
          read -p "Choose: " pg
          case "$pg" in
            1)
              echo "MSFVenom usage: msfvenom -p <payload> LHOST=<IP> LPORT=<PORT> -f <format> -o <output>"
              read -p "Enter msfvenom parameters: " args
              msfvenom $args
              pause
              ;;
            2)
              read -p "Enter netcat command (arguments only): " args
              nc $args
              pause
              ;;
            99) break ;;
            *) echo "Invalid option"; sleep 1 ;;
          esac
        done
        ;;
      3)  # Payload Obfuscation
        while true; do
          clear
          echo -e "${CYAN}Payload Obfuscation Tool:${NC}"
          echo "  1) Veil Framework"
          echo "  99) Back"
          read -p "Choose: " po
          case "$po" in
            1)
              veil
              pause
              ;;
            99) break ;;
            *) echo "Invalid option"; sleep 1 ;;
          esac
        done
        ;;
      99) return ;;
      *) echo "Invalid option"; sleep 1 ;;
    esac
  done
}

# ----------------------------
# Sniffing and Spoofing Menu
sniffing_spoofing() {
  while true; do
    clear
    echo -e "${CYAN}Sniffing and Spoofing Modules:${NC}"
    echo "  1) Sniffing"
    echo "  2) Spoofing"
    echo "  99) Back to Main Menu"
    read -p "Choose an option: " ss

    case "$ss" in
      1)  # Sniffing
        while true; do
          clear
          echo -e "${CYAN}Sniffing Tools:${NC}"
          echo "  1) Tcpdump"
          echo "  2) Netsniff-ng"
          echo "  3) Dsniff"
          echo "  99) Back"
          read -p "Choose: " sniff
          case "$sniff" in
            1)
              read -p "Enter interface for Tcpdump (e.g., wlan0): " iface
              sudo tcpdump -i "$iface"
              pause
              ;;
            2)
              read -p "Enter interface for Netsniff-ng: " iface
              sudo netsniff-ng -i "$iface"
              pause
              ;;
            3)
              read -p "Enter interface for Dsniff: " iface
              sudo dsniff -i "$iface"
              pause
              ;;
            99) break ;;
            *) echo "Invalid option"; sleep 1 ;;
          esac
        done
        ;;
      2)  # Spoofing
        while true; do
          clear
          echo -e "${CYAN}Spoofing Tools:${NC}"
          echo "  1) Arpspoof"
          echo "  2) Macchanger"
          echo "  3) DNSChef"
          echo "  4) Scapy"
          echo "  99) Back"
          read -p "Choose: " spoof
          case "$spoof" in
            1)
              read -p "Enter interface: " iface
              read -p "Enter target IP for arpspoof: " ip
              sudo arpspoof -i "$iface" -t "$ip"
              pause
              ;;
            2)
              read -p "Enter interface for Macchanger: " iface
              sudo macchanger -r "$iface"
              pause
              ;;
            3)
              read -p "Enter interface for DNSChef: " iface
              sudo dnschef --interface "$iface"
              pause
              ;;
            4)
              scapy
              pause
              ;;
            99) break ;;
            *) echo "Invalid option"; sleep 1 ;;
          esac
        done
        ;;
      99) return ;;
      *) echo "Invalid option"; sleep 1 ;;
    esac
  done
}

# ----------------------------
# Web Hacking Menu
web_hacking() {
  while true; do
    clear
    echo -e "${CYAN}Web Hacking Modules:${NC}"
    echo "  1) SQLmap"
    echo "  2) Burp Suite"
    echo "  3) Wafw00f"
    echo "  99) Back to Main Menu"
    read -p "Choose an option: " wh

    case "$wh" in
      1)
        read -p "Enter target URL for SQLmap: " url
        sqlmap -u "$url" --batch
        pause
        ;;
      2)
        burpsuite
        pause
        ;;
      3)
        read -p "Enter domain for Wafw00f: " domain
        wafw00f "$domain"
        pause
        ;;
      99) return ;;
      *) echo "Invalid option"; sleep 1 ;;
    esac
  done
}

# ----------------------------
# Social Engineering Menu
social_engineering() {
  while true; do
    clear
    echo -e "${CYAN}Social Engineering Modules:${NC}"
    echo "  1) SEToolkit"
    echo "  2) zphisher"
    echo "  3) evilginx2"
    echo "  99) Back to Main Menu"
    read -p "Choose an option: " se

    case "$se" in
      1)
        setoolkit
        pause
        ;;
      2)
        bash "$HOME/tools/zphisher/zphisher.sh"
        pause
        ;;
      3)
        sudo "$HOME/tools/evilginx2/evilginx2"
        pause
        ;;
      99) return ;;
      *) echo "Invalid option"; sleep 1 ;;
    esac
  done
}

# ----------------------------
# OPSEC Menu
opsec() {
  while true; do
    clear
    echo -e "${CYAN}OPSEC Tools:${NC}"
    echo "  1) Bashfuscator"
    echo "  2) Proxychains (with Tor)"
    echo "  99) Back to Main Menu"
    read -p "Choose an option: " op

    case "$op" in
      1)
        read -p "Enter script to obfuscate with Bashfuscator: " script
        bashfuscator "$script"
        pause
        ;;
      2)
        read -p "Enter command to run through Proxychains: " cmd
        proxychains4 $cmd
        pause
        ;;
      99) return ;;
      *) echo "Invalid option"; sleep 1 ;;
    esac
  done
}

# ----------------------------
# Main Menu
main_menu() {
  while true; do
    clear
    echo -e "${CYAN}========================================${NC}"
    echo -e "${GREEN}              P W N E R                 ${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo "  1) Information Gathering"
    echo "  2) Vulnerability Scanning"
    echo "  3) Password Attacks"
    echo "  4) Wireless Testing"
    echo "  5) Exploitation Tools"
    echo "  6) Sniffing and Spoofing"
    echo "  7) Web Hacking"
    echo "  8) Social Engineering"
    echo "  9) OPSEC"
    echo " 10) Install and Update"
    echo " 99) Exit"
    echo -e "${CYAN}========================================${NC}"
    read -p "Choose an option: " opt

    case "$opt" in
      1) info_gathering ;;
      2) vuln_scanning ;;
      3) password_attacks ;;
      4) wireless_testing ;;
      5) exploitation_tools ;;
      6) sniffing_spoofing ;;
      7) web_hacking ;;
      8) social_engineering ;;
      9) opsec ;;
      10) install_and_update ;;
      99) echo -e "${RED}Goodbye!${NC}"; exit 0 ;;
      *) echo "Invalid option"; sleep 1 ;;
    esac
  done
}

# ----------------------------
# Start the main menu
main_menu
