import 'dart:io';

import 'package:happy_hour_server/server/filter_chain.dart';
import 'package:happy_hour_server/server/request_dispatcher.dart';
import 'package:happy_hour_server/server/request_filter.dart';
import 'package:happy_hour_server/server/response.dart';

class Router {

	List<FilterChain> _routes = <FilterChain>[];

	void addRoute(String route, {
		List<RequestFilter> filters = const <RequestFilter>[],
		RequestDispatcher? dispatcher = null
	}) {
		_routes.add(FilterChain()
			..path = route
			..filters = filters
			..dispatcher = dispatcher);
	}

	Future handle(HttpRequest request) async {
		for (FilterChain filterChain in _routes) {
			if (request.uri.path.startsWith(filterChain.path)) {
				return await filterChain.handle(request);
			}
		}
		return await Response.notImplemented(request);
	}

}