# Noodle

Demo app for Let's Build 2020, Kolkata

## Setting up GCR

-  Create a service account with following permissions: `Storage Admin` `Storage Object Creator` `Viewer`
-  Create a JSON access token for the service account
- Authorize your docker client to push images

```bash
keyfile=<path to the downloaded json key>
docker login -u _json_key --password-stdin https://us.gcr.io < $keyfile
```
- Authorize your K8s cluster to pull images

```bash
keyfile=<path to the downloaded json key>
kubectl create secret docker-registry gcr-json-key \
  --docker-server=us.gcr.io \
  --docker-username=_json_key \
  --docker-password="$(cat $keyfile)" \
  --docker-email=admin@letsbuild.com

kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "gcr-json-key"}]}'
```
