build-local:
	docker build -t rtmp .

run-local:
	docker run -d -p 1935:1935 -p 8080:8080 --name nginx-rtmp rtmp
