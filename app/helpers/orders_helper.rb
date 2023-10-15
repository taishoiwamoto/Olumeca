module OrdersHelper
    # [重要度: 低] https://zenn.dev/farstep/articles/b1cebeaefd324b i18nで同様のことができるので、こちらの利用を検討してください
	def get_order_status(status)
		if status === "pending"
			'Pendiente'
		elsif status === "accepted"
			'Aceptado'
		else
			'Rechazado'
		end
	end

    # [重要度: 低] ユーザは物理削除しないという前提であればこの処理は不要かと思います
	def get_name_buyer(buyer_id)
		u = User.find(buyer_id)
		u.nil? ? '' : u.name
	end
end
