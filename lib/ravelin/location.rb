module Ravelin
  class Location < RavelinObject
    attr_accessor :location_id,
      :street1,
      :street2,
      :locality,
      :postal_code,
      :country,
      :latitude,
      :longitude
  end
end
