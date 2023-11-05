FROM alpine:3.12

ARG GOLANG_VERSION=1.14.3

#we need the go version installed from apk to bootstrap the custom version built from source
RUN apk update && apk add go gcc bash musl-dev openssl-dev ca-certificates && update-ca-certificates

RUN wget https://dl.google.com/go/go$GOLANG_VERSION.src.tar.gz && tar -C /usr/local -xzf go$GOLANG_VERSION.src.tar.gz

RUN cd /usr/local/go/src && ./make.bash

ENV PATH=$PATH:/usr/local/go/bin

RUN rm go$GOLANG_VERSION.src.tar.gz

RUN go mod init github.com/aprendagolang/docker

#we delete the apk installed version to avoid conflict
RUN apk del go

COPY hello.go ./

CMD [ "go", "run", "." ]
