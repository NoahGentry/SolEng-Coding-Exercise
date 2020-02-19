# SolEng-Coding-Exercise

This script offers several commands that allow the user to create, read, update, or delete products in the CS Coding Exercise Salsify account.

Setup:

Clone this repository and navigate to the folder in your terminal.

Run the command `bundle install` to install the necessary gems.

Lastly, add a file called `.env` to this directory. Within that file, add the following text, swapping out the *** placeholders *** for the necessary credentials:

FTPUSER = *** FTP USER NAME ***
FTPPASS = *** FTP Password ***
SALSIFY_API_KEY = *** Salsify API Key ***

Usage:

From within the script's directory, you may run the following rake commands:

`rake create_products`

- *Note:* This command will fetch data from the "products.xml" file in the cs-coding-example account on the Salsify FTP. This data is parsed and transformed into a json payload that is sent via a post request to the Salsify API. A successful call will output the response code 201 to the terminal along with the JSON payload returned from Salsify.

`rake update_products`

- *Note:* Similar to the create_products command, this command fetches and parses data from the "products.xml" file in the cs-coding-example account and sends it via a put request. A successful call will output the response code 204 to the terminal.

`rake get_products[*comma-separated list of product ids*]`

- This command takes a parameter, which is a comma-separated list of product ids to fetch information for. This is passed in square brackets at the end of the get_products command. A successful call will output the JSON payload returned from Salsify to the terminal.

`rake delete_products[*comma-separated list of product ids*]`

- This command also takes a parameter, in this case a comma-separated list of product ids that should be deleted from the account. A successful call will output the response code 204 to the terminal.

Questions:

1) This script uses a library called rake to define a series of "tasks" that can be executed from the command line by calling `rake *task name*`. There are tasks defined to perform a number of operations using the Salsify API. These tasks are defined in the file `Rakefile`. The logic for connecting to the FTP server, parsing the products.xml file, and making calls to the Salsify API was separated into 3 different modules, each in their own file in the "helpers" folder.

The "create_products" and "update_products" tasks both specify the fetch_data task as a pre-requisite, which means that the fetch_data task is run prior to either of these tasks. The fetch_data task handles connecting to the FTP server and downloading the product data file. I made use of the built-in `Net/FTP` module that comes with ruby to connect to the FTP server, and stored the FTP credentials as environment variables using the Dotenv library. For making calls to the Salsify API I used the rest-client gem, and for parsing the XML file I made use of the gem Nokogiri.

2) To complete the project I mainly made use of of the Salsify API documentation, ruby-doc.org, and the documentation for the gems that I made use of. I also consulted a few stackoverflow threads and did some miscellaneous googling, largely to find resolutions to common errors.

3) I made use of six third-party libraries, rest-client, Nokogiri, Require All, Dotenv, Rake, and Bundler

rest-client - This library was recommended in the Salsify Developer documentation in an example. It looked like a very straightforward library to use and I had access to relevant examples written using that library so it seemed like a no-brainer.

Nokogiri - I was familiar with this library already because it is a dependency for a gem that we use to parse Excel files. When I saw that I would need to parse an XML file it was the first thing that came to mind. There is also a dedicated website for the gem with great documentation.

Require All - I was already familiar with this gem as a utility for making it easier to require multiple files. This gem turns several lines of require statements into a single line which is easier to read.

Dotenv - This library seemed like a good way to store sensitive credentials while reducing the risk of them being accidentally committed to a public repository. The credentials are stored in a file called `.env` (as detailed in the setup section), and are accessible from within the script as environment variables. By also adding `.env` into the `.gitignore` file, it ensures that the credentials are never pushed to Github. This does mean that each user has to manually create the `.env` file the first time they use the script, but this is a one time setup.

Rake - This is another library that I was familiar with already from tools that I interact with on my current team. In some ways it was force of habit to include (I really prefer running `rake *something*` in the terminal instead of `ruby *something*.rb` for some reason), but I do think it simplifies some things, like creating the fetch_data pre-requisite task or allowing the user to pass in parameters with a cleaner syntax than with command line arguments.

Bundler - This library is used to provide an easy way for someone to install all of the dependencies for this project using the `bundle install` command.

4) Over 3 different sessions I spent roughly 5 hours on this project. If I had unlimited additional time, I would focus on making this script more accessible to an end-user by creating some other way to trigger this script than running it manually from the command line, and providing more feedback to the user. Additionally, I would add some safeguards against some errors that would likely be encountered in the wild.

To simplify running the script, since this process relies on pulling data from an XML file on an FTP server the most likely paths would be setting this script to run on a schedule (i.e. pull data from the server nightly and update products) or having it run in response to an Exavault webhook (i.e. whenever someone drops a new file on the server, pull data from that file and update products). I would explore a scheduled update first as that would be easier to implement and solve a wide range of use-cases, but certain users might not be satisfied with that solution so I would likely explore other ideas as well over time.

To provide better feedback, in the short-term I would look into providing email feedback after each attempted update letting the user know whether the update was successful. In the long-term, I could see some value in adding some more information to this email, such as a summary of what changes were made, but I would consider this to be low priority since there is already an activity history of changes to each product within Salsify. Depending on user feedback I could see this becoming a higher priority though.

One likely scenario I see coming up is for someone to add data for a product that doesn't exist within Salsify to the XML file on the FTP. One way to handle for this would be to take those SKUs and create them as new products instead, while updating the ones that already exist. I could see this solution also having some potentially negative drawbacks though if someone were to unintentionally create a large number of new products, so if this were implemented it would certainly become a part of the email feedback to highlight what new products were created.

5) My biggest criticism right now would be that I do not handle errors well at all. There are a lot of very predictable things that could go wrong here, and I think a more complete project would address those issues and provide actionable feedback to the user instead of just failing and requiring a developer to look at the terminal output to figure out what went wrong.

In terms of refactoring, I think there's an opportunity for a little bit more simplification in the ApiHelpers module. For the POST and PUT actions I used the RestClient.post and RestClient.put methods, but I ended up using the RestClient.execute method for the DELETE and GET actions, as the built-in methods for those actions don't allow for passing a payload as a parameter. Looking back at the code now, I could write a generic method that accepts the HTTP verb and the JSON payload as a parameter.

Lastly, I would include some code comments. Looking back at the code now I can see a couple of places where a small note would add a lot of clarity. For instance, the parse_product_data method in the XMLHelpers module could have used a note to explain the XML structure that we're expecting to see, so someone could understand why it was parsed that way.
