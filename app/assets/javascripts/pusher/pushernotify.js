function PusherPrivateNotifier(channel, options) {
  options = options || {};
  
  this.settings = {
    eventName: 'call_incoming'
  };
  
  $.extend(this.settings, options);
  
  var self = this;
  channel.bind(this.settings.eventName, function(data){ self._handleNotification(data); });
};
PusherPrivateNotifier.prototype._handleNotification = function(data) {
  var template = Handlebars.compile($('#calling_template').html());
  // console.log(data);
  params = {
  	"from_number" : data.from_number
  	, "dealer_name" : data.dealer_name
  	, "campaign_name" : data.campaign_name
  	, "customer_name" : data.customer_name
  	, "answer_path" : data.answer_path
    , "disposition_path" : data.disposition_path
    , "campaign_id" : data.campaign_id
    , "to_number" : data.to_number
  	}
  html_data = template(params);
  $('#incoming_calls').html(html_data);
};



function PusherTwilioOutgoing(channel, options) {
    options = options || {};

    this.settings = {
        eventName: 'twilio_outgoing'
    };

    $.extend(this.settings, options);

    var self = this;
    channel.bind(this.settings.eventName, function(data){ self._handleNotification(data); });
};

PusherTwilioOutgoing.prototype._handleNotification = function(data) {

    // console.log(data);
    var outgoing_div = $("#soft_phone_outgoing");
    var customer_number = $("#outgoing_customer_phone_number");
    var customer_name = $("#outgoing_customer_name");
    var dealer_name = $("#outgoing_dealer_name");
    var campaign_name = $("#outgoing_campaign_name");
    var caller_id = $("#outgoing_caller_id");
    var outgoing_call_id = $("#outgoing_call_id");
    var call_id = $("#call_id");
    var campaign_id = $("#outgoing_campaign_id");

    outgoing_div.show();
    customer_number.val(data.to_number);
    dealer_name.val(data.dealer_name);
    customer_name.val(data.customer_name);
    campaign_name.val(data.campaign_name);
    caller_id.val(data.from_number);
    outgoing_call_id.val(data.call_id);
    campaign_id.val(data.campaign_id);    

    if(call_id){
        call_id.val(data.call_id);
    };
};

function PusherTwilioIncoming(channel, options) {
    options = options || {};

    this.settings = {
        eventName: 'twilio_incoming'
    };

    $.extend(this.settings, options);

    var self = this;
    channel.bind(this.settings.eventName, function(data){ self._handleNotification(data); });
};
PusherTwilioIncoming.prototype._handleNotification = function(data) {

    // console.log(data);

    if ($('#open-twilio-incoming-call') && $('#open-twilio-incoming-call').length > 0) {
        $('#incoming_customer_phone_number')[0].value = data.from_number
        $('#incoming_dealer_name')[0].value = data.dealer_name
        $('#incoming_campaign_name')[0].value = data.campaign_name
        $('#incoming_customer_name')[0].value = data.customer_name
        $('#incoming_campaign_id')[0].value = data.campaign_id
        $('#incoming_call_id')[0].value = data.call_id
        $('#incoming_pusher_call_id')[0].value = data.pusher_call_id

        if (data.customers.length === 1) {
            $('#incoming_customer_id')[0].value = data.customers[0]  
        }

        $('#open-twilio-incoming-call').click();   
    }
};

function PusherAnswerIncomingCall(channel, options) {
    options = options || {};

    this.settings = {
        eventName: 'answer_incoming_call'
    };

    $.extend(this.settings, options);

    var self = this;
    channel.bind(this.settings.eventName, function(data){ self._handleNotification(data); });
};

function appendCallResponse(customerName, customerId, campaignId) {
    return '<div class="panel-body">' + 
                '<div class="pull-left m-left-sm">' + 
                    '<strong class="font-14">' + 
                        '<i class="fa fa-phone">' + 
                            ' ' + customerName + 
                        '</i>' + 
                    '</strong>' + 
                    '<br>' + 
                    '<div class="seperator">' + 
                    '</div>' + 
                    '<a href="/enroll_campaign_customer?customer_id=' + customerId + '&campaign_id=' + campaignId + '" class="btn btn-xs btn-primary">' + 
                        'Complete Survey' + 
                    '</a>' + 
                '</div>' + 
            '</div>';
};

function appendSearch(campaignId) {
    return '<div class="panel-body">' + 
                '<div class="pull-left m-left-sm">' + 
                    '<p class="font-14">' + 
                      'Search For Customer' +
                    '</p>' + 
                    '<a href="/search?campaign_id=' + campaignId + '" class="btn btn-xs btn-primary">' + 
                        'Search' + 
                    '</a>' + 
                '</div>' + 
            '</div>';
};

function appendMessage() {
    return '<div class="panel-body">' + 
                '<div class="pull-left m-left-sm">' + 
                    '<p class="font-14">' + 
                      'No Results Found' + 
                    '</p>' + 
                '</div>' + 
            '</div>';
};

function getAnswerCallResponse(data) {
    if (data.customer_array.length > 0) {
        for(var i = 0; i < data.customer_array.length; i++) {
            $('.sidr.right#sidr-right .panel.panel-default').append(appendCallResponse(data.customer_array[i].customer_name, data.customer_array[i].customer_id, data.campaign_id));
        };
    }

    else {
        $('.sidr.right#sidr-right .panel.panel-default').append(appendMessage());
    }

    $('.sidr.right#sidr-right .panel.panel-default').append(appendSearch(data.campaign_id));
}

function failedResponse() {
    console.log("Something went wrong!!");
}

PusherAnswerIncomingCall.prototype._handleNotification = function(data) {
    // console.log(data);
    // console.log("inside incoming call");

    // debugger;

    // if (data.from_number && data.from_number.length > 0) {

    //     debugger

    //     // var ajaxRequest = $.ajax({
    //     //     url: '/pusher_call_details/',
    //     //     type: 'get',
    //     //     data: { pusher_call_id: data.pusher_call_id },
    //     //     dataType: 'json'
    //     // });

    //     ajaxRequest.done(getAnswerCallResponse);
    //     ajaxRequest.fail(failedResponse);
    // }

    // if ($('#agent_client') && $('#agent_client').length == 0) {
    //     $('#right-menu')[0].click();
    // }   
};

function PusherPresenceNotifier(channel, options) {
    options = options || {};

    this.settings = {
        eventName: 'presence'
    };

    $.extend(this.settings, options);

    var self = this;
    channel.bind(this.settings.eventName, function(data){ self._handleNotification(data); });

    channel.bind('pusher:subscription_succeeded', function(members) {

    });

    channel.bind('pusher:subscription_error', function(status) {

    });

    channel.bind('pusher:member_added', function(member) {
    });

    channel.bind('pusher:member_removed', function(member) {
    });
};


function AgentStatusUpdateNotifier(channel, options) {
    options = options || {};

    this.settings = {
        eventName: 'agent_status'
    };

    $.extend(this.settings, options);

    var self = this;
    channel.bind(this.settings.eventName, function(data){ self._handleNotification(data); });
};


AgentStatusUpdateNotifier.prototype._handleNotification = function(data) {
    // console.log(data);
    // console.log("inside the agent status")
    // console.log(data.user_id);

    // var agent_div = document.getElementById('status-' + data.user_id);

    // if(agent_div){
    //     var agent_idle = document.getElementById('idle-' + data.user_id);
    //     agent_div.innerHTML = data.agent_status_name;

    //     switch (data.agent_status_name)
    //     {
    //         case "Available":
    //             div_class = 'label label-success';
    //             break;
    //         case "Wrap Up":
    //             div_class = 'label label-warning';
    //             break;
    //         case "Logged In":
    //             div_class = 'label label-info';
    //             break;
    //         case "Logged Out":
    //             div_class = 'label label-info';
    //             break;
    //         default:
    //             div_class = 'label label-danger';
    //             break;
    //     }

    //         agent_idle.innerHTML = 'Now';

    //     agent_div.className = div_class;
    // };
};

function UpdateCallCount(channel, options) {
    options = options || {};

    this.settings = {
        eventName: 'push_call'
    };

    $.extend(this.settings, options);

    var self = this;
    channel.bind(this.settings.eventName, function(data){ self._handleNotification(data); });  
};

UpdateCallCount.prototype._handleNotification = function(data) {
    // console.log(data);
    // console.log("inside the call update")

    // debugger
    // var inbound_calls_waiting_count = data.inbound_calls_waiting_count;
    // var inbound_calls_waiting_color_status = data.inbound_calls_waiting_color_status
    // var outbound_calls_in_queue_count = data.outbound_calls_in_queue_count;
    // var total_calls_count = data.total_calls_count;
    // var average_hold_time = parseInt(data.average_hold_time);
    // var longest_hold_time = parseInt(data.longest_hold_time);
    // var calls_greater_5_min_count = data.calls_greater_5_min;

    // if (inbound_calls_waiting_count % 1 === 0 && inbound_calls_waiting_count > (-1) && $('#calls_waiting') && $('#calls_waiting').length > 0) {
    //     $('#calls_waiting')[0].innerText = inbound_calls_waiting_count;

    //     // Change color class
    //     if (inbound_calls_waiting_color_status && inbound_calls_waiting_color_status.length > 0) {
    //         removeColorClass('#inbound-calls-waiting-button');

    //         $('#inbound-calls-waiting-button')[0].parentElement.className += inbound_calls_waiting_color_status; 
    //     };
    // };

    // if (outbound_calls_in_queue_count % 1 === 0 && outbound_calls_in_queue_count > (-1) && $('#active_calls') && $('#active_calls').length > 0) {
    //     $('#active_calls')[0].innerText = outbound_calls_in_queue_count;
    // };

    // if (total_calls_count % 1 === 0 && total_calls_count > (-1) && $('#total_calls_today') && $('#total_calls_today').length > 0) {
    //     $('#total_calls_today')[0].innerText = total_calls_count;
    // };

    // if (average_hold_time % 1 === 0 && average_hold_time > (-1) && $('#average_hold_time') && $('#average_hold_time').length > 0) {
    //     $('#average_hold_time')[0].innerText = average_hold_time;
        
    //     var clock = $('#average_hold_time').FlipClock(3600, {
    //         autoStart: false,
    //         clockFace: "MinuteCounter"
    //     });

    //     clock.setTime(average_hold_time);

    //     setUpAverageHoldTimeBoxColor(average_hold_time);
    // }

    // else {
    //     if ($('#average_hold_time') && $('#average_hold_time').length > 0) {
    //         var clock = $('#average_hold_time').FlipClock(3600, {
    //             autoStart: false,
    //             clockFace: "MinuteCounter"
    //         });

    //         clock.setTime(0);

    //         removeColorClass('#average-hold-time-button');
    //         $('#average-hold-time-button')[0].parentElement.className += " bg-success"; 
    //     };
    // }

    // if (longest_hold_time % 1 === 0 && longest_hold_time > (-1) && $('#longest_hold_time') && $('#longest_hold_time').length > 0) {
    //     $('#longest_hold_time')[0].innerText = longest_hold_time;
        
    //     if (longest_hold_time === 0) {
    //         var clock = $('#longest_hold_time').FlipClock(3600, {
    //             autoStart: false,
    //             clockFace: "MinuteCounter"
    //         });

    //         clock.setTime(0);
    //     }

    //     else {
    //         var clock = $('#longest_hold_time').FlipClock(3600, {
    //             clockFace: "MinuteCounter"
    //         });

    //         clock.setTime(longest_hold_time);
    //     }

    //     setUpLongestHoldTimeBoxColor(longest_hold_time);
    // }

    // else {
    //     if ($('#longest_hold_time') && $('#longest_hold_time').length > 0) {
    //         var clock = $('#longest_hold_time').FlipClock(3600, {
    //             autoStart: false,
    //             clockFace: "MinuteCounter"
    //         });

    //         clock.setTime(0);

    //         removeColorClass('#longest-hold-time-button');
    //         $('#longest-hold-time-button')[0].parentElement.className += " bg-success"; 
    //     };
    // }

    // if (calls_greater_5_min_count % 1 === 0 && calls_greater_5_min_count > (-1) && $('#calls_greater_5_min') && $('#calls_greater_5_min').length > 0) {
    //     $('#calls_greater_5_min')[0].innerText = calls_greater_5_min_count;
    // };  
};

function UpdateUserAgentCount(channel, options) {
    options = options || {};

    this.settings = {
        eventName: 'user_status'
    };

    $.extend(this.settings, options);

    var self = this;
    channel.bind(this.settings.eventName, function(data){ self._handleNotification(data); });  
};

UpdateUserAgentCount.prototype._handleNotification = function(data) {
    // console.log(data);
    // console.log("inside the user status")

    // var online_agents_count = data.online_agents_count;
    // var online_agents_color_status = data.online_agents_color_status;
    // var agents_on_calls_count = data.agents_on_calls_count;
    // var idle_agents_count = data.idle_agents_count;
    // var idle_agents_color_status = data.idle_agents_color_status;

    // if (online_agents_count % 1 == 0 && online_agents_count > (-1) && $('#agents_logged_in') && $('#agents_logged_in').length > 0) {
    //     $('#agents_logged_in')[0].innerText = online_agents_count;

    //     if (online_agents_color_status && online_agents_color_status.length > 0) {
    //         removeColorClass('#agents-online-button');

    //         $('#agents-online-button')[0].parentElement.className += online_agents_color_status; 
    //     };
    // };

    // if (agents_on_calls_count % 1 == 0 && agents_on_calls_count > (-1) && $('#agents_on_calls') && $('#agents_on_calls').length > 0) {
    //     $('#agents_on_calls')[0].innerText = agents_on_calls_count;
    // };

    // if (idle_agents_count % 1 == 0 && idle_agents_count > (-1) && $('#agents_on_idle') && $('#agents_on_idle').length > 0) {
    //     $('#agents_on_idle')[0].innerText = idle_agents_count;

    //     if (idle_agents_color_status && idle_agents_color_status.length > 0) {
    //         removeColorClass('#agents-idle-button');

    //         $('#agents-idle-button')[0].parentElement.className += idle_agents_color_status; 
    //     };
    // };
};

function CallNotifier(channel, options) {
    options = options || {};

    this.settings = {
        eventName: 'call_status'
    };

    $.extend(this.settings, options);

    var self = this;
    channel.bind(this.settings.eventName, function(data){ self._handleNotification(data); });
};


CallNotifier.prototype._handleNotification = function(data) {
    var call_list = document.getElementById("call-list");
    if(call_list){
        var call_row = document.getElementById('status-row-' + data.call_id);

        // console.log("this is the data for the call list");
        // console.log(data);

        if (call_row) {
          call_row.style.display = 'none';
        };

        var new_row = call_list.insertRow(0);
        new_row.className = 'status-row';
        new_row.id = 'status-row-' + data.call_id;
        var direction = new_row.insertCell(0);
        var from_number = new_row.insertCell(1);
        var to_number = new_row.insertCell(2);
        var call_queue_name = new_row.insertCell(3);
        var call_time = new_row.insertCell(4);
        var call_status = new_row.insertCell(5);

        direction.innerHTML = data.direction;
        from_number.innerHTML = data.from_number;
        to_number.innerHTML = data.to_number;
        call_queue_name.innerHTML = data.call_queue_name;
        call_time.innerHTML = 'Now';
        call_status.innerHTML = '<span class="label label-warning">' + data.call_status + '</span>';
    };
    var call_queue_list = document.getElementById("call-queue-list");
    if(call_queue_list){
        var call_row = document.getElementById('status-row-' + data.call_id);

        // console.log("this is the data for call queue list");
        // console.log(data);

        if (call_row) {
            call_row.style.display = 'none';
        };

        var new_row = call_queue_list.insertRow(0);
        new_row.className = 'status-row';
        new_row.id = 'status-row-' + data.call_id;
        var from_number = new_row.insertCell(0);
        var call_status = new_row.insertCell(1);
        var call_time = new_row.insertCell(2);
        var agent = new_row.insertCell(3);


        from_number.innerHTML = data.from_number;
        call_status.innerHTML = data.call_status;
        call_time.innerHTML = 'Now';
        agent.innerHTML = data.agent_name;

    };
};

function MailboxerNotifier(channel, options) {
    options = options || {};

    this.settings = {
        eventName: 'mailboxer'
    };

    $.extend(this.settings, options);
    console.log(options);

    var self = this;
    channel.bind(this.settings.eventName, function(data){ self._handleNotification(data); });
};

MailboxerNotifier.prototype._handleNotification = function(data) {
    var unreadMessageDiv = $(".unread-message-alert");
    if(parseInt(data.unread_messages_count) > 0) {
        unreadMessageDiv[0].style.display = "inline";
        unreadMessageDiv[0].innerHTML = data.unread_messages_count;
        return $.gritter.add({
            title: "<i class=\"fa fa-envelope-o\"></i> " + data.notice,
            text: "<a href ='/messages'>Click Here to view.</a>",
            sticky: false,
            time: "",
            class_name: "gritter-notice"
        });
    }

    else {
        unreadMessageDiv[0].style.display = "none";
    }
};