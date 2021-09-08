FROM ubuntu:20.04

COPY bloximages /

ENTRYPOINT ["/bloximages"]
