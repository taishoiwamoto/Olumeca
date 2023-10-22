module OrdersHelper
    #完了 [重要度: 低] https://zenn.dev/farstep/articles/b1cebeaefd324b i18nで同様のことができるので、こちらの利用を検討してください
    def get_order_status(status)
      I18n.t("order_statuses.#{status}", default: 'Rechazado')
    end

    #完了 [重要度: 低] ユーザは物理削除しないという前提であればこの処理は不要かと思います
end
