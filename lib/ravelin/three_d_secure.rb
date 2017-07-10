module Ravelin
  class ThreeDSecure < RavelinObject
    attr_accessor :attempted,
                  :success,
                  :start_time,
                  :end_time,
                  :timed_out

    def serializable_hash
      {
        'attempted' => boolean(attempted),
        'success'   => boolean(success),
        'startTime' => timestamp(start_time),
        'endTime'   => timestamp(end_time),
        'timedOut'  => boolean(timed_out)
      }
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
