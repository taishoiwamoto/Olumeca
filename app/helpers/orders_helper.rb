module OrdersHelper
    # [重要度: 低] https://zenn.dev/farstep/articles/b1cebeaefd324b i18nで同様のことができるので、こちらの利用を検討してください → 完了
    def get_order_status(status)
      I18n.t("order_statuses.#{status}", default: 'Rechazado')
    end

    # [重要度: 低] ユーザは物理削除しないという前提であればこの処理は不要かと思います → 完了
end
