# AppSec25 – Docker Toolbox + Juice Shop

Detta repo innehåller en verktygslåda i Docker för projektet “Sårbarhetsanalys – Applikationssäkerhet (25p)”.
Miljön startar OWASP Juice Shop samt en separat tools-container med minst 6 säkerhetsverktyg.

## Innehåll
- Dockerfile: bygger `appsec-tools` med säkerhetsverktyg
- docker-compose.yml: startar Juice Shop + tools-container i samma nätverk
- work/: katalog för output (ffuf-resultat, nuclei-rapporter, sqlmap-output etc.)

## Verktyg i tools-container
Kategorier och verktyg:
1. DAST: `nuclei`
2. Content discovery: `ffuf`
3. SQL Injection: `sqlmap`
4. Password cracking: `hashcat`
5. Nätverk/recon: `nmap`
6. HTTP/utility: `curl`, `jq`
(+ bonus) Listener: `nc`

## Starta miljön
```bash
docker compose up -d --build

Juice Shop:

http://localhost:3000

Öppna tools-container:

docker compose exec tools bash
Exempelkommandon (Kan behöva använda egna kommandon men det här är dom som fungerarde för mig under mitt projekt)
ffuf (discovery)
ffuf -u http://juice-shop:3000/FUZZ -w /opt/wordlists/common.txt -mc 200,301,302,403
nuclei (DAST)
echo "http://juice-shop:3000" > /work/targets.txt
nuclei -l /work/targets.txt -tags exposure,misconfig -stats -o /work/nuclei.txt
sqlmap (SQLi)
python3 /opt/sqlmap/sqlmap.py -u "http://juice-shop:3000/rest/products/search?q=test" --batch --dbms=SQLite --dump
hashcat (cracking)
Lägg hash i /work/hashes.txt och kör:

hashcat -m 0 /work/hashes.txt /opt/wordlists/common.txt
nmap (recon)
nmap -sV juice-shop
netcat (listener)
nc -lvnp 9001
Avsluta
docker compose down
