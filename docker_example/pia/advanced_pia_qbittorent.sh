# 1. Force clean everything
docker-compose down --remove-orphans --volumes --rmi all
docker system prune -af
docker network prune -f

# 2. Recreate with fixed config
docker-compose up -d

# 3. Check VPN connection (wait 30 seconds)
docker logs gluetun | grep -i "initialization sequence completed"

# 4. Verify IP (if wget works)
docker exec gluetun wget -qO- https://ipinfo.io/json | grep -E "ip|country" || echo "Install wget in gluetun for this check"

# 5. Access WebUI
echo "Access at http://localhost:8080 with credentials from: docker logs qbittorrent-vpn"
