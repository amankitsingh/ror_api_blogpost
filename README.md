
# Api BlogPosting 

Building an RoR API app that cover the following:

- User
    - Registration  
    - Authentification
    - Email confirmation
    - Recover account
- Article
    - Create
    - View one article + comments
    - View articles
    - Edit
    - Delete
- Comments
    - Create
    - View
- Categories
    - View all





### Tech Stack

- `Puma` as the web server
- `PostgreSQL` as the primary database and for Full Text Search
- `Redis` to store cached data
- `Sidekiq` for background workers




## Installing prerequisites
### Option 1
### Ruby
1. `Note`: MacOS ships with a version of Ruby, needed for various operating systems. To avoid causing an issue with your operating system you should use a version manager for Ruby.

If you don't already have a Ruby version manager, we highly recommend rbenv. This will allow you to have different versions running on a per project basis. The MacOS system version of Ruby will stay intact while giving you the ability to use the version needed for this Forem project. Please follow their installation guide.

2. With the Ruby version manager, install the Ruby version listed on our badge. 
(i.e. with rbenv: `rbenv install $(cat .ruby-version)`)

### PostgreSql
```bash
brew install postgres
```

### Redis
```bash
brew install redis
```

## Seeding database

The next step is to load the data

```bash
rails db:create db:migrate
````

Done, now you should be able to see the app on localhost:3000
```bash
rails server
```

### Option 2

Step 1. Install docker and docker-compose

[Docker install documentation](https://docs.docker.com/engine/install/)

Step 2. Run the below command

```bash
docker-compose up -d && docker-compose ps && docker-compose exec app bundle exec rake db:setup 
```
Note: This will install all the dependencies, run the docker-compose, create a database, seed the database.

Sample output
```bash
1. Creating Users.
    Admin User created
    Other User created 9999
2. Creating Categories.
    Category Created 3
3. Creating Articles.
    Article created 10000
4. Creating Tags.
    Tags created 5
```

Step 3. Check the logs
   
```bash
docker-compose logs
```


If you have reached hear, voila. you have done it.

`Enjoy the API!!!`

## API Reference

Below is the API collection reference link, refer it and enjoy the API.

[Postman collection documentation](https://documenter.getpostman.com/view/28161397/2s93z87PCa)




## Debugging

At any point in time, you wish to stop the execution and inspect the code run.

Step 1: Put `byebug` in the function/code area.

Step 2: Attach your terminal to the container
```bash
docker attach <container_id>
```
You may find your container_id by using: `docker container ls`

At this point, you should be able to see every input, output, and error from our running container.

You can always detach from this Docker process by entering the escape sequence: `Ctrl+P then Ctrl+Q`

Step 3: If you wish to access rails console or rails db from the terminal
```bash
docker-compose exec app rails console/db
```
