module OrdersHelper
	def get_order_status(status)
		if status === "pending"
			'Pendiente'
		elsif status === "accepted"
			'Aceptado'
		else
			'Rechazado'
		end
	end

	def get_name_buyer(buyer_id)
		u = User.find(buyer_id)
		u.nil? ? '' : u.name
	end
end
