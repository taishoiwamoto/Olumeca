# ユーザー情報を管理するモデルで、Deviseを使用して認証機能を提供します。

class User < ApplicationRecord
  # Deviseの設定。ユーザー認証、登録、パスワードリカバリー、リメンバー機能を有効化。
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  # 利用規約の同意が必須であることを確認するバリデーション。
  # レコードが最初に作成されるときにのみ、ユーザーが利用規約に同意しているかを検証します。
  # レコードの更新時にはこのバリデーションは適用されません。
  validates_acceptance_of :agreement, allow_nil: false, on: :create

  # パスワードが必要な場合、その存在を検証。
  validates_presence_of     :password, if: :password_required?

  # パスワードが必要な場合、パスワードの確認を検証。
  validates_confirmation_of :password, if: :password_required?

  # パスワードの長さを6から128文字の範囲で検証。
  # 既存のユーザーが自分の情報を更新する際に、パスワードを変更したくない場合にパスワードフィールドを空のままにしておくことができます。
  validates_length_of       :password, within: 6..128, allow_blank: true

  # ユーザーが削除されるとサービスの参照はnullifyされる。カラムの値を明示的に「null」に設定する。
  has_many :services, dependent: :nullify

  # このコード行はUserモデルが複数の注文（Order）を購入者（buyer）として持つことを可能にし、そのモデルが削除された場合の注文の扱いを定義しています。
  # has_many :purchased_orders：これにより、このモデルのインスタンスが複数のOrderインスタンスを持つことが示されます。ここでの:purchased_ordersは関連するオブジェクトを参照するために使用される名前です。
  # class_name: 'Order'：関連付けられているモデルがOrderクラスであることを指定します。これは、関連名（purchased_orders）がモデルのクラス名と直接一致しない場合に必要です。
  # foreign_key: 'buyer_id'：Orderテーブルのどのフィールドがこの関連を持つモデルのインスタンスに対応するかを示します。この場合、Orderモデルのbuyer_idフィールドが、このモデルのインスタンスのIDと関連付けられています。
  # ユーザーが削除されると注文の参照はnullifyされる。カラムの値を明示的に「null」に設定する。
  has_many :purchased_orders, class_name: 'Order', foreign_key: 'buyer_id', dependent: :nullify

  # このコード行はUserモデルが複数の注文（Order）を出品者（seller）として持つことを可能にし、そのモデルが削除された場合の注文の扱いを定義しています。
  # ユーザーによる販売注文を管理。ユーザーが削除されると注文の参照はnullifyされる。カラムの値を明示的に「null」に設定する。
  has_many :sold_orders, class_name: 'Order', foreign_key: 'seller_id', dependent: :nullify

  has_many :reviews, dependent: :nullify
  has_many :likes, dependent: :destroy
  has_one_attached :image

  # ユーザー名は必須であり、最大30文字。
  validates :name,
    presence: true,
    length: {
    maximum: 30,
    too_long: ':El nombre del usuario debe tener menos de %{count} caracteres.'
  }

  validates :phone_number, presence: true

  # アカウント作成時、非アクティブアカウントで同じメールが使われていないか確認するカスタムバリデーション。
  validate :email_uniqueness_for_inactive_accounts, on: :create

  # アクティブなユーザーを抽出するスコープ。
  scope :active, -> { where(deleted_at: nil) }

  # アクティブなアカウントのメールアドレスの一意性を検証するメソッドです。
  # 新しく作成されるアカウントで使用されたメールアドレスが、既にアクティブなユーザー（deleted_atがnil）によって
  # 使用されていないかどうかをチェックします。もし使用されている場合は、エラーメッセージを追加します。
  def email_uniqueness_for_inactive_accounts
    if User.where(email: email, deleted_at: nil).exists?
      errors.add(:email, "ya esta en uso")
    end
  end

  # 認証時にアクティブなユーザーのみを考慮するためのメソッドです。
  # 与えられた条件に「deleted_at: nil」を追加して、アクティブなユーザーだけを検索します。
  def self.find_for_authentication(conditions)
    conditions[:deleted_at] = nil
    find_by(conditions)
  end

  # ユーザーが提供したサービスの平均評価を計算するメソッドです。
  # ユーザーIDに基づいて、そのユーザーが提供したサービスに対するすべてのレビューを集め、
  # それらの平均評価を浮動小数点数で返します。
  # Review.joins(service: :user)は、Review モデルから始まり、joins メソッドを使って service とその user とを結合します。
  # これにより、レビュー、サービス、ユーザーのデータを結びつけることができます。
  # この結合は、レビューが対象とするサービス、さらにそのサービスを提供するユーザーのデータを同時に取得するために使用されます。
  # where(services: { user_id: id })は、結合したデータから、
  # 特定のユーザー（このメソッドが属するモデルのインスタンスが持つ id）が提供するサービスに関連するレビューをフィルタリングします。
  # services は service テーブルを指し、{ user_id: id } で、サービスの提供者が現在のユーザー（id）であるものを選択しています。
  # reviews.average(:rating).to_fで、average(:rating) は、フィルタリングされたレビューの rating カラムの平均値を計算します。
  # これはデータベースレベルでの集計関数（AVG）を利用し、効率的に平均値を算出します。
  # to_f は、得られた平均値（通常は BigDecimal 型または nil）を浮動小数点数に変換します。これにより、平均評価が数値として扱いやすくなります。
  def average_service_rating
    reviews = Review.joins(service: :user).where(services: { user_id: id })
    reviews.average(:rating).to_f
  end

  # ユーザーに関連付けられたすべてのレビューの平均評価を計算するメソッドです。
  # 評価の平均値を浮動小数点数で返します。
  def average_rating
    reviews.average(:rating).to_f
  end

  # ソフトデリートを実行し、deleted_atを現在時刻に設定する。
  def soft_delete
    # update_attribute メソッドは、指定した属性に値を設定し、その変更をデータベースに直ちに保存します（バリデーションは無視されます）。
    # :deleted_at という属性（カラム）を現在の時刻 Time.now に設定します。
    # これにより、そのレコードが「削除された」とマークされます。deleted_at カラムが nil でない場合、
    # 通常はそのレコードが削除されたとみなされます。
    update_attribute(:deleted_at, Time.now)
    # each(&:soft_delete) は、services コレクションの各要素に対して soft_delete メソッドを呼び出します。
    # これにより、関連する各サービスも同様にソフトデリートされ、一貫性のあるデータ状態が保たれます。
    services.each(&:soft_delete)
  end

  # ユーザーのアクティブな認証状態を確認。
  # super キーワードは、このメソッドがオーバーライドされる前のオリジナルのメソッド（Deviseのデフォルトの active_for_authentication? メソッド）を呼び出します。
  # Deviseにおいて、デフォルトのメソッドはユーザーがアクティブであるかどうかを基本的な条件でチェックします（例えば、アカウントが有効期限切れでないかどうかなど）。
  def active_for_authentication?
    # !deleted_at は、deleted_at フィールドが nil であるかどうかを評価します。
    # deleted_at フィールドに値が設定されている場合（つまり、ユーザーがソフトデリートされている場合）は、この式は false を返します。
    # 逆に、deleted_at が nil（削除されていない状態）であれば true を返します。
    super && !deleted_at
  end

  # アクティブでない時のメッセージ。
  # このカスタマイズにより、アプリケーションはユーザーがログインしようとした際に、そのユーザーが削除されていることを特定し、適切なフィードバックを提供することができます。
  # 特に、ユーザーがソフトデリートされている場合に「ユーザーが見つかりません」というメッセージを表示することで、
  # そのユーザーがなぜログインできないのかを明確にします。これにより、ユーザーエクスペリエンスが向上し、システムの透明性が保たれます。
  def inactive_message
    !deleted_at ? super : :not_found_in_database
  end

  # モデルの deleted_at 属性が更新された後に特定の条件を満たす場合に reject_pending_orders メソッドを実行するように設定しています。
  # オブジェクトがソフトデリートされたときに関連するビジネスロジックを自動的に実行することが可能になります。
  # ユーザーがアカウントを削除した場合に、そのユーザーに関連する未解決の注文を自動的にキャンセルする.
  # 具体的には、ソフトデリートの状態が変更されたときに動作するトリガーです。
  # after_update は、オブジェクトがデータベースで更新された後に実行されるコールバックです。
  # このコールバックは、特定のメソッド（ここでは reject_pending_orders）を指定された条件が真の時に自動的に呼び出します。
  # :reject_pending_ordersは、更新後に実行されるメソッドの名前です。
  # saved_change_to_attribute? は指定された属性（ここでは deleted_at）に対して、
  # そのリクエストの中で保存された変更（更新）があったかどうかを確認します。つまり、deleted_at の値が更新されたかどうかを検証します。
  # !deleted_at.nil?は、deleted_at が nil でないことを確認します。
  # これは、deleted_at に値が設定されている場合（つまりユーザーがソフトデリートされた場合）を指し、
  # ソフトデリートが実際に行われたことを意味します。
  after_update :reject_pending_orders, if: -> { saved_change_to_attribute?(:deleted_at) && !deleted_at.nil? }

  # ユーザーが削除されたかどうかを確認。
  def deleted?
    deleted_at.present?
  end

  # アカウントを完全に削除するためのメソッド。名前、メール、電話番号を無効化。
  def hard_delete
    update(name: "Dado de baja", email: "--", phone_number: "--")
    save
  end

  private

   # ユーザーが削除された際に保留中の注文を拒否する。
  def reject_pending_orders
    Order.where(buyer_id: id, status: :pending).or(Order.where(seller_id: id, status: :pending)).each do |order|
      order.update(status: :rejected)
    end
  end

  #このメソッドは、指定されたメールアドレスが既にデータベース内にアクティブなユーザー（deleted_at が nil のユーザー）として存在するかどうかを確認するためのクラスメソッドです。
  # where(email: email, deleted_at: nil)は、email フィールドが引数で与えられた email と一致し、かつ deleted_at フィールドが nil（ソフトデリートされていない）であるレコードを検索します。
  # !...empty?は、クエリの結果として返されるコレクションが空かどうかをチェックします。空であれば true を、一つ以上の要素があれば false を返します。
  # !（否定演算子）は、empty? の結果を反転させます。
  # つまり、もしクエリの結果が空でなければ（つまりメールアドレスが存在すれば）、true を返し、空であれば false を返します。
  def self.email_taken?(email)
    !where(email: email, deleted_at: nil).empty?
  end

  # パスワードが必要かどうかを判断する。
  # !persisted?で、persisted? メソッドは、オブジェクトがデータベースに既に保存されているかどうかを確認します。
  # オブジェクトが保存されていなければ（新規作成の場合）、persisted? は false を返し、その否定形 !persisted? は true を返します。
  # つまり、この条件は新規のレコードである場合（まだデータベースに保存されていない場合）、パスワードが必要であることを示します。
  # !password.nil?で、password.nil? は、password 属性が nil であるかどうかをチェックします。
  # password 属性に値が設定されている場合（nil でない場合）、password.nil? は false を返し、その否定形 !password.nil? は true を返します。
  # この条件は、ユーザーがパスワードフィールドに何らかの値を入力している場合、パスワードが必要であることを示します。
  # password_confirmation.nil? は、password_confirmation 属性が nil であるかどうかをチェックします。
  # password_confirmation に値が設定されている場合、その否定形 !password_confirmation.nil? は true を返します。
  # この条件は、パスワード確認フィールドに何らかの値が入力されている場合、パスワードが必要であることを示します。
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end
