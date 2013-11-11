require 'util/document-converter'
require 'uuidtools'

module Cocowrite
  module API
    
    class Documents < Grape::API
      
      format :json
      
      rescue_from :all
      
      resources :documents do 
        
        params do
          requires :file
          requires :template, type: String
        end
        post do
          format = 'pdf'
          id = UUIDTools::UUID.random_create.to_s
          filename = "#{id}.#{format}"
          env.logger.info "Start to generate #{filename} using template #{params[:template]}."
          status, log = Cocowrite::DocumentConverter::run_pandoc File.read(params[:file][:tempfile]), filename, params[:template]
          if status == :compilation_succeed
            env.logger.info "[CONVERSION] Target file #{filename} has been generated successfully."
            {pdf: "#{CONFIG['document']['server_root_url']}/#{filename}"}
          else
            env.logger.error log
            error!("[CONVERSION] Document conversion failed.", 500)
          end
        end
        
        params do
          requires :email, type: String
        end
        post "/interest" do
          puts params
          env.logger.info "[INTEREST] User [#{params[:email]}] showed interest."
        end
        
      end
    end
  end
end
