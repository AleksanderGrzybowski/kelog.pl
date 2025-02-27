#! /bin/bash
set -e

domains="aleksandergrzybowski.pl baza.zespolsdg.pl cogramy.zespolsdg.pl kanapka.zespolsdg.pl kiedygramy.zespolsdg.pl druzynapana.zespolsdg.pl registry.kelog.pl"

function scale_ingress_controller {
  replicas="$1"

  kubectl -n ingress-nginx scale deployment ingress-nginx-controller --replicas=${replicas}
}

function refresh_certificate {
  domain="$1"
  echo "Refreshing for domain $1 ..."

  sudo certbot certonly --standalone -d ${domain} --key-type ecdsa

  sudo rm -rf /tmp/fullchain.pem /tmp/privkey.pem
  sudo cp /etc/letsencrypt/live/${domain}/fullchain.pem /tmp/
  sudo cp /etc/letsencrypt/live/${domain}/privkey.pem /tmp/
  sudo chmod 777 /tmp/fullchain.pem /tmp/privkey.pem

  kubectl -n default delete secret ${domain} || true
  kubectl -n default create secret tls ${domain} --key=/tmp/privkey.pem --cert=/tmp/fullchain.pem
}

scale_ingress_controller 0
sleep 30

for domain in ${domains}; do
  refresh_certificate ${domain}
done

scale_ingress_controller 1
