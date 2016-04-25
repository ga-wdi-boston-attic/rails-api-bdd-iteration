require 'rails_helper'

RSpec.describe 'Articles API' do
  def article_params
    {
      title: 'One Weird Trick',
      content: 'You won\'t believe what happens next...'
    }
  end

  def articles
    Article.all
  end

  def article
    Article.first
  end

  def user_params
    {
      email: 'alice@example.com',
      password: 'foobarbaz',
      password_confirmation: 'foobarbaz'
    }
  end

  def user
    User.first
  end

  before(:all) do
    User.create!(user_params)
    Article.create!(article_params)
  end

  after(:all) do
    Article.delete_all
    User.delete_all
  end

  describe 'GET /articles' do
    it 'lists all articles' do
      get '/articles'

      expect(response).to be_success

      articles_response = JSON.parse(response.body)
      expect(articles_response.length).to eq(articles.count)
      expect(articles_response[0]['title']).to eq(article.title)
    end
  end

  describe 'GET /articles/:id' do
    it 'shows one article' do
      get "/articles/#{article.id}"

      expect(response).to be_success

      article_response = JSON.parse(response.body)
      expect(article_response['id']).to eq(article.id)
      expect(article_response['title']).to eq(article.title)
    end
  end

  context 'when authenticated' do
    def headers
      {
        'HTTP_AUTHORIZATION' => "Token token=#{user.token}"
      }
    end

    describe 'POST /articles' do
      it 'creates an article' do
        post '/articles', { article: article_params }, headers

        expect(response).to be_success

        article_response = JSON.parse(response.body)
        expect(article_response['id']).not_to be_nil
        expect(article_response['title']).to eq(article_params[:title])
      end
    end

    describe 'PATCH /articles/:id' do
      def article_diff
        { title: 'Two Stupid Tricks' }
      end

      it 'updates an article' do
        patch "/articles/#{article.id}", { article: article_diff }, headers

        expect(response).to be_success

        article_response = JSON.parse(response.body)
        expect(article_response['id']).to eq(article.id)
        expect(article_response['title']).to eq(article_diff[:title])
      end
    end

    describe 'DELETE /articles/:id' do
      it 'deletes an article' do
        delete "/articles/#{article.id}", nil, headers

        expect(response).to be_success
        expect(response.body).to be_empty
      end
    end
  end

  context 'when not authenticated' do
    def headers
      {
        'HTTP_AUTHORIZATION' => nil
      }
    end

    describe 'POST /articles' do
      it 'is not successful' do
        post '/articles', nil, headers

        expect(response).not_to be_success
      end
    end

    describe 'PATCH /articles/:id' do
      it 'is not successful' do
        patch "/articles/#{article.id}", nil, headers

        expect(response).not_to be_success
      end
    end

    describe 'DELETE /articles/:id' do
      it 'is not successful' do
        delete "/articles/#{article.id}", nil, headers

        expect(response).not_to be_success
      end
    end
  end
end
