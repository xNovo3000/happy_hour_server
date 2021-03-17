import 'dart:io';

import 'package:happy_hour_server/server/request_dispatcher.dart';
import 'package:happy_hour_server/server/request_filter.dart';
import 'package:happy_hour_server/server/response.dart';

class FilterChain {

	String path = '';
	List<RequestFilter> filters = <RequestFilter>[];
	RequestDispatcher? dispatcher;

	Future handle(HttpRequest request) {
		print('test');
		// filter the request
		bool _tmp = false;
		for (RequestFilter filter in filters) {
			_tmp = filter.doFilter(request);
			if (_tmp == false) {
				return filter.onError(request);
			}
		}
		// check if there is the dispatcher
		if (dispatcher == null) {
			return Response.notImplemented(request);
		}
		// dispatch the request
		switch (request.method) {
			case 'GET': return dispatcher!.doGet(request);
			case 'POST': return dispatcher!.doPost(request);
			case 'HEAD': return dispatcher!.doHead(request);
			case 'PATCH': return dispatcher!.doPatch(request);
			case 'DELETE': return dispatcher!.doDelete(request);
			default: return Response.notImplemented(request);
		}
	}

}