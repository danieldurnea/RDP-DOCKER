echo -e "$123\n$123\n" | sudo passwd
rm -rf ngrok  ngrok.zip  ngrok.sh > /dev/null 2>&1
wget -O ngrok.sh https://raw.githubusercontent.com/RezkyIt/kali-linux-rdp/main/ngrok.sh > /dev/null 2>&1
chmod +x ngrok.sh
./ngrok.sh
clear
echo "======================="
echo choose ngrok region
echo "======================="
echo "us - United States (New York)"
echo "eu - Europe (Frankfurt)"
echo "ap - Asia/Pacific (Singapore)"
echo "au - Australia (Sydney)"
echo "sa - South America (Sao Paulo)"
echo "jp - Japan (Tokyo)"
echo "in - India (Mumbai)"
read -p "choose ngrok region: " CRP
./ngrok tcp --region $CRP 22 &>/dev/null &
echo "===================================="
echo "Please Wait, Installing RDP"
echo "===================================="
docker pull kalilinux/kali-rolling:latest
clear
echo "===================================="
echo "Start RDP"
echo "===================================="
echo "===================================="
echo "Username : ubuntu"
echo "Password : ubuntu"
echo "RDP Address:"
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'

