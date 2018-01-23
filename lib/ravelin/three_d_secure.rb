module Ravelin
  class ThreeDSecure < RavelinObject
    attr_accessor :attempted,
                  :success,
                  :start_time,
                  :end_time,
                  :timed_out

    def serializable_hash
      hash = {
        'attempted' => boolean(attempted),
        'success'   => boolean(success),
        'startTime' => timestamp(start_time),
        'timedOut'  => boolean(timed_out)
      }
      hash['endTime'] = timestamp(end_time) unless end_time.nil?
      hash
    end

    private

    def boolean(bool)
      bool || false
    end

    def timestamp(time)
      time.to_i
    end
  end
end
