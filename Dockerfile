FROM python:3.10-slim

WORKDIR /app

RUN apt-get update
RUN pip install --upgrade pip setuptools

COPY requirements.txt .
RUN pip3 install -r requirements.txt

ARG MODEL_NAME
COPY download.py .
RUN ./download.py

COPY . .
# install Weaviate
RUN apt-get curl
RUN curl https://github.com/weaviate/weaviate/releases/download/v1.19.8/weaviate-v1.19.8-linux-amd64.tar.gz \
    && tar -xzvf weaviate-v1.19.8-linux-amd64.tar.gz \
    && rm weaviate-v1.19.8-linux-amd64.tar.gz \
    && cp weaviate /bin/

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["uvicorn app:app --host 0.0.0.0 --port 8080"]
