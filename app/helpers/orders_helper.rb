module OrdersHelper
  def get_order_status(status)
    I18n.t("order_statuses.#{status}", default: 'Rechazado')
  end
end
