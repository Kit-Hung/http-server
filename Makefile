build:
	echo "building httpserver binary..."
	mkdir -p bin/amd64
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o bin/amd64 cmd/http_server.go


build-image:
	docker build -t kit.harbor.domain/http-server/http-server:v1.0 .
	docker push kit.harbor.domain/http-server/http-server:v1.0


create-config:
	kubectl create cm http-server-config --from-file=resources/config/config.yaml --dry-run=client -o yaml > resources/deploy/configmap.yaml


create-certs:
	mkdir -p ./resources/certs
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./resources/certs/tls.key -out resources/certs/tls.crt -subj "/CN=ktihung.com/O=ktihung" -addext "subjectAltName = DNS:ktihung.com"
	kubectl create secret tls http-server-tls --cert=./resources/certs/tls.crt --key=./resources/certs/tls.key