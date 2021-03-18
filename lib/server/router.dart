import 'dart:collection';
import 'dart:io';

import 'package:happy_hour_server/server/request_dispatcher.dart';
import 'package:happy_hour_server/server/response.dart';

class RouterV2 {

	// LinkedHashMap ITERATES IN INSERTION ORDER, CRUCIAL
	final Map<String, RequestDispatcher> _routes = LinkedHashMap<String, RequestDispatcher>();

	void addRoute(final String path, final RequestDispatcher dispatcher) => _routes[path] = dispatcher;

	Future handle(HttpRequest request) {
		for (final MapEntry<String, RequestDispatcher> route in _routes.entries) {
			if (request.uri.path.startsWith(route.key)) {
				return route.value.handle(request);
			}
		}
		return Response.notImplemented(request);
	}

}