class UserSearchForm
  include ActiveModel::Model

  attr_accessor :first_name, :last_name, :gender, :min_age, :max_age, :prefecture_id

  def initialize(params = {})
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @gender = params[:gender]
    @min_age = params[:min_age]
    @max_age = params[:max_age]
    @prefecture_id = params[:prefecture_id]
  end

  # クエリを実行
  def query
    base_relation
      .then(&method(:search_by_name))
      .then(&method(:search_by_gender))
      .then(&method(:search_by_ages))
      .then(&method(:search_by_prefecture_id))
  end

  private

    # 基本条件
    def base_relation
      User.all
    end

    # 名前で検索（必ずしも姓・名の両方が入力されるとは限らないため、入力された値によって検索条件を変える）
    def search_by_name(relation)
      if first_name.present? && last_name.present?  # 姓・名の両方が入力された場合
        search_by_full_name(relation)
      elsif first_name.present? && last_name.blank? # 名のみ入力された場合
        search_by_first_name(relation)
      elsif first_name.blank? && last_name.present? # 姓のみ入力された場合
        search_by_last_name(relation)
      else
        relation
      end
    end

    # フルネーム（姓 + 名）で検索
    def search_by_full_name(relation)
      relation
        .where("last_name LIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(last_name)}%")
        .where("first_name LIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(first_name)}%")
    end

    # 名で検索
    def search_by_first_name(relation)
      relation.where("first_name LIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(first_name)}%")
    end

    # 姓で検索
    def search_by_last_name(relation)
      relation.where("last_name LIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(last_name)}%")
    end
    
    # 性別で検索
    def search_by_gender(relation)
      return relation if gender.blank?

      relation.where(gender: gender)
    end

    # 年齢で検索（Userモデルに年齢の値そのものが保持されているわけではないので誕生日から計算）
    def search_by_ages(relation)
      return relation if min_age.blank? || max_age.blank?

      start_date = Date.today - max_age.to_i.years
      end_date = Date.today - min_age.to_i.years

      relation.where(birthdate: start_date..end_date)
    end

    # 都道府県で検索
    def search_by_prefecture_id(relation)
      return relation if prefecture_id.blank?

      relation.where(prefecture_id: prefecture_id)
    end
end
