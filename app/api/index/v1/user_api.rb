module Index
	module V1
		class UserApi < Base
			version 'api', using: :path
			format :json
			
			desc 'get the user details'
			get 'user/details' do
				puts @user
				status 200
				body @user
			end

			desc "create a new user"
			params do
				requires :firstname, type: String, regexp: /\A[a-z]+\z/
				requires :lastname, type: String, regexp: /\A[a-z]+\z/
				requires :email, type: String, regexp: /\A\S+@\S+\.\S+\z/
			end
			post 'user/create' do
				puts params.to_s
				obj = User.create_user(params)
				status obj[:status]
				obj.delete(:status)
				body obj
			end

			desc "attach avatar to user"
			params do
				requires :avatar, type: File
			end
			post 'user/avatar' do
				puts params.to_s
				obj = User.attach_avatar(@user, params)
				status obj[:status]
				obj.delete(:status)
				body obj
			end

			desc "confirm the user"
			params do
				requires :id, type: Integer, regexp: /\A[0-9]+\z/
			end
			get 'user/confirm/:id' do
				puts params.to_s
				obj = User.confirm_user(params[:id], @user)
				if obj.class == Hash
					status 200
					body obj
				else
					status 400
					body obj
				end
			end

			desc "recover the user"
			params do
				requires :name, type: String, regexp: /\A[a-z]+\z/
				requires :email, type: String, regexp: /\A\S+@\S+\.\S+\z/
				requires :last_remembered_api_key, type: String
			end
			post 'user/recover' do
				puts params.to_s
				obj = User.recover_user(params)
				if obj.class == Hash
					status 200
					body obj
				else
					status 400
					body obj
				end
			end

			desc "admin ban the user"
			params do
				requires :id, type: Integer, regexp: /\A[0-9]+\z/
			end
			get 'admin/user/ban/:id' do
				puts params.to_s
				obj = User.admin_ban_user(@user,	params[:id])
				if obj.class == Hash
					status 200
					body obj
				else
					status 400
					body obj
				end
			end

			desc "admin status the user"
			params do
				requires :id, type: Integer, regexp: /\A[0-9]+\z/
			end
			get 'admin/user/status/:id' do
				puts params.to_s
				obj = User.admin_status_user(@user,	params[:id])
				if obj.class == Hash
					status 200
					body obj
				else
					status 400
					body obj
				end
			end

			desc "admin change the user status"
			params do
				requires :id, type: Integer, regexp: /\A[0-9]+\z/
				requires :status, type: String, regexp: /\A[a-z]+\z/
			end
			patch 'admin/user/:id/:status' do
				puts params.to_s
				obj = User.admin_user_status_change(@user,	params[:id], params[:status])
				if obj.class == Hash
					status 200
					body obj
				else
					status 400
					body obj
				end
			end

			desc 'admin get all user details'
			params do
				optional :per_page, type: Integer
				optional :page, type: Integer
			end
			get 'admin/user/list' do
				obj = User.admin_get_all_user(params)
				status obj[:status]
				obj.delete(:status)
				body obj
			end

		end
	end
end