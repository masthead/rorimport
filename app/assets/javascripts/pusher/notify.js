$(function() {
    var pusher = new Pusher(PUSHER_CONFIG.APP_KEY,{
        authTransport: 'jsonp',
        authEndpoint: PUSHER_CONFIG.AUTH_END_POINT
    });
    var private_channel = pusher.subscribe(PUSHER_CONFIG.PRIVATE_CHANNEL);
    var presence_channel = pusher.subscribe(PUSHER_CONFIG.PRESENCE_CHANNEL);
    var public_channel = pusher.subscribe(PUSHER_CONFIG.PUBLIC_CHANNEL);

    var private_notifier = new PusherPrivateNotifier(private_channel);
    var presence_notifier = new PusherPresenceNotifier(presence_channel);
    var agent_status_notifier = new AgentStatusUpdateNotifier(public_channel);
    var call_notifier = new CallNotifier(public_channel);
    var twilio_incoming_notifier = new PusherTwilioIncoming(private_channel);
    var twilio_outgoing_notifier = new PusherTwilioOutgoing(private_channel);
    var mailboxer_notifier = new MailboxerNotifier(private_channel);
    var answer_incoming_call = new PusherAnswerIncomingCall(private_channel);
    var update_call_count = new UpdateCallCount(public_channel);
    var update_user_agent_count = new UpdateUserAgentCount(public_channel);
});