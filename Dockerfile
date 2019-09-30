FROM ubuntu

RUN apt-get update && \
	apt-get install -y curl && \
	apt-get install -y jq

COPY mapping.json /
COPY init-mappings.sh /

ENTRYPOINT ["sh", "/init-mappings.sh"]
