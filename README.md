# 2048-game 🚀 🚀

```markdown
# 2048 Game Dockerfile

This Dockerfile sets up a simple web server running the popular 2048 game by Gabriele Cirulli. It uses Nginx to serve the game as a static website.

## Building the Docker Image

To build the Docker image for the 2048 game, follow these steps:

1. Make sure you have Docker installed on your local machine.

2. Create a directory to store your Dockerfile and any necessary files, and navigate to that directory.

3. Create a file named `Dockerfile` and copy the provided Dockerfile contents into it.

4. Open a terminal in the same directory where your Dockerfile is located.

5. Run the following command to build the Docker image:

   ```shell
   docker build -t 2048-game .
   ```

   This command will build the Docker image with the tag `2048-game`. You can replace `2048-game` with your preferred image name.

## Running the Docker Container

Once you've built the Docker image, you can run a Docker container to play the 2048 game locally. Use the following command:

```shell
docker run -d -p 8080:80 --name 2048-game-container 2048-game
```

- `-d` runs the container in detached mode.
- `-p 8080:80` maps port 8080 on your host machine to port 80 in the container
- `--name 2048-game-container` assigns the name "2048-game-container" to the container.

The 2048 game will be accessible at http://localhost:8080 in your web browser.

## Playing the Game

Open a web browser and navigate to http://localhost:8080 to play the 2048 game.

## Stopping and Removing the Container

To stop and remove the Docker container when you're done playing, use the following commands:

```shell
docker stop 2048-game-container
docker rm 2048-game-container
```

This will stop and remove the container named "2048-game-container."

Enjoy playing the 2048 game locally with Docker!
