FROM python:3.9-alpine as builder

RUN apk update && apk add  --no-cache tzdata alpine-sdk libffi-dev ca-certificates
ADD requirements.txt /tmp/
RUN pip3 install --user -r /tmp/requirements.txt && rm /tmp/requirements.txt


FROM python:3.9-alpine
WORKDIR /ytdlbot
ENV TZ=Asia/Shanghai

RUN apk update && apk add  --no-cache ffmpeg vnstat
COPY --from=builder /root/.local /usr/local
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY . /ytdlbot

CMD ["/usr/local/bin/supervisord", "-c" ,"/ytdlbot/supervisor.conf"]