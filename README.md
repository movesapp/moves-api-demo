This is a sample app that demostrates how to connect to [Moves](https://moves-app.com).

Make sure you have [Bundler](http://gembundler.com/) installed. Then install the dependencies with `bundle install` on the command line.

To run the app, obtain your API credentials then issue these commands:

	export MOVES_CLIENT_ID=<your client id>
	export MOVES_CLIENT_SECRET=<your client secret>
	rackup -p 4567
