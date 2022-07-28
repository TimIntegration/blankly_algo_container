compose:
	export NB_USER=\$${USER}
	docker compose up -d && echo "use http://localhost:8899 or vscode connect to remote container, 'docker compose down' to end"
	# docker compose exec -it jupyterlab-service zsh
	docker exec -it cont-jupyter-lab zsh

setup:
	docker build -f jupyter.Dockerfile -t jupyter-lab-image .

run:
	export NB_USER=\$${USER}
	docker run --rm \
		-it --network host \
		-v "${PWD}"/notebooks:/home/\$${NB_USER}/work \
		jupyter-lab-image /bin/zsh -c "SHELL=/bin/zsh start.sh jupyter lab --ip='0.0.0.0' --no-browser --allow-root --ServerApp.password='' --notebook-dir=/home/\$${NB_USER}/work/"

clean:
	docker compose down
	# docker container stop cont-jupyter-lab
	# docker container rm cont-jupyter-lab
	# docker rmi jupyter-lab-image  ## to remove image
