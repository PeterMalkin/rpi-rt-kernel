all:
	rm -fr build
	mkdir -p build
	docker build -t custom-linux .
	docker run --privileged --name tmp-custom-linux custom-linux /raspios/build.sh
	docker cp tmp-custom-linux:/raspios/2021-05-07-raspios-buster-armhf-lite.img ./build/raspios.img
	docker rm tmp-custom-linux

#	docker run --privileged custom-linux /raspios/build.sh
#	docker cp custom-linux:/raspios/2021-05-07-raspios-buster-armhf-lite.img ./build/raspios.img

custom:
	docker run --rm --privileged -it custom-linux bash
