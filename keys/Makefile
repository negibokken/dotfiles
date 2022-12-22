gen1:
	sudo certbot certonly --manual -d localhost.bokken.io --preferred-challenges dns

gen2:
	sudo certbot certonly --manual -d localhost2.bokken.io --preferred-challenges dns

mv1:
	sudo cp /etc/letsencrypt/live/localhost.bokken.io/fullchain.pem .
	sudo chown bokken fullchain.pem
	sudo cp /etc/letsencrypt/live/localhost.bokken.io/privkey.pem .
	sudo chown bokken privkey.pem

mv2:
	sudo cp /etc/letsencrypt/live/localhost2.bokken.io/fullchain.pem localhost2.bokken.io/
	sudo chown bokken localhost2.bokken.io/fullchain.pem
	sudo cp /etc/letsencrypt/live/localhost2.bokken.io/privkey.pem localhost2.bokken.io/
	sudo chown bokken localhost2.bokken.io/privkey.pem
