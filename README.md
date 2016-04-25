[![General Assembly Logo](https://camo.githubusercontent.com/1a91b05b8f4d44b5bbfb83abac2b0996d8e26c92/687474703a2f2f692e696d6775722e636f6d2f6b6538555354712e706e67)](https://generalassemb.ly/education/web-development-immersive)

# Iterative Development of Rails APIs

## Prerequisites

-   [ga-wdi-boston/rails-api-bdd](https://github.com/ga-wdi-boston/rails-api-bdd)
-   [ga-wdi-boston/rails-activerecord-one-to-many](https://github.com/ga-wdi-boston/rails-activerecord-one-to-many)
-   [ga-wdi-boston/rails-activerecord-many-to-many](https://github.com/ga-wdi-boston/rails-activerecord-many-to-many)

## Objectives

By the end of this lesson, students should be able to:

-   Explain the value of iterative development.
-   Write request specs for associations.
-   Write model unit specs for associations.
-   Write model unit specs for validations.

## Preparation

1.  [Fork and clone](https://github.com/ga-wdi-boston/meta/wiki/ForkAndClone)
    this repository.
1.  Install dependencies with `bundle install`.
1.  Run `rake db:create db:migrate`
1.  Create `config/secrets.yml` and run `rake secret` twice to generate tokens.

  ```ruby
  test:
    secret_key_base: XXX
    secret_token: XXX
  ```

## Discussion: Choosing Endpoints for Article Comments

Check out our nested routes in [routes.db](app/config/routes.rb).

Before we associated Comments to Articles, our Articles routes looked like this:

```ruby
resources :articles, except: [:new, :edit]
```

Now that we're associating Comments to Articles, we can take advantage of
Rails' **nested routes** feature. Hence, our routes for these resources now look
like this:

```ruby
resources :articles, except: [:new, :edit] do
  resources :comments, only: [:index, :create]
end
resources :comments, except: [:new, :edit, :index, :create]
```

Let's run `rake routes` and take a look at what this gives us.

## Demo: Shallow Routes

Nested routes offer many advantages, but can still look a little sloppy
depending on the restrictions you need to apply to each resource, respectively.

Rails to the rescue!

We can leverage **shallow routes** to generate the same routes.

```ruby
resources :articles, except: [:new, :edit] do
  resources :comments, except: [:new, :edit], shallow: true
end
```

Here, adding `shallow: true` to our comments resources generates all collection
routes for the child route association (i.e., `:index` and `:create`) as well
as all other member routes that are not nested (i.e., `:show`, `:update`,
`:destroy`).

## Demo: Authenticated Requests for Articles

Let's check out how our [requests/articles_spec.rb](spec/requests/articles_spec.rb)
has changed since our last pass at this.

## Lab: Associate Comments with Articles

Start with modifying your Comments migration.

Then, update your Comments and Articles models to handle this new relationship.

## Code-along: Test Article Model

In [spec/models/article_spec.rb](spec/models/article_spec.rb), let's test to
see if we:

1.  are associating comments to articles
1.  have set our `inverse_of` record
1.  are deleting comments associated to articles when articles are deleted

## Lab: Test Comments Model

In [spec/models/comment_spec.rb](spec/models/comment_spec.rb), use the tests we
created for the Article model to guide your tests to ensure you:

1. are associating articles to comments
1. have set your `inverse_of` record

## Bonus: Write a Tested, Behavior-Driven Blog API in Rails

## [License](LICENSE)

Source code distributed under the MIT license. Text and other assets copyright
General Assembly, Inc., all rights reserved.
