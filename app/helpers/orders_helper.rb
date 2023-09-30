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
end
