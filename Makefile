dev:
	docker-compose up --build -d
test:
	./test.sh
clean:
	docker-compose down --rmi all
