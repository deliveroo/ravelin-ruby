module Ravelin
  class Customer < RavelinObject
    attr_accessor :customer_id,
      :registration_time,
      :name,
      :given_name,
      :family_name,
      :date_of_birth,
      :gender,
      :email,
      :email_verified_time,
      :user_name,
      :telephone,
      :telephone_verified_time,
      :telephone_country,
      :location,
      :country,
      :custom

    attr_required :customer_id

    def location=(obj)
      @location = Ravelin::Location.new(obj)
    end
  end
end
