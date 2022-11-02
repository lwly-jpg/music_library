require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context 'GET /' do
    it 'returns homepage with links to other pages' do
      response = get('/')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Music Library</h1>')
      expect(response.body).to include('<h2>Albums</h2>')
      expect(response.body).to include('<a href="/albums">View albums</a>')
      expect(response.body).to include('<a href="/albums/new">Add new album</a>')
      expect(response.body).to include('<h2>Artists</h2>')
      expect(response.body).to include('<a href="/artists">View artists</a>')
      expect(response.body).to include('<a href="/artists/new">Add new artist</a>')
    end
  end
  
  
  context 'GET /albums' do
    it 'returns list of albums' do
      response = get('/albums')
      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/albums/2">Surfer Rosa</a>')
      expect(response.body).to include('<li>Released: 1988</li>')
      expect(response.body).to include('<a href="/albums/3">Waterloo</a>')
      expect(response.body).to include('<li>Released: 1974</li>')
    end
  end

  context 'GET /albums/new' do
    it 'returns HTML form to create new album' do
      response = get('/albums/new')
      expect(response.status).to eq(200)
      expect(response.body).to include('<form method="POST" action="/albums">')
      expect(response.body).to include('<input type="text" name="title" />')
      expect(response.body).to include('<input type="text" name="release_year" />')
      expect(response.body).to include('<input type="text" name="artist_id" />')
      expect(response.body).to include('<input type="submit" />')
    end
  end

  context 'POST /albums' do
    it 'rejects invalid parameters' do
      response = post('/albums', invalid_title: 'Waterloo', invalid_thing: 123)
      expect(response.status).to eq(400)
    end
    
    it 'creates a new album' do
      response = post('/albums', title: 'Voyage', release_year: '2022', artist_id: 2)
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Voyage added to albums</h1>')
      get_response = get('/albums')
      expect(get_response.body).to include('Voyage')
      expect(get_response.body).to include('Released: 2022')
    end
  end

  context 'GET /artists' do
    it 'returns list of artists' do
      response = get('/artists')
      expect(response.status).to eq(200)
      expect(response.body).to include('Pixies')
      expect(response.body).to include('<li>Genre: Rock</li>')
      expect(response.body).to include('Taylor Swift')
      expect(response.body).to include('<li>Genre: Pop</li>')
    end
  end

  context 'GET /artists/new' do
    it 'returns HTML form to create new artist' do
      response = get('/artists/new')
      expect(response.status).to eq(200)
      expect(response.body).to include('<form method="POST" action="/artists">')
      expect(response.body).to include('<input type="text" name="name" />')
      expect(response.body).to include('<input type="text" name="genre" />')
    end
  end


  context 'GET /albums/:id' do
    it 'returns album by id 2' do
      response = get('/albums/2')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Release year: 1988')
      expect(response.body).to include('Artist: Pixies')
    end

    it 'returns album by id 3' do
      response = get('/albums/3')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Waterloo</h1>')
      expect(response.body).to include('Release year: 1974')
      expect(response.body).to include('Artist: ABBA')
    end
  end

  context 'GET /artists/:id' do
    it 'returns artist by id 2' do
      response = get('/artists/2')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>ABBA</h1>')
      expect(response.body).to include('Genre: Pop')
    end
  end

  context 'POST /artists' do

    it 'rejects invalid parameters' do
      response = post('/artists', invalid_name: 'Taylor Swift', invalid_thing: 123)
      expect(response.status).to eq(400)
    end

    it 'creates a new artist' do
      response = post('/artists', name: 'Wild Nothing', genre: 'Indie')
      expect(response.status).to eq(200)
      get_response = get('/artists')
      expect(get_response.body).to include('Wild Nothing')
      expect(get_response.body).to include('Genre: Indie')
    end
  end


end


