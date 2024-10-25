FROM golang:1.23.2-alpine3.20 as build

ENV GO111MODULE=on \
    GOPROXY=https://goproxy.cn,direct \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

WORKDIR /build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o httpServer cmd/http_server.go

FROM alpine:3.20
COPY --from=build /build/httpServer /bin/httpServer
ENTRYPOINT ["/bin/httpServer"]
