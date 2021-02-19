# Onepost

OnePost is social media management infrastructure for the internet. Companies use our API to create, post, and manage their social presence via programmatic communication. You can think of it like a headless Hootsuite built for developers.

Use OnePost to quickly integrate your application with Twitter, Facebook, and Instagram.

1. Start by registering for the developer applications that you'll need for your application, such as Twitter and Facebook.
2. Then, use OnePost to allow your application's users to log in to each service through their web browser, thereby giving your application permission to post on their behalf.
3. Finally, post to one (or many) social pages owned by the user with a single API call. Use OnePost to track the performance of each post over time.

Learn more at [https://www.getonepost.com/](https://www.getonepost.com/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'onepost'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install onepost

## Usage

### Obtain Credentials

To use the OnePost Ruby Gem, you must first obtain the required credentials:

1. Create a user account on [GetOnePost](https://api.getonepost.com/) to get your `secret_key`, which will be a required parameter for all requests.
2. OnePost uses the RapidAPI infrastructure to manage API requests. You will need to find your `X-RapidAPI-Key` value from [RapidAPI](https://rapidapi.com/onepost/api/onepost1).

### Create Developer Applications

Now that you have the required credentials, the next step is to register a developer application with Providers you would like to integrate with, such as Twitter and Facebook. For the purpose of these instructions, we'll be using Twitter. Use the [Twitter Developer Portal](https://developer.twitter.com/en) to register a new Developer Application. Once you have created your developer application, take note of your `API key` and `API secret key`.

### Using the OnePost Ruby Gem

All interactions with the OnePost API is done using a `Onepost::Client` instance. You can create your instance by passing your credentials:

```ruby
client = Onepost::Client.new(
  secret_key: "sk-7a0...",
  rapid_api_key: "9d0..."
)
```

Once we have a `Onepost::Client` instance, let's use the instance to create a Provider record for our Twitter Developer Application. Provider records are used to store the `API key` and `API secret key` from any social provider, such as Twitter, Facebook, etc.

```ruby
client.create_provider(body: {
  provider: {
    type: "Providers::Twitter",
    api_key: "edw...",
    api_secret_key: "XVI..."
  }
})
# => {"id"=>5, "type"=>"Providers::Twitter", "api_key"=>"edw...", "created_at"=>"2021-02-19T10:04:23.692-05:00", "updated_at"=>"2021-02-19T10:04:23.692-05:00", "callback_url"=>nil, "api_secret_key"=>"XVI..."}
```

Now that we have created a Provider record, we can use our client to read the data back.

```ruby
client.get_provider(5)
# => {"id"=>5, "type"=>"Providers::Twitter", "api_key"=>"edw...", "created_at"=>"2021-02-19T10:04:23.692-05:00", "updated_at"=>"2021-02-19T10:04:23.692-05:00", "callback_url"=>nil, "api_secret_key"=>"XVI..."}
```

Or you can fetch all providers registered to the API user.

```ruby
client.get_providers
# => {"current_page"=>1, "per_page"=>30, "total_entries"=>1, "collection"=>[{"id"=>5, "type"=>"Providers::Twitter", "api_key"=>"edw...", "created_at"=>"2021-02-19T10:04:23.692-05:00", "updated_at"=>"2021-02-19T10:04:23.692-05:00", "callback_url"=>nil, "api_secret_key"=>"XVI..."}]}
```

As you can see, the OnePost API will paginate results for endpoints that can return many records. You can pass additional parameters to your API call to navigate your results (`per_page` has a maximum value of 100):

```ruby
client.get_providers(query: {page: 2, per_page: 50})
=> {"current_page"=>2, "per_page"=>50, "total_entries"=>2, "collection"=>[]}
```

Now that we have registered our Twitter Developer Application with OnePost by creating a `Provider` record, the next step is for us to authorize a Twitter account by creating an `Authorization` record. This is a step that must be done in the web browser, but you can get instructions by using the `create_authorization` API endpoint.

```ruby
client.create_authorization(body: {authorization: {provider_id: 5}})
# => {"instructions"=>["Perform the following steps to complete the authorization process:", "  1. In your web browser, navigate to the provided URL.", "  2. Sign in to Twitter.", "  3. You will be redirected back to the original application."], "url"=>"https://api.getonepost.com/users/auth/twitter?provider_id=5&public_key=pk-7a0..."}
```

In your web browser, navigate to the `url` value. You will be prompted to log in to your Twitter account to give your Twitter Developer Application access to your Twitter account. Once you log in, you will be redirected back to the OnePost website. The URL to redirect the user after a successful authorization can be customized by the `callback_url` value on the Provider record.

Once you've authorized your Twitter account, the Authorization record is available on the OnePost API. (Note: In addition to finding the `Authorization` record via the API, look for the `X-OnePost-Authorization-Id`, `X-OnePost-Provider-Id`, and `X-OnePost-Public-Key` header values in the request sent to your `callback_url`)

```ruby
client.get_authorizations
# => {"current_page"=>1, "per_page"=>30, "total_entries"=>1, "collection"=>[{"id"=>5, "created_at"=>"2021-02-19T10:18:36.384-05:00", "updated_at"=>"2021-02-19T10:18:36.384-05:00", "provider_id"=>5, "type"=>"Authorizations::Twitter", "consumer_key"=>"815...", "consumer_secret"=>"HLh...", "authorized_pages"=>[]}]}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/onepost. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/onepost/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Onepost project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/onepost/blob/master/CODE_OF_CONDUCT.md).
