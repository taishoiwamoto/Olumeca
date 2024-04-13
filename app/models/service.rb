# サービス情報を管理するモデルで、各サービスはタイトルと詳細を持ち、カテゴリー、ユーザー、レビュー、いいね、および注文と関連付けられています。
class Service < ApplicationRecord
  # 特定のキーワードに基づいてアクティブなサービスを検索するスコープです。
  # タイトルまたは詳細にキーワードが含まれるサービスを返します。
  # scope は、特定のクエリ条件に基づいてデータを取得する際に再利用可能なメソッドを作成するためのものです。
  # ここでの scope は by_keyword という名前で定義されており、これにより、モデルのどこからでも Model.by_keyword(some_keyword) の形で呼び出すことができます。
  # ここでは keyword をパラメータとして受け取り、このキーワードを使用して検索を行います。
  # activeは、アクティブな（例えば、削除されていないなどの条件を満たす）レコードのみを返すものです。
  # where クローズはSQLクエリを構築するために使用され、ここでは title または detail フィールドに keyword が含まれているレコードを検索します。
  # "title LIKE ? OR detail LIKE ?" はSQLのLIKE演算子を使った条件式で、指定されたキーワードがタイトルまたは詳細に部分一致するレコードを検索します。
  # "%#{keyword}%" は、キーワードを含む任意の文字列にマッチするためのワイルドカード（%）を含む検索パターンです。
  scope :by_keyword, ->(keyword) { active.where("title LIKE ? OR detail LIKE ?", "%#{keyword}%", "%#{keyword}%") }

  belongs_to :user
  has_many :orders
  belongs_to :category
  has_many :reviews
  # サービスには複数の「いいね」が関連付けられており、サービスが削除されると関連する「いいね」も削除されます。
  has_many :likes, dependent: :destroy
  # サービスには一つの画像が添付されています。これはユーザーがサービスを視覚的に識別するのに役立ちます。
  has_one_attached :image

  # タイトルは必須であり、最大100文字までです。100文字を超えるとエラーメッセージが表示されます。
  validates :title,
    presence: true,
    length: {
      maximum: 100,
      too_long: ':El nombre del servicio debe tener menos de %{count} caracteres.'
    }

  validates :detail, presence: true

  # 「deleted_at」がnilのサービスのみを返すスコープで、アクティブなサービスをフィルタリングします。
  scope :active, -> { where(deleted_at: nil) }

  # ソフトデリートを行い、サービスの「deleted_at」を現在時刻に設定します。これによりサービスは非アクティブになります。
  def soft_delete
    update_attribute(:deleted_at, Time.now)
  end

  # サービスに対するすべてのレビューの平均評価を計算し、小数点以下2桁で丸めて返します。
  # reviews はこのクラスに関連付けられた Review モデルのインスタンスのコレクションです。
  # この関連付けは、通常は has_many などのアソシエーションを通じて設定されます。
  #.average(:rating) は、reviews コレクションに含まれる rating 属性の平均値を計算するためのメソッドです。
  # これはSQLの AVG 関数を使用してデータベースレベルで計算され、効率的に動作します。
  # .average メソッドが返す値は通常 BigDecimal や nil です（特にレビューが存在しない場合）。
  # to_f はこの値を浮動小数点数に変換します。これにより、後続の数値操作が容易になります。
  # round(2) は、浮動小数点数を小数点以下2桁で丸めるためのメソッドです。これにより、表示や処理を行う際により扱いやすい形式になります。
  def average_rating
    reviews.average(:rating).to_f.round(2)
  end

  # サービスが受けた「いいね」の総数を返します。
  # length メソッドは、likes コレクションに含まれる要素の数を返します。これはリスト内のアイテムの総数を直接カウントするためのRubyの配列メソッドです。
  #def count_likes
  #  likes.length
  #end

  # サービスが削除されたかどうかを確認します。
  # deleted? メソッドは、データベースから実際にレコードを削除することなく、削除されたとマークすることができます。これにより、データの整合性を維持し、データの復旧が可能になります。
  # .present? メソッドは、deleted_at カラムに値が設定されているかどうかをチェックします。
  def deleted?
    deleted_at.present?
  end
end
