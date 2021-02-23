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

1. Create a user account on [OnePost](https://api.getonepost.com/) to get your `secret_key`, which will be a required parameter for all requests.
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

In your web browser, navigate to the `url` value. You will be prompted to log in to your Twitter account, which will give your Twitter Developer Application access. Once you log in, you will be redirected back to the OnePost website. The URL to redirect the user to after a successful authorization can be customized by the `callback_url` value on the Provider record.

<img width="1000" alt="twitter-browser" src="https://user-images.githubusercontent.com/69064/108530520-aea1b100-72a3-11eb-94f8-123e9e256e44.png">

Once you've authorized your Twitter account, the Authorization record is available on the OnePost API. (Note: In addition to finding the `Authorization` record via the API, look for the `X-OnePost-Authorization-Id`, `X-OnePost-Provider-Id`, and `X-OnePost-Public-Key` header values in the request sent to your `callback_url`)

```ruby
client.get_authorizations
# => {"current_page"=>1, "per_page"=>30, "total_entries"=>1, "collection"=>[{"id"=>5, "created_at"=>"2021-02-19T10:18:36.384-05:00", "updated_at"=>"2021-02-19T10:18:36.384-05:00", "provider_id"=>5, "type"=>"Authorizations::Twitter", "consumer_key"=>"815...", "consumer_secret"=>"HLh...", "authorized_pages"=>[]}]}
```

When an Authorization is created in OnePost, OnePost will automatically create `AuthorizedPage` records for the `Authorization` that represent social pages the user is allowed to post to. In the case of Twitter, this will be a single `AuthorizedPage`. Let's use the API to find our `AuthorizedPage` record:

```ruby
client.get_authorized_pages
# => {"current_page"=>1, "per_page"=>30, "total_entries"=>1, "collection"=>[{"id"=>6, "authorization_id"=>5, "name"=>"1bertlol", "service_id"=>"81534513", "type"=>"AuthorizedPages::Twitter", "info"=>{...}]}
```

Now that we have an `AuthorizedPage` id, we are ready to create our first post!

```ruby
client.create_post(body: {
  post: {
    "body": "My first post using the OnePost Ruby Gem https://github.com/akdarrah/onepost-gem",
    "authorized_page_ids": [6],
    "image_url": "https://img1.looper.com/img/gallery/the-real-reason-futurama-was-canceled/intro-1567514049.jpg"
  }
})
# => {"id"=>7, "body"=>"My first post using the OnePost Ruby Gem https://github.com/akdarrah/onepost-gem", "created_at"=>"2021-02-19T10:49:37.633-05:00", "updated_at"=>"2021-02-19T10:49:37.656-05:00", "state"=>"draft", "publish_at"=>nil, "authorized_page_ids"=>[6], "image_url"=>"https://onepost-aws-assets.s3.amazonaws.com/g5smw81h3oudjpri1sj66dp...", "social_posts"=>[{"id"=>7, "post_id"=>7, "created_at"=>"2021-02-19T10:49:37.642-05:00", "updated_at"=>"2021-02-19T10:49:37.642-05:00", "type"=>"SocialPosts::Twitter", "state"=>"unsent", "authorized_page_id"=>6}]}
```

Posts are created in a "draft" state and can be updated until it is published. Notice that a `SocialPost` record is automatically created for the AuthorizedPage you provided. As you alter the `authorized_page_ids`, these `SocialPost` records will be automatically created or destroyed for each page you are posting to.

(*Note:* Do you need to upload your image? View the test case in [this commit](https://github.com/akdarrah/onepost-gem/commit/3b4ee062d68141404e09843293e16f313a46dc18) as an example of how to do that.)

Additionally, you can use the `publish_at` field to specify a time for OnePost to automatically publish the post. Since we didn't schedule this post to be published automatically, let's publish it using the API:

```ruby
client.publish_post(7)
# => {"id"=>7, "body"=>"My first post using the OnePost Ruby Gem https://github.com/akdarrah/onepost-gem", "created_at"=>"2021-02-19T10:49:37.633-05:00", "updated_at"=>"2021-02-19T10:56:23.977-05:00", "state"=>"publishing", "publish_at"=>nil, "authorized_page_ids"=>[6], "image_url"=>"https://onepost-aws-assets.s3.amazonaws.com/g5smw81h3oud...", "social_posts"=>[{"id"=>7, "post_id"=>7, "created_at"=>"2021-02-19T10:49:37.642-05:00", "updated_at"=>"2021-02-19T10:49:37.642-05:00", "type"=>"SocialPosts::Twitter", "state"=>"unsent", "authorized_page_id"=>6}]}
```

A few moments later, and you will see your published Tweet!

<img width="668" alt="published-tweet" src="https://user-images.githubusercontent.com/69064/108529332-5cac5b80-72a2-11eb-8166-9565d2d35f72.png">

Once published, OnePost will track the performance of your `SocialPost` over time. Simply get the SocialPost record to see the most up-to-date data available.

```ruby
client.get_social_post(7)
# => {"id"=>7, "post_id"=>7, "created_at"=>"2021-02-19T10:49:37.642-05:00", "updated_at"=>"2021-02-19T10:56:24.019-05:00", "type"=>"SocialPosts::Twitter", "state"=>"sent", "authorized_page_id"=>6, "service_data"=>{"id"=>1362793165137313792, "geo"=>nil, "lang"=>"en", "text"=>"My first post using the OnePost Ruby Gem https://t.co/K0nlM9qLWx https://t.co/owC53ZJuDO", "user"=>{"id"=>81534513, "url"=>"https://t.co/23KYmkQZJB", "lang"=>nil, "name"=>"Adam Darrah", "id_str"=>"81534513", "entities"=>{"url"=>{"urls"=>[{"url"=>"https://t.co/23KYmkQZJB", "indices"=>[0, 23], "display_url"=>"dropkiq.com", "expanded_url"=>"https://www.dropkiq.com/"}]}, "description"=>{"urls"=>[]}}, "location"=>"Keystone, Indiana", "verified"=>false, "following"=>false, "protected"=>false, "time_zone"=>nil, "created_at"=>"Sun Oct 11 06:36:24 +0000 2009", "utc_offset"=>nil, "description"=>"I like futurama, websites, and code. Founder of Dropkiq 🥊", "geo_enabled"=>false, "screen_name"=>"1bertlol", "listed_count"=>4, "friends_count"=>266, "is_translator"=>false, "notifications"=>false, "statuses_count"=>1693, "default_profile"=>false, "followers_count"=>175, "translator_type"=>"none", "favourites_count"=>771, "profile_image_url"=>"http://pbs.twimg.com/profile_images/1266163001532518400/K41HOU0Y_normal.jpg", "profile_link_color"=>"0084B4", "profile_text_color"=>"333333", "follow_request_sent"=>false, "contributors_enabled"=>false, "has_extended_profile"=>false, "default_profile_image"=>false, "is_translation_enabled"=>false, "profile_background_tile"=>true, "profile_image_url_https"=>"https://pbs.twimg.com/profile_images/1266163001532518400/K41HOU0Y_normal.jpg", "profile_background_color"=>"C0DEED", "profile_sidebar_fill_color"=>"DDEEF6", "profile_background_image_url"=>"http://abs.twimg.com/images/themes/theme18/bg.gif", "profile_sidebar_border_color"=>"000000", "profile_use_background_image"=>true, "profile_background_image_url_https"=>"https://abs.twimg.com/images/themes/theme18/bg.gif"}, "place"=>nil, "id_str"=>"1362793165137313792", "source"=>"<a href=\"https://www.getonepost.com/\" rel=\"nofollow\">GetOnepost</a>", "entities"=>{"urls"=>[{"url"=>"https://t.co/K0nlM9qLWx", "indices"=>[41, 64], "display_url"=>"github.com/akdarrah/onepo…", "expanded_url"=>"https://github.com/akdarrah/onepost-gem"}], "media"=>[{"id"=>1362793163627384833, "url"=>"https://t.co/owC53ZJuDO", "type"=>"photo", "sizes"=>{"large"=>{"h"=>438, "w"=>780, "resize"=>"fit"}, "small"=>{"h"=>382, "w"=>680, "resize"=>"fit"}, "thumb"=>{"h"=>150, "w"=>150, "resize"=>"crop"}, "medium"=>{"h"=>438, "w"=>780, "resize"=>"fit"}}, "id_str"=>"1362793163627384833", "indices"=>[65, 88], "media_url"=>"http://pbs.twimg.com/media/EumdKXRXUAETYvz.jpg", "display_url"=>"pic.twitter.com/owC53ZJuDO", "expanded_url"=>"https://twitter.com/1bertlol/status/1362793165137313792/photo/1", "media_url_https"=>"https://pbs.twimg.com/media/EumdKXRXUAETYvz.jpg"}], "symbols"=>[], "hashtags"=>[], "user_mentions"=>[]}, "favorited"=>false, "retweeted"=>false, "truncated"=>false, "created_at"=>"Fri Feb 19 15:56:24 +0000 2021", "coordinates"=>nil, "contributors"=>nil, "retweet_count"=>0, "favorite_count"=>1, "is_quote_status"=>false, "extended_entities"=>{"media"=>[{"id"=>1362793163627384833, "url"=>"https://t.co/owC53ZJuDO", "type"=>"photo", "sizes"=>{"large"=>{"h"=>438, "w"=>780, "resize"=>"fit"}, "small"=>{"h"=>382, "w"=>680, "resize"=>"fit"}, "thumb"=>{"h"=>150, "w"=>150, "resize"=>"crop"}, "medium"=>{"h"=>438, "w"=>780, "resize"=>"fit"}}, "id_str"=>"1362793163627384833", "indices"=>[65, 88], "media_url"=>"http://pbs.twimg.com/media/EumdKXRXUAETYvz.jpg", "display_url"=>"pic.twitter.com/owC53ZJuDO", "expanded_url"=>"https://twitter.com/1bertlol/status/1362793165137313792/photo/1", "media_url_https"=>"https://pbs.twimg.com/media/EumdKXRXUAETYvz.jpg"}]}, "possibly_sensitive"=>false, "in_reply_to_user_id"=>nil, "in_reply_to_status_id"=>nil, "in_reply_to_screen_name"=>nil, "in_reply_to_user_id_str"=>nil, "in_reply_to_status_id_str"=>nil, "possibly_sensitive_appealable"=>false}, "service_data_updated_at"=>"2021-02-19T11:00:18.465-05:00"}
```

### Webhooks

You may have noticed while reading over the documentation that several key records are created for you automatically, such as `AuthorizedPage` records. This can be problematic in the event that you go to look for your records and they haven't been created yet.

Luckily, OnePost solves this need by providing a Webhook system. This system allows you to specify an HTTP endpoint in your application for OnePost to send `POST` requests to. When key events happen in the OnePost system, the event data will be sent to your endpoint where your application can do the necessary processing without polling for updates.

To test this system, we can get a new test endpoint quickly using [Webhook.site](https://webhook.site/). Navigating to this page will give you a "unique URL" that you can use as your test endpoint. Let's use the Gem to register this endpoint:

```ruby
client.create_webhook(body:{
  webhook: {
    endpoint_url: "https://webhook.site/3f338283-10b0-492a-a97e-d891d538ab79"
  }
})
# => {"id"=>4, "endpoint_url"=>"https://webhook.site/3f338283-10b0-492a-a97e-d891d538ab79", "created_at"=>"2021-02-19T11:45:15.652-05:00", "updated_at"=>"2021-02-19T11:45:15.652-05:00"}
```

Now that we have our endpoint, let's create a test event to make sure it's working.

```ruby
client.create_test_event
# => {"id"=>16, "name"=>"events.test", "data"=>{"object"=>{"ping"=>"pong"}}, "created_at"=>"2021-02-19T11:48:26.546-05:00", "updated_at"=>"2021-02-19T11:48:26.546-05:00", "webhook_attempts"=>[{"id"=>11, "state"=>"new", "created_at"=>"2021-02-19T11:48:26.561-05:00", "updated_at"=>"2021-02-19T11:48:26.561-05:00", "number_of_attempted_requests"=>0, "webhook"=>{"id"=>4, "endpoint_url"=>"https://webhook.site/3f338283-10b0-492a-a97e-d891d538ab79", "created_at"=>"2021-02-19T11:45:15.652-05:00", "updated_at"=>"2021-02-19T11:45:15.652-05:00"}}]}
```

You should now see your test event appear in Webhook.site.

<img width="1275" alt="success" src="https://user-images.githubusercontent.com/69064/108535592-7dc47a80-72a9-11eb-8d21-17885442570e.png">

OnePost will continue to attempt to send the request to notify your application of events using an exponential backoff algorithm in the case we receive a non-200 response.

At the time of writing, OnePost has just a handful of events (check back later for more):

Name | Description
------------ | -------------
events.test | Created manually by the API user to test Webhook endpoints are configured correctly
authorized_page.created | Created automatically when a new AuthorizedPage is created (after an Authorization is created)
social_post.updated | Created automatically for each SocialPost after a Post has been published. Listen for this event if you want to track performance (such as number of likes, retweets, etc).

### Reference

For full documentation, please use the [OnePost RapidAPI Page](https://rapidapi.com/onepost/api/onepost1) as the ultimate source of truth. Additionally, the tests included in this gem are a great way to see what is possible using the Gem:

Resource | Test File
------------ | -------------
Providers | [Provider Tests](https://github.com/akdarrah/onepost-gem/blob/master/test/onepost_provider_test.rb)
Authorizations | [Authorization Tests](https://github.com/akdarrah/onepost-gem/blob/master/test/onepost_authorization_test.rb)
Authorized Pages | [Authorized Page Tests](https://github.com/akdarrah/onepost-gem/blob/master/test/onepost_authorized_page_test.rb)
Posts | [Post Tests](https://github.com/akdarrah/onepost-gem/blob/master/test/onepost_post_test.rb)
Social Posts | [Social Post Tests](https://github.com/akdarrah/onepost-gem/blob/master/test/onepost_social_post_test.rb)
Webhooks | [Webhook Tests](https://github.com/akdarrah/onepost-gem/blob/master/test/onepost_webhook_test.rb)
Events | [Event Tests](https://github.com/akdarrah/onepost-gem/blob/master/test/onepost_event_test.rb)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/onepost. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/onepost/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Onepost project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/onepost/blob/master/CODE_OF_CONDUCT.md).
