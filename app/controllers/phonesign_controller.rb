class PhonesignController < ApplicationController
  def generate
  	ps = Phonesign.where(:phone=>params[:phone]).first

  	if ps and (ps.created_at - DateTime.now).abs < 60
  	else
  		Phonesign.where(:phone=>params[:phone]).destroy_all
  		ps = Phonesign.create(:phone=>params[:phone])
  	end

  	if ps.valid?
	  	Inolink.new.batch_send(params[:phone],ps.sign)
	  	render :json=>{:sign=>ps.sign,:phone=>params[:phone]}
	  else
	  	render :json=>{:sign=>'',:phone=>params[:phone]}
	  end
  end

  def validate
  	render :json=>{:valid=>Phonesign.where(:phone=>params[:phone],:sign=>params[:sign]).size !=0,:phone=>params[:phone]}
  end
end
