# Setting up MAD Club Web

Setting up the Vapor framework is fairly easy, however there are a few requirements into setting this up.

## First, Why Swift and Vapor?
I primarily chose this, because we will be learning `Swift` in our 2nd year, so it makes it easy to pick up the syntax, and we'd only have to learn about the framework. In addition, it's one of the best modern languages out there. Its fast, easy, and readable code makes it easy for newcomers to join in and participate.

Another thing is that this will be a good real-life example of how stacks work in a real-life scenario. Most small business will prefer a monolithic approach (which is what ours is) as to a microservice (where the API is separated, alongside with the web, android and iOS).

## Current Swift Version
- Swift 4.0

## Requirements
- Linux (Ubuntu) and Mac OS are only supported. Unforunately, Windows is not yet supported.
- Swift 4.0
- Access to Terminal. This is critical. Some of the work we will need to do involves using the terminal
- PostgreSQL (Homebrew/package for Ubuntu)

## Installing PostgreSQL
### Ubuntu
1. Installing on Ubuntu requires you to use the `Package Manager` from Ubuntu. There are several tutorials out there.
1. Here's a [tutorial regarding on how to install PostgreSQL](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-16-04)
### MacOS
#### Homebrew Version (recommended):
1. Installing on MacOS requires you to use Homebrew. [https://brew.sh/](https://brew.sh/)
1. Once done, installing PostgreSQL is simple. Open up Terminal and do `brew install postgresql`, and you should be set-up.
1. Once done, do `createdb ``whoami`` `. This creates a database based on your name.
1. Run `psql` on the terminal, and you should see that you are able to connect.
1. By default, your username is your username on the terminal, and your password is blank. You can set this up later, as it's your development environment, so it shouldn't matter too much.
#### GUI Version:
1. You can install the GUI version here: [https://postgresapp.com/](https://postgresapp.com/).

## Setting up your Environment
1. Clone this repo into your directory.
1. For Mac:
	1.  we cannot open up the xcode project, by simply clicking `.xcodeproj`. We will need to generate a XCode workspace. To do this, we will need to open our terminal, and then `cd` into our directory. Run the command, `vapor xcode -y` to generate a xcode workspace.
	1. It should open up XCode, and once you have that, set the target to `Run`. This will allow us to run our vapor server on XCode, and print out any logs or info on the console as well.
	1. You can now run/compile your vapor project on XCode, the way it is. You may also do it on terminal, however if you were to do it on terminal, you will have to use `vapor build` to compile, and  `vapor run` to run your project.
		1. Sometimes you will have to use terminal commands like this, such as when preparing your database on PostgreSQL. You cannot set it on postgresql.
1. For Ubuntu:
	1. You will need to install Swift. I'd recommend to install `swiftenv`. The git repo can be found here: [https://github.com/kylef/swiftenv](https://github.com/kylef/swiftenv)
	1. You may use any source editor you want. My recommendation is either Visual Studio Code, or Sublime Text, but it's your choice. Your commands are a bit different, by all your builds will work through terminal.
	1. To build your vapor project, you will need to run `vapor build`. To run your vapor project, it's `vapor run`.

## Updating and Fetching Dependencies
1. Sometimes libraries update, and we may need to update them. If there is a case we do need to update, then the following steps are simple.
1. First, you want to fetch the dependencies. To fetch, do `vapor fetch` on the project directory.
1. Afterwards, do `vapor update`. It may take some time.
1. Once done, do `vapor xcode -y` to regenerate the xcode project file contents.

## Contributing
[Please see here](https://github.com/MAD-Club/web/blob/master/CONTRIBUTING.md)

## Updated

**Last Updated:** Nov. 5 2017
