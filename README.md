[![General Assembly Logo](https://camo.githubusercontent.com/1a91b05b8f4d44b5bbfb83abac2b0996d8e26c92/687474703a2f2f692e696d6775722e636f6d2f6b6538555354712e706e67)](https://generalassemb.ly/education/web-development-immersive)

# Iterative Development of Rails APIs

## Prerequisites

-   [ga-wdi-boston/rails-api-bdd](https://github.com/ga-wdi-boston/rails-api-bdd)
-   [ga-wdi-boston/rails-activerecord-one-to-many](https://github.com/ga-wdi-boston/rails-activerecord-one-to-many)
-   [ga-wdi-boston/rails-activerecord-many-to-many](https://github.com/ga-wdi-boston/rails-activerecord-many-to-many)

## Objectives

By the end of this lesson, students should be able to:

-   Explain the value of iterative development.
-   Write concise, associated routes.
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

## Demo: Authenticated Requests for Articles

Let's check out how our [requests/articles_spec.rb](spec/requests/articles_spec.rb)
has changed since our last pass at this.

## Demo: Associated Request Specs for Comments of Articles

Let's look into [requests/article_comments_spec.rb](spec/requests/article_comments_spec.rb)
and examine what is required to make a request on associations. What do you
notice about our endpoints?

## Code-along: Associate Comments with Articles

Start with modifying our Comments migration
(`rails g migration AddArticleToComments`).

Then, we will update our Comments and Articles models to handle this new
relationship.

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
resources :comments, except: [:new, :edit]
```

Comments' `:index` and `:create` methods are **collection** routes in Rails,
meaning their actions act upon the collection of their resource, hence why they
are nested (i.e., showing ALL comments associated to an article).

Comments' `:update`, `:show`, and `:destroy` methods are **member** routes in
Rails, meaning their actions act upon a single member of the resource
collection (i.e., deleting ONE comment).

Let's run `rake routes` and take a look at what this gives us.

## Discussion: Shallow Routes

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

**It's your choice whether you use nested or shallow routes.**
Testing for Article/Comment associated routes can be found at [routing/article_comments_spec.rb](spec/routing/article_comments_spec.rb).

## Code-along: Test Article Model

In [spec/models/article_spec.rb](spec/models/article_spec.rb), let's test to
see if we:

1.  are associating comments to articles
1.  have set our `inverse_of` record
1.  are deleting comments associated to articles when articles are deleted

## Lab: Test Comments Model

In [spec/models/comment_spec.rb](spec/models/comment_spec.rb), use the tests we
created for the Article model to guide your tests to ensure you:

1.  are associating articles to comments
1.  have set your `inverse_of` record

## Code-along: Iterate over Article Model to Ensure Validations

Using our BDD skills, let's create tests to check that our Article model is
validating the presence of `content` and `title`. We don't want articles
created that omit either.

We will create our tests first and let those drive us towards an
adequately-validated model.

## Lab: Iterate over Comment Model to Ensure Validations

Your turn. Let your test(s) drive you towards validating the presence of a new
comment's `content`.

## Code-along: `validates_associated` on Article Model

Rails' `validates_associated` helper ensures that associations with validations
are also checked upon save. Let's test for this and let the tests guide us
towards its implementation.

Note: do **not** apply `validates_associated` to both the Article and Comment
models. They will call themselves in an infinite loop.

## Bonus: Write a Tested, Behavior-Driven Blog API in Rails

## [License](LICENSE)

Source code distributed under the MIT license. Text and other assets copyright
General Assembly, Inc., all rights reserved.
