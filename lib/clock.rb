require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

every(3.seconds, 'Call Dequeue') { CallQueueWorker.perform_async }