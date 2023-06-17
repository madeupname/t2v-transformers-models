# weaviate original image
docker run --gpus all \
  --env TRANSFORMERS_INFERENCE_API='http://localhost:8000' \
  --env QUERY_DEFAULTS_LIMIT=25 \
  --env AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED=true \
  --env PERSISTENCE_DATA_PATH='/var/lib/weaviate' \
  --env DEFAULT_VECTORIZER_MODULE='text2vec-transformers' \
  --env ENABLE_MODULES='text2vec-transformers' \
  --env CLUSTER_HOSTNAME='node1' \
  --env ENABLE_CUDA=1 \
  --env NVIDIA_VISIBLE_DEVICES='all' \
  --env AUTHORIZATION_ADMINLIST_ENABLED='false' \
  semitechnologies/weaviate:1.19.8

# Build
docker build -f weaviate.Dockerfile -t madeupname/weaviate-t2v .

# weaviate only - WON'T WORK - curl not installed
bacalhau docker run --download \
  --env QUERY_DEFAULTS_LIMIT=25 \
  --env AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED=true \
  --env PERSISTENCE_DATA_PATH='/var/lib/weaviate' \
  --env CLUSTER_HOSTNAME='node1' \
  --env ENABLE_CUDA=1 \
  --env NVIDIA_VISIBLE_DEVICES='all' \
  --env AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED='true' \
  --env AUTHORIZATION_ADMINLIST_ENABLED='false' \
  semitechnologies/weaviate:1.19.8 \
  -- bash -c '/bin/weaviate --host 0.0.0.0 --port 8080 --scheme http && curl http://localhost:8080/v1/schema > /outputs/schema.json'

# Docker run has a "--gpus all" option but bacalhau uses a singular version "--gpu 1"
bacalhau docker run --local --download --gpu 1 \
  --env TRANSFORMERS_INFERENCE_API='http://localhost:8000' \
  --env QUERY_DEFAULTS_LIMIT=25 \
  --env AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED=true \
  --env PERSISTENCE_DATA_PATH='/var/lib/weaviate' \
  --env CLUSTER_HOSTNAME='node1' \
  --env ENABLE_CUDA=1 \
  --env NVIDIA_VISIBLE_DEVICES='all' \
  --env AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED='true' \
  --env AUTHORIZATION_ADMINLIST_ENABLED='false' \
  weaviate-t2v \
  -- 'weaviate --host 0.0.0.0 --port 8080 --scheme http & uvicorn app:app --host 0.0.0.0 --port 8000 & sleep 5 && curl http://localhost:8080/v1/schema > /outputs/schema.json'

# custom
docker run \
  --env QUERY_DEFAULTS_LIMIT=25 \
  --env AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED=true \
  --env PERSISTENCE_DATA_PATH='/var/lib/weaviate' \
  --env CLUSTER_HOSTNAME='node1' \
  --env ENABLE_CUDA=1 \
  --env NVIDIA_VISIBLE_DEVICES='all' \
  --env AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED='true' \
  --env AUTHORIZATION_ADMINLIST_ENABLED='false' \
  semitechnologies/transformers-inference:sentence-transformers-multi-qa-mpnet-base-cos-v1 \
  -- 'uvicorn app:app --host 0.0.0.0 --port 8000'

# test wev8
curl http://localhost:8080/v1/schema

docker run --hostname=1910f4030486 --env=QUERY_DEFAULTS_LIMIT=25 --env=AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED=true --env=PERSISTENCE_DATA_PATH=C:/Program Files/Git/var/lib/weaviate --env=CLUSTER_HOSTNAME=node1 --env=ENABLE_CUDA=1 --env=NVIDIA_VISIBLE_DEVICES=all --env=AUTHORIZATION_ADMINLIST_ENABLED=false --env=PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin --env=LANG=C.UTF-8 --env=GPG_KEY=A035C8C19219BA821ECEA86B64E628F8D684696D --env=PYTHON_VERSION=3.10.11 --env=PYTHON_PIP_VERSION=23.0.1 --env=PYTHON_SETUPTOOLS_VERSION=65.5.1 --env=PYTHON_GET_PIP_URL=https://github.com/pypa/get-pip/raw/0d8570dc44796f4369b652222cf176b3db6ac70e/public/get-pip.py --env=PYTHON_GET_PIP_SHA256=96461deced5c2a487ddc65207ec5a9cffeca0d34e7af7ea1afc470ff0d746207 --workdir=/app --restart=no --runtime=runc -d weaviate-t2v