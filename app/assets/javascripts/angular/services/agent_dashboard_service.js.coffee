surveyApp.factory 'AgentDashboardService', ['$resource', '$q', '$http', ($resource, $q, $http) ->

	getAgentDashboard: $resource "/agent_dashboard.json", {}, query: { method: 'GET', isArray: false }

	getCallStats: $resource "/get_call_stats.json", {}, query: { method: 'GET', isArray: false }
	
	getPusherKey: $resource "/pusher_api_key.json", {}, query: { method: 'GET', isArray: false }

	agentStatusRefresh: $resource "/agent_status_refresh.json", {}, query: { method: 'GET', isArray: false }

	inboundCampaignsRefresh: $resource "/inbound_campaigns_refresh.json", {}, query: { method: 'GET', isArray: false }

	outboundCampaignsRefresh: $resource "/outbound_campaigns_refresh.json", {}, query: { method: 'GET', isArray: false }

	getAgentsOnline: $resource "/get_agents_online.json", {}, query: { method: 'GET', isArray: false }

	getIdleAgents: $resource "/get_idle_agents.json", {}, query: { method: 'GET', isArray: false }

	getAgentsOnCalls: $resource "/get_agents_on_calls.json", {}, query: { method: 'GET', isArray: false }

	getAgentsWaiting: $resource "/get_agents_waiting.json", {}, query: { method: 'GET', isArray: false }

	getOutboundCalls: $resource "/get_outbound_calls.json", {}, query: { method: 'GET', isArray: false }

	getInboundCalls: $resource "/get_inbound_calls.json", {}, query: { method: 'GET', isArray: false }

	getTotalCalls: $resource "/get_total_calls_2.json", {}, query: { method: 'GET', isArray: false }

	getUserToken: $resource "/get_user_token.json", {}, query: { method: 'GET', isArray: false }
]