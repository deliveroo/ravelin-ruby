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
        'timedOut'  => boolean(timed_out)
      }
      hash['startTime'] = timestamp(start_time) if valid?(start_time)
      hash['endTime']   = timestamp(end_time)   if valid?(end_time)
      hash
    end

    private

    def boolean(bool)
      bool || false
    end

    def timestamp(time)
      time.to_i
    end

    def valid?(time)
      timestamp(time) >= 100
    end
  end
end
