module Ravelin
  class Supplier < RavelinObject
    attr_accessor :supplier_id,
      :type,
      :group_id,
      :group_name,
      :registration_time,
      :email,
      :email_verified_time,
      :name,
      :telephone,
      :telephone_verified_time,
      :telephone_country,
      :home_location,
      :market,
      :market_country,
      :level,
      :employment_type,
      :transport_type,
      :category,
      :tags,
      :custom

    attr_required :supplier_id, :type

    def home_location(obj)
      @home_location = Ravelin::Location.new(obj)
    end
  end
end
