require('sinatra')
require('sinatra/reloader')
require('pry')
require_relative('../models/member.rb')
require_relative('../models/session.rb')
require_relative('../models/schedule.rb')
also_reload('./models/*')


get '/gym/members' do
  @members = Member.all()
  erb(:'members/index')
end

get '/gym/members/new' do
  @memberships = Membership.all()
  erb(:'members/new')
end

post '/gym/members' do
  @member = Member.new(params)
  @member.save()
  redirect to '/gym/members'
end

get '/gym/members/:id' do
  @member = Member.find(params[:id])
  @membership = @member.find_membership()
  erb(:'members/show')
end

get '/gym/members/:id/edit' do
  @member = Member.find(params[:id])
  erb(:'members/edit')
end


post '/gym/members/:id' do
  Member.new(params).update
  redirect to '/gym/members'
end

post '/gym/members/:id/delete' do
  Member.delete(params[:id])
  redirect to '/gym/members'
end

get '/gym/members/:id/add' do
  @sessions = Session.all()
  @member = Member.find(params[:id])
  erb(:'members/add')
end

post '/gym/members/:id/add' do
  @member = Member.find(params[:id])
  @sessions = []
  @full_sessions = []
  params.each_key do |key|
    unless key == 'id' then
      session = Session.find(key.to_i)
      if session.number_of_participants < session.capacity
        @member.add_to_session(session.id)
        @sessions << session
      else
        @full_sessions << session
      end
    end
  end
  erb(:'members/create')
end
