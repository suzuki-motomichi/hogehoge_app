class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post

  has_many :relationships # 中間テーブル Relationship.rb
  has_many :followings, through: :relationships, source: :follow
  # @user.relationships.map(&:follow) と同じ
  # Userのインスタンスに対してrelationshipsメソッドを実行し得られたデータに一つずつfollowメソッドを処理していくのがfollowingsメソッド
  has_many :reverce_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  # reverce_of_relationshipsメソッドはRelationshipクラスを参照し、さらに外部キーはfollow_idですよー
  has_many :followers, through: :reverce_of_relationships, source: :user

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true
  validates :name, presence: true, length: { maximum: 10 }

  # def like(post) # like_postにぶち込むのでsaveメソッドの代わり
  #   like_posts << post
  # end

  # def unlike(post)
  #   like_posts.delete(post)
  # end

  def like?(post)
    like_posts.include?(post)
  end

  # フォロー部分

  def follow(other_user)
    # 自分をフォローしていないか
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    # pry(#<UsersController>)> Relationship
    # => Relationship(id: integer, user_id: integer, follow_id: integer, created_at: datetime, updated_at: datetime)
    # self.relationshipsでUserのインスタンスの中にあるfollow_idを取得するが、他のuser_idを引数に渡してるので
    # relationshipにはUserのインスタンスが持つ他のユーザーのfollow_idを取得する
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    # self.followingsメソッドでUser一覧を取得できる
    self.followings.include?(other_user)
    # selfにはUserのインスタンスのデータが入る(今回はログイン機能を作っている為 viewファイルでは,
    # current_user.following?()というcurrent_userとfollowingを.(ドット)を使って繋げているので、ログインしているユーザーのデータがselfに入る)
  end
end
