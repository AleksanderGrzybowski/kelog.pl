kind: Ingress
apiVersion: networking.k8s.io/v1
metadata:
  name: kiedygramy-zespolsdg-redirect
  annotations:
    nginx.ingress.kubernetes.io/configuration-snippet: |
      if ($host ~ ^.*iedygramy.zespolsdg\.pl$) {
        return 302 https://docs.google.com/spreadsheets/d/1ivEQhfoDYevSdUoFyemncJE9kw5oLlAO3J8h_yDjUKA/edit;

      }
spec:
  tls:
  - hosts:
    - kiedygramy.zespolsdg.pl
    secretName: kiedygramy.zespolsdg.pl
  rules:
  - host: "kiedygramy.zespolsdg.pl"
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: aleksandergrzybowskipl # doesn't matter
            port:
              number: 80
