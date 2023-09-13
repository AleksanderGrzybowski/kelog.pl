#! /bin/bash
set -e

function refresh_certificate {
  domain="$1"
  echo "Refreshing for domain $1 ..."

  sudo certbot certonly --standalone -d ${domain}

  sudo rm -rf /tmp/fullchain.pem /tmp/privkey.pem
  sudo cp /etc/letsencrypt/live/${domain}/fullchain.pem /tmp/
  sudo cp /etc/letsencrypt/live/${domain}/privkey.pem /tmp/
  sudo chmod 777 /tmp/fullchain.pem /tmp/privkey.pem

  kubectl -n default delete secret ${domain} || true
  kubectl -n default create secret tls ${domain} --key=/tmp/privkey.pem --cert=/tmp/fullchain.pem
}

kubectl -n ingress-nginx scale deployment ingress-nginx-controller --replicas=0
sleep 30 # good enough

refresh_certificate aleksandergrzybowski.pl
refresh_certificate baza.zespolsdg.pl
refresh_certificate cogramy.zespolsdg.pl
refresh_certificate kanapka.zespolsdg.pl
refresh_certificate kiedygramy.zespolsdg.pl
refresh_certificate druzynapana.zespolsdg.pl


kubectl -n ingress-nginx scale deployment ingress-nginx-controller --replicas=1
