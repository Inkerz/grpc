all:
	@docker build -t libgrpc .
	@docker run -v "${PWD}/:/artifacts" libgrpc

