
module Sinatra
  module Pages
    def self.registered(app)
      app.get '/' do

        api = HyperResource.new(root: 'http://localhost:3000/api.blendle/get-notes',
                  headers: {'Accept' => 'application/vnd.http://localhost:3000.v1+json'})

        xml_data = JSON.parse(api.get.body.to_json).to_xml(:root => :my_root)

        doc = Nokogiri.XML(xml_data)
        doc.xpath('//note').each do |item|

        end

        #doc.xpath('//note').each do |item|
          #note_result = Note.new

          #note_result.id = item.xpath('id').text
          #note_result.content = item.xpath('content').text
          #note_result.complete = item.xpath('complete').text
          #note_result.created_at = item.xpath('created-at').text
          #note_result.updated_at = item.xpath('updated-at').text

          #store.push(note_result)
        #end
      end

      app.post '/' do
        n = Note.new
        n.content = params[:content]
        n.created_at = Time.now
        n.updated_at = Time.now
        if n.save
          redirect '/', :notice => 'Je memo is opgeslagen.'
        else
          redirect '/', :error => 'Het is niet gelukt om je memo op te slaan.'
        end
      end

      #{ 'Content-Type' => 'application/json' })

      app.post '/save-note' do
        note_data = params[:content]

        response = RestClient.post 'http://localhost:3000/api.blendle/save-note', :data => note_data, :accept => :json
        redirect "/"
      end

      #app.get '/:id' do
      #  @note = Note.get params[:id]
      #  @title = "Update memo ##{params[:id]}"
      #  if @note
      #    erb :'pages/edit'
      #  else
      #    redirect '/', :error => "Die memo kunnen we niet vinden."
      #  end
      #end

      app.put '/:id' do
        n = Note.get params[:id]
        unless n
          redirect '/', :error => "Die memo kunnen we niet vinden."
        end
        n.content = params[:content]
        n.complete = params[:complete] ? 1 : 0
        n.updated_at = Time.now
        if n.save
          redirect '/', :notice => "Je memo is geupdated."
        else
          redirect '/', :error => "Het is niet gelukt om je memo up te daten."
        end
      end

      app.get '/:id/delete' do
        @note = Note.get params[:id]
        @title = "Bevestig verwijdering van memo ##{params[:id]}"
        if @note
          erb :'pages/delete'
        else
          redirect '/', :error => "Die memo kunnen we niet vinden."
        end
      end

      app.delete '/:id' do
        n = Note.get params[:id]
        if n.destroy
          redirect '/', :notice => "Je memo is verwijderd."
        else
          redirect '/', :error => "Het is niet gelukt om je memo te verwijderen."
        end
      end

      app.get '/:id/complete' do
        n = Note.get params[:id]
        unless n
          redirect '/', :error => "Die memo kunnen we niet vinden."
        end
        n.complete = n.complete ? 0 : 1
        n.updated_at = Time.now
        if n.save
          redirect '/', :notice => "Memo gemarkeerd als compleet."
        else
          redirect '/', :error => "Memo gemarkeerd als compleet."
        end
      end

    end
  end
  register Pages
end
