#! /bin/bash
echo ______________________________________________
echo
echo ----Xmrig installation script by Toomas633----
echo ______________________________________________
echo
sleep 3
echo Wallet address:
read wallet_address

echo Pool address:
read pool_address

echo Miner name:
read pass

echo ----Starting installation----

echo ----Installing packets----

sleep 5
apt install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev

echo ----Creating user miner----

sleep 5
adduser miner --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "miner:miner" | sudo chpasswd

echo ----Cloning xmrig ----

sleep 5
cd /home/miner
git clone https://github.com/xmrig/xmrig.git
mkdir xmrig/build && cd xmrig/build

echo ----Starting installation----

sleep 5
cmake ..
make 

echo ----Creating config file----

sleep 5
cat > config.json << EOF
{
    "autosave": true,
    "cpu": {
        "enabled": true,
        "priority": 0,
        "max-threads-hint": 100,
    },
    "opencl": false,
    "cuda": false,
    "pools": [
        {
            "coin": "monero",
            "algo": "rx/0",
            "url": "$pool_address",
            "user": "$wallet_address",
            "pass": "$pass",
            "tls": false,
            "keepalive": false,
            "nicehash": false
        }
    ]
}
EOF

echo ----Enabling autostart service---- 

sleep 5
cat > /etc/systemd/system/xmrig.service << EOF 
[Unit]
Description=XMRig Daemon
After=network.target

[Service]
Type=forking
GuessMainPID=no
ExecStart=/home/miner/xmrig/build/xmrig -c /home/miner/xmrig/build/config.json -l /home/miner/xmrig.log -B
Restart=always
User=miner

[Install]
WantedBy=multi-user.target
EOF

systemctl enable xmrig.service

echo ----Starting xmrig service----

sleep 5
service xmrig start

echo ______________________________
echo
echo -------------Done-------------
echo ----'Quiting in 5 seconds'----
echo ______________________________
sleep 5
clear
