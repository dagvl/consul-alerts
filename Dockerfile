FROM golang:1.10 as builder
MAINTAINER Dag Viggo Lokoeen <dag.viggo@lokoen.org>

WORKDIR /go/src/github.com/dagvl/consul-alerts/
ADD . /go/src/github.com/dagvl/consul-alerts/
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o consul-alerts .

FROM consul:1.2.0
RUN apk --no-cache add ca-certificates \
  && addgroup -S consul-alerts \
  && adduser -S consul-alerts -G consul-alerts
USER consul-alerts
WORKDIR /bin
COPY --from=builder /go/src/github.com/dagvl/consul-alerts/consul-alerts /bin/consul-alerts

EXPOSE 9000
CMD []
ENTRYPOINT [ "/bin/consul-alerts", "--alert-addr=0.0.0.0:9000" ]