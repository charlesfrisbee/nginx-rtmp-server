build-local:
	docker build -t rtmp .

run-local:
	docker run -d -p 1935:1935 -p 80:80 --name nginx-rtmp rtmp

build-linux:
	docker build --platform linux/amd64 -t rtmp .

push-dockerhub:
	docker tag rtmp cookershades/rtmp && \
	docker push cookershades/rtmp