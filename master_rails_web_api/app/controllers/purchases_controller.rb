class PurchasesController < ApplicationController
  before_action :authenticate_user
  before_action :authorize_actions

  def index
    purchases = orchestrate_query(policy_scope(Purchase))
    render serialize(purchases)
  end

  def show
    render serialize(purchase)
  end

  private

  def purchase
    @purchase ||= params[:id] ? Purchase.find_by!(id: params[:id]) :
                    Purchase.new(purchase_params)
  end
  alias_method :resource, :purchase

end