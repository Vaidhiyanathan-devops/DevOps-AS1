#!/bin/bash
#this file will deploy nginx lb with ssl termination , Application will up and run 
apt update; apt install nginx git curl python3 build-essential python3.13-venv -y
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - ; sudo apt install -y nodejs

git clone https://github.com/Vaidhiyanathan-devops/DevOps-Assignment.git /project
cd /project/backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --host 127.0.0.1 --port 8000 &

cd /project/frontend
npm install && npm run build
npm run start -- -p 3000 &

mkdir -p /etc/letsencrypt/live/vaidhi.sbs
mkdir -p /etc/letsencrypt/archive/vaidhi.sbs 

sudo bash -c 'cat << EOF > /etc/letsencrypt/archive/vaidhi.sbs/fullchain.pem
-----BEGIN CERTIFICATE-----
MIIDjDCCAxKgAwIBAgISBZVJ2geniDbgs1zGUcw4KdLcMAoGCCqGSM49BAMDMDIx
CzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1MZXQncyBFbmNyeXB0MQswCQYDVQQDEwJF
ODAeFw0yNjA0MDEwODQxNTJaFw0yNjA2MzAwODQxNTFaMBUxEzARBgNVBAMTCnZh
aWRoaS5zYnMwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAATyP8ZoEpY/MjrNsTRq
D6jzKf2Z5vkionJFckiT4fW+663iY8xbw6A27q19mEEOUntOblNWXQwxYTppszFz
muy7o4ICIzCCAh8wDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUFBwMB
MAwGA1UdEwEB/wQCMAAwHQYDVR0OBBYEFF2hzZqy+ARVjXgZC5XVBX3s9nAaMB8G
A1UdIwQYMBaAFI8NE6L2Ln7RUGwzGDhdWY4jcpHKMDIGCCsGAQUFBwEBBCYwJDAi
BggrBgEFBQcwAoYWaHR0cDovL2U4LmkubGVuY3Iub3JnLzAjBgNVHREEHDAaggwq
LnZhaWRoaS5zYnOCCnZhaWRoaS5zYnMwEwYDVR0gBAwwCjAIBgZngQwBAgEwLQYD
VR0fBCYwJDAioCCgHoYcaHR0cDovL2U4LmMubGVuY3Iub3JnLzkzLmNybDCCAQsG
CisGAQQB1nkCBAIEgfwEgfkA9wB1AJaXZL9VWJet90OHaDcIQnfp8DrV9qTzNm5G
pD8PyqnGAAABnUhqWtEAAAQDAEYwRAIgZxQll6kwx1bLweIwyuV40wvJjnhWiVT+
jxtiN1n2G8QCIGRC8QFHkVD7OYjNMtZKb+9UA0QNqhGockn84JaqGOc3AH4AGoud
aUpXmMiZoMqIvfSPwLRWYMzDYA0fcfRp/8fRrKMAAAGdSGpcdAAIAAAFAFoUxzEE
AwBHMEUCIGV+sOnGl8o2yyIRw5cpDPaH3WkImcecJDgxuh4m8KRMAiEAvK9WmAow
FkjvenIa764Mvo6pHRu9Os/DuOAJ0K/W7P0wCgYIKoZIzj0EAwMDaAAwZQIxAN5+
veOUBc2AyMvyYO72P8bIs4N35uZrQkoviGgaZ9P7KYXUzP64o6gxpaLol5BI0wIw
Z8yIH/qWEp/Gns6r+BL2GF33BHcawlkT68b3c63aF6sPRbxiAyzhHzpTqlBtW/1W
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIEVjCCAj6gAwIBAgIQY5WTY8JOcIJxWRi/w9ftVjANBgkqhkiG9w0BAQsFADBP
MQswCQYDVQQGEwJVUzEpMCcGA1UEChMgSW50ZXJuZXQgU2VjdXJpdHkgUmVzZWFy
Y2ggR3JvdXAxFTATBgNVBAMTDElTUkcgUm9vdCBYMTAeFw0yNDAzMTMwMDAwMDBa
Fw0yNzAzMTIyMzU5NTlaMDIxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1MZXQncyBF
bmNyeXB0MQswCQYDVQQDEwJFODB2MBAGByqGSM49AgEGBSuBBAAiA2IABNFl8l7c
S7QMApzSsvru6WyrOq44ofTUOTIzxULUzDMMNMchIJBwXOhiLxxxs0LXeb5GDcHb
R6EToMffgSZjO9SNHfY9gjMy9vQr5/WWOrQTZxh7az6NSNnq3u2ubT6HTKOB+DCB
9TAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMB
MBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFI8NE6L2Ln7RUGwzGDhdWY4j
cpHKMB8GA1UdIwQYMBaAFHm0WeZ7tuXkAXOACIjIGlj26ZtuMDIGCCsGAQUFBwEB
BCYwJDAiBggrBgEFBQcwAoYWaHR0cDovL3gxLmkubGVuY3Iub3JnLzATBgNVHSAE
DDAKMAgGBmeBDAECATAnBgNVHR8EIDAeMBygGqAYhhZodHRwOi8veDEuYy5sZW5j
ci5vcmcvMA0GCSqGSIb3DQEBCwUAA4ICAQBnE0hGINKsCYWi0Xx1ygxD5qihEjZ0
RI3tTZz1wuATH3ZwYPIp97kWEayanD1j0cDhIYzy4CkDo2jB8D5t0a6zZWzlr98d
AQFNh8uKJkIHdLShy+nUyeZxc5bNeMp1Lu0gSzE4McqfmNMvIpeiwWSYO9w82Ob8
otvXcO2JUYi3svHIWRm3+707DUbL51XMcY2iZdlCq4Wa9nbuk3WTU4gr6LY8MzVA
aDQG2+4U3eJ6qUF10bBnR1uuVyDYs9RhrwucRVnfuDj29CMLTsplM5f5wSV5hUpm
Uwp/vV7M4w4aGunt74koX71n4EdagCsL/Yk5+mAQU0+tue0JOfAV/R6t1k+Xk9s2
HMQFeoxppfzAVC04FdG9M+AC2JWxmFSt6BCuh3CEey3fE52Qrj9YM75rtvIjsm/1
Hl+u//Wqxnu1ZQ4jpa+VpuZiGOlWrqSP9eogdOhCGisnyewWJwRQOqK16wiGyZeR
xs/Bekw65vwSIaVkBruPiTfMOo0Zh4gVa8/qJgMbJbyrwwG97z/PRgmLKCDl8z3d
tA0Z7qq7fta0Gl24uyuB05dqI5J1LvAzKuWdIjT1tP8qCoxSE/xpix8hX2dt3h+/
jujUgFPFZ0EVZ0xSyBNRF3MboGZnYXFUxpNjTWPKpagDHJQmqrAcDmWJnMsFY3jS
u1igv3OefnWjSQ==
-----END CERTIFICATE-----
EOF'


sudo bash -c 'cat << EOF > /etc/letsencrypt/archive/vaidhi.sbs/privkey2.pem
-----BEGIN PRIVATE KEY-----
MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQgAr0nfxlku9rF8S3D
aDfzNL1uXYMBw+P3ZmOiv6N9ORqhRANCAATyP8ZoEpY/MjrNsTRqD6jzKf2Z5vki
onJFckiT4fW+663iY8xbw6A27q19mEEOUntOblNWXQwxYTppszFzmuy7
-----END PRIVATE KEY-----
EOF'

chmod 600 /etc/letsencrypt/archive/vaidhi.sbs/privkey2.pem

ln -sf /etc/letsencrypt/archive/vaidhi.sbs/privkey2.pem /etc/letsencrypt/live/vaidhi.sbs/privkey.pem

ln -sf  /etc/letsencrypt/archive/vaidhi.sbs/fullchain.pem /etc/letsencrypt/live/vaidhi.sbs/fullchain.pem

cp -r /project/Nginx/default /etc/nginx/sites-enabled/

nginx -s reload


