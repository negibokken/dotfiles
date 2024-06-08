gen:
	sudo certbot certonly --manual -d localhost.bokken.io --preferred-challenges dns

gen1:
	sudo certbot certonly --manual -d localhost1.bokken.io --preferred-challenges dns

gen2:
	sudo certbot certonly --manual -d localhost2.bokken.io --preferred-challenges dns

gen-dev:
	sudo certbot certonly --manual -d localhost.bokken.dev --preferred-challenges dns

mv:
	if ! [ -d "localhost.bokken.io" ]; then mkdir localhost.bokken.io; fi
	sudo cp /etc/letsencrypt/live/localhost.bokken.io/fullchain.pem localhost.bokken.io/
	sudo chown bokken localhost.bokken.io/fullchain.pem
	sudo cp /etc/letsencrypt/live/localhost.bokken.io/privkey.pem localhost.bokken.io/
	sudo chown bokken localhost.bokken.io/privkey.pem

mv1:
	if ! [ -d "localhost1.bokken.io" ]; then mkdir localhost1.bokken.io; fi
	sudo cp /etc/letsencrypt/live/localhost1.bokken.io/fullchain.pem localhost1.bokken.io/
	sudo chown bokken localhost1.bokken.io/fullchain.pem
	sudo cp /etc/letsencrypt/live/localhost1.bokken.io/privkey.pem localhost1.bokken.io/
	sudo chown bokken localhost1.bokken.io/privkey.pem

mv2:
	if ! [ -d "localhost2.bokken.io" ]; then mkdir localhost2.bokken.io; fi
	sudo cp /etc/letsencrypt/live/localhost2.bokken.io/fullchain.pem localhost2.bokken.io/
	sudo chown bokken localhost2.bokken.io/fullchain.pem
	sudo cp /etc/letsencrypt/live/localhost2.bokken.io/privkey.pem localhost2.bokken.io/
	sudo chown bokken localhost2.bokken.io/privkey.pem

mv-dev:
	if ! [ -d "localhost.bokken.dev" ]; then mkdir localhost.bokken.dev; fi
	sudo cp /etc/letsencrypt/live/localhost.bokken.dev/fullchain.pem localhost.bokken.dev/
	sudo chown bokken localhost.bokken.dev/fullchain.pem
	sudo cp /etc/letsencrypt/live/localhost.bokken.dev/privkey.pem localhost.bokken.dev/
	sudo chown bokken localhost.bokken.dev/privkey.pem

