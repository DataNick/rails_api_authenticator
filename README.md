# Technical Challenge - Authentication API for internal services to create and authenticate users

## Note on testing the API
* This application was verified using the Postman API platform using the endpoint 'http://localhost:3000/api/v1/'
* The POST actions (login, users#create), listed in routes, take username and password
* Once the user has been created and logged, the GET /auth_verification is used to verify the authenticity of the user

## Set up
* Bundle install
* Run rails server in one terminal window.
* In another terminal window, run redis-server
* Tests are run using rspec

## Endpoints
* Create new user in redis datastore: POST http://localhost:3000/api/v1/users data: {username: string, password: string}
* Login with credentials: POST http://localhost:3000/api/v1/login data: {username: string, password: string}
* Once logged in, verify without using login credentials (the cookie has the encrypted username that is compared on subsequent requests): GET http://localhost:3000/api/v1/auth_verification
* Delete cookie value and log out of application: DELETE http://localhost:3000/api/v1/logout

## Design Decisions
* Since redis is the datastore being used, there was no need to use ActiveRecord and create tables.
* Redis is set up in initializers/redis.rb and the store is called $redis_credentials.
* In the user model, I tried to recreate some ActiveRecord functionality. I also added password formatting to ensure a level of secure passwords is kept in the system.
* ActiveModel::SecurePassword is helpful when I need to authenticate a user with the submitted password.
* ActiveModel::AttributeAssignment and ActiveModel::Serialization are used for assigning and reading attributes.
* ActiveModel::Validations were used to validate username and password length and presence. I ran into an issue with uniqueness -- Unknown validator: 'UniquenessValidator'. It seems to be related to ActiveRecord. I assume it does a shallow scan on the database to search the submitted name across the entire store.
As a work around, before a user is saved to redis, a search on the database for the username is done and if found, notifies the user of the uniqueness issue.
* There's a need to query and save to the redis store. I moved this functionality to a separate module and included it in the User model.
* For the controllers, initially I had users and sessions controller but realized since there would be no sessions table there's no need for the sessions controller. The authentication controller handles the login and logout actions.
* The application controller handles authentication calls across the different actions. This adds a level of security and makes sure unauthenticated users aren't allowed access.

* As a value to be stored for subsequent requests, the username is being encrypted on the server side. I built the encrypt/decrypt behaviour inside the EncryptionHelper class. In the application_controller, the encrypted value is decrypted on subsequent requests, a search for the decrypted username in redis is done and, if found, returns true for the authenticated user. The authenticate action is a before_action for all actions except the create and login actions to ensure only authenticated users are allowed access.

* A note on the SECRET_KEY value stored in the environment_variable.rb. Normally private keys would be stored in a secure param store. I've included it in this repo to show how the encryption is being processed using a 32-bit key value.

## Next steps:
* Remove username as the hashed value being stored across request. Eventually build out a token system.
* Set up a better system to store usernames - currently just downcasing for ease of searching and comparing new user credentials. Add ability to store names like JohnT or Jason Able. Users should expect to see the data they submitted in the format in which it was submitted.
* ActiveRecord, which I wasn't using, uses the Uniqueness validator check and so it's not accessible for Redis datastore. There should be a way to extract the keys (usernames) and do a comparison for new keys to be inserted. Time and memory requirements will need to be determined.
* Build out error message functionality as the login requirements change. Possibly into a separate module or build out RedisRecord module.
* A more persistent database depending on the service needs.
* Add password confirmation to ensure user won't make a mistake on subsequent logins.
* Add forgot password functionality to ensure users will be able to access their account by changing passwords.
* Handle cases of suspicious behaviour (i.e. bots trying brute force attempts to login)
* Add testing to RedisRecord. Handle mocking redis store requests in rspec

## Testing
Tests for authentication and user controllers have been created and ensure functionality of all the crucial parts of the system are covered.
