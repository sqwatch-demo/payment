FROM golang:1.19-alpine

COPY . /src
WORKDIR /src

RUN go get ./... && \
    go mod vendor
RUN go build cmd/paymentsvc/main.go && \
    mv main /payment

FROM alpine:3.17.1

WORKDIR /
COPY --from=0 /payment /payment

ENV	SERVICE_USER=myuser \
	SERVICE_UID=10001 \
	SERVICE_GROUP=mygroup \
	SERVICE_GID=10001

RUN	addgroup -g ${SERVICE_GID} ${SERVICE_GROUP} && \
	adduser -g "${SERVICE_NAME} user" -D -H -G ${SERVICE_GROUP} -s /sbin/nologin -u ${SERVICE_UID} ${SERVICE_USER} && \
	chmod +x /payment && \
    chown -R ${SERVICE_USER}:${SERVICE_GROUP} /payment

USER ${SERVICE_USER}

CMD ["/payment", "-port=8080"]

EXPOSE 8080
