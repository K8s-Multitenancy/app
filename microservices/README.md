## How to Run and Migrate the Database Table

Follow these steps to set up and migrate the database:

### 1️⃣ Start the Docker Containers
Run the following command to build and start your microservices:

```sh
docker compose up --build
```

### 2️⃣ Find the Microservice Container Name
Once the containers are up, list the running containers:

```sh
docker ps
```

Look for the container name of your microservice application (e.g., `wishlist-microservice-1`).

### 3️⃣ Access the Microservice Container
Replace `<CONTAINER-NAME>` with your actual microservice container name and run:

```sh
docker exec -it <CONTAINER-NAME>-microservice-1 sh
```

### 4️⃣ Generate and Apply Database Migrations
Inside the container, execute the following commands sequentially:

```sh
npm run generate
npm run push
```

### 5️⃣ Verify the Database
To check if the tables have been created, connect to the database container:

```sh
docker exec -it <CONTAINER-NAME>-db-1 psql -U postgres
```

Then, run:

```sql
\dt
```

This will list all the tables. If the expected tables are present, your API is ready to be used! 🎉

