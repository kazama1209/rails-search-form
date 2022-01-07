class UsersController < ApplicationController
  def index
    @users = User.order_by_latest
  end

  def search
    @users = UserSearchForm.new(user_search_params).query.order_by_latest

    render :index
  end

  private
  
    # 検索用のストロングパラメータ
    def user_search_params
      params.fetch(:q, {}).permit(
        :first_name,
        :last_name,
        :gender,
        :min_age,
        :max_age,
        :prefecture_id
      )
    end
end
