module Index
  class Base < Grape::API
  	format :json
    
    before do
      unless ApiSecret.authenticate_with_api_key!(request)
        error = {
          error: {
            message: "Unauthorized",
            type: "invalid_request_error"
          }
        }
        error!(error, 401)
      end
    end    
    
    mount Index::V1::HelloWorld

    get '/:invalid_resource' do
      error = {
        error: {
          message: "Unrecognised request URL (GET: /#{params[:invalid_resource]}). If you are trying to list objects, remove the trailing slash. If you are trying to retrieve an object, make sure you passed a valid (non-empty) identifier in your code.",
          type: "invalid_request_error"
        }
      }
      error!(error, 404)
    end

    post '/:invalid_resource' do
      error = {
        error: {
          message: "Unrecognised request URL (POST: /#{params[:invalid_resource]}). If you are trying to list objects, remove the trailing slash. If you are trying to retrieve an object, make sure you passed a valid (non-empty) identifier in your code.",
          type: "invalid_request_error"
        }
      }
      error!(error, 404)
    end

    put '/:invalid_resource' do
      error = {
        error: {
          message: "Unrecognised request URL (PUT: /#{params[:invalid_resource]}). If you are trying to list objects, remove the trailing slash. If you are trying to retrieve an object, make sure you passed a valid (non-empty) identifier in your code.",
          type: "invalid_request_error"
        }
      }
      error!(error, 404)
    end

    patch '/:invalid_resource' do
      error = {
        error: {
          message: "Unrecognised request URL (PATCH: /#{params[:invalid_resource]}). If you are trying to list objects, remove the trailing slash. If you are trying to retrieve an object, make sure you passed a valid (non-empty) identifier in your code.",
          type: "invalid_request_error"
        }
      }
      error!(error, 404)
    end

    delete '/:invalid_resource' do
      error = {
        error: {
          message: "Unrecognised request URL (DELETE: /#{params[:invalid_resource]}). If you are trying to list objects, remove the trailing slash. If you are trying to retrieve an object, make sure you passed a valid (non-empty) identifier in your code.",
          type: "invalid_request_error"
        }
      }
      error!(error, 404)
    end

  end
end